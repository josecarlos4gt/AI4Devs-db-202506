--
-- Script de migración para el sistema de seguimiento de talento
-- Fecha: 2025-07-27
--
-- Este script implementa:
-- 1. Nuevas tablas para el proceso de reclutamiento
-- 2. Índices optimizados para consultas frecuentes
-- 3. Restricciones de integridad referencial
-- 4. Modificaciones a tablas existentes
--

-- Tabla base para la jerarquía organizacional
-- Almacena información de las empresas que usan el sistema
CREATE TABLE "Company" (
    "id" SERIAL PRIMARY KEY,
    "name" VARCHAR(100) NOT NULL
);

-- Tabla para empleados de las empresas
-- Incluye reclutadores y personal involucrado en el proceso de contratación
CREATE TABLE "Employee" (
    "id" SERIAL PRIMARY KEY,
    "company_id" INTEGER NOT NULL,
    "name" VARCHAR(100) NOT NULL,
    "email" VARCHAR(255) NOT NULL,
    "role" VARCHAR(50) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    CONSTRAINT "fk_employee_company" FOREIGN KEY ("company_id") REFERENCES "Company"("id")
);

-- Tabla central para posiciones de trabajo
-- Contiene toda la información relacionada con las ofertas laborales
-- Incluye campos para descripción detallada, requisitos y beneficios
CREATE TABLE "Position" (
    "id" SERIAL PRIMARY KEY,
    "company_id" INTEGER NOT NULL,
    "interview_flow_id" INTEGER NOT NULL,
    "title" VARCHAR(200) NOT NULL,
    "description" TEXT,                    -- Descripción general de la posición
    "status" VARCHAR(50) NOT NULL,         -- ej: active, closed, draft
    "is_visible" BOOLEAN NOT NULL DEFAULT true,
    "location" VARCHAR(100) NOT NULL,
    "job_description" TEXT NOT NULL,       -- Descripción detallada del trabajo
    "requirements" TEXT NOT NULL,          -- Requisitos específicos del puesto
    "responsibilities" TEXT NOT NULL,       -- Responsabilidades del cargo
    "salary_min" DECIMAL(10,2) NOT NULL,   -- Rango salarial mínimo
    "salary_max" DECIMAL(10,2) NOT NULL,   -- Rango salarial máximo
    "employment_type" VARCHAR(50) NOT NULL, -- ej: full-time, part-time, contract
    "benefits" TEXT NOT NULL,              -- Beneficios ofrecidos
    "company_description" TEXT NOT NULL,    -- Descripción de la empresa para esta posición
    "application_deadline" TIMESTAMP NOT NULL,
    "contact_info" VARCHAR(255) NOT NULL,
    CONSTRAINT "fk_position_company" FOREIGN KEY ("company_id") REFERENCES "Company"("id"),
    CONSTRAINT "fk_position_interview_flow" FOREIGN KEY ("interview_flow_id") REFERENCES "InterviewFlow"("id")
);

-- CreateTable
CREATE TABLE "InterviewFlow" (
    "id" SERIAL PRIMARY KEY,
    "description" TEXT NOT NULL
);

-- CreateTable
CREATE TABLE "InterviewStep" (
    "id" SERIAL PRIMARY KEY,
    "interview_flow_id" INTEGER NOT NULL,
    "interview_type_id" INTEGER NOT NULL,
    "name" VARCHAR(100) NOT NULL,
    "order_index" INTEGER NOT NULL,
    CONSTRAINT "fk_interview_step_flow" FOREIGN KEY ("interview_flow_id") REFERENCES "InterviewFlow"("id"),
    CONSTRAINT "fk_interview_step_type" FOREIGN KEY ("interview_type_id") REFERENCES "InterviewType"("id")
);

-- CreateTable
CREATE TABLE "InterviewType" (
    "id" SERIAL PRIMARY KEY,
    "name" VARCHAR(100) NOT NULL,
    "description" TEXT NOT NULL
);

-- Modificar tabla Candidate existente con manejo de datos
-- Primero renombramos las columnas existentes
ALTER TABLE "Candidate" 
    RENAME COLUMN "firstName" TO "first_name_old",
    RENAME COLUMN "lastName" TO "last_name_old";

-- Agregar las nuevas columnas permitiendo NULL temporalmente
ALTER TABLE "Candidate" 
    ADD COLUMN "first_name" VARCHAR(100),
    ADD COLUMN "last_name" VARCHAR(100);

-- Copiar los datos existentes
UPDATE "Candidate"
SET "first_name" = "first_name_old",
    "last_name" = "last_name_old";

-- Hacer las columnas NOT NULL después de la migración de datos
ALTER TABLE "Candidate" 
    ALTER COLUMN "first_name" SET NOT NULL,
    ALTER COLUMN "last_name" SET NOT NULL,
    ALTER COLUMN "email" TYPE VARCHAR(255),
    ALTER COLUMN "phone" TYPE VARCHAR(15),
    ALTER COLUMN "address" TYPE VARCHAR(200);

-- Eliminar las columnas antiguas
ALTER TABLE "Candidate"
    DROP COLUMN "first_name_old",
    DROP COLUMN "last_name_old";

-- CreateTable
CREATE TABLE "Application" (
    "id" SERIAL PRIMARY KEY,
    "position_id" INTEGER NOT NULL,
    "candidate_id" INTEGER NOT NULL,
    "application_date" TIMESTAMP NOT NULL,
    "status" VARCHAR(50) NOT NULL,
    "notes" TEXT,
    CONSTRAINT "fk_application_position" FOREIGN KEY ("position_id") REFERENCES "Position"("id"),
    CONSTRAINT "fk_application_candidate" FOREIGN KEY ("candidate_id") REFERENCES "Candidate"("id")
);

-- CreateTable
CREATE TABLE "Interview" (
    "id" SERIAL PRIMARY KEY,
    "application_id" INTEGER NOT NULL,
    "interview_step_id" INTEGER NOT NULL,
    "employee_id" INTEGER NOT NULL,
    "interview_date" TIMESTAMP NOT NULL,
    "result" VARCHAR(50),
    "score" INTEGER,
    "notes" TEXT,
    CONSTRAINT "fk_interview_application" FOREIGN KEY ("application_id") REFERENCES "Application"("id"),
    CONSTRAINT "fk_interview_step" FOREIGN KEY ("interview_step_id") REFERENCES "InterviewStep"("id"),
    CONSTRAINT "fk_interview_employee" FOREIGN KEY ("employee_id") REFERENCES "Employee"("id")
);

-- Índices optimizados para consultas frecuentes
-- 1. Índices únicos para garantizar integridad
CREATE UNIQUE INDEX "employee_email_key" ON "Employee"("email");  -- Evita duplicados de email

-- 2. Índices para optimizar JOINs y búsquedas frecuentes
CREATE INDEX "employee_company_id_idx" ON "Employee"("company_id");  -- Optimiza búsquedas por empresa

-- 3. Índices para la tabla Position
CREATE INDEX "position_company_id_idx" ON "Position"("company_id");           -- Búsquedas por empresa
CREATE INDEX "position_status_idx" ON "Position"("status");                   -- Filtrado por estado
CREATE INDEX "position_is_visible_idx" ON "Position"("is_visible");          -- Filtrado de visibilidad
CREATE INDEX "position_application_deadline_idx" ON "Position"("application_deadline");  -- Ordenamiento por fecha límite

-- 4. Índices para el flujo de entrevistas
CREATE INDEX "interview_step_flow_id_idx" ON "InterviewStep"("interview_flow_id");  -- Optimiza búsqueda de pasos en un flujo
CREATE INDEX "interview_step_order_idx" ON "InterviewStep"("order_index");         -- Optimiza ordenamiento de pasos

-- 5. Índice compuesto para búsqueda de candidatos por nombre
CREATE INDEX "candidate_name_idx" ON "Candidate"("last_name", "first_name");  -- Optimiza búsquedas por nombre completo

-- 6. Índices para aplicaciones
CREATE INDEX "application_position_id_idx" ON "Application"("position_id");     -- Búsqueda de aplicaciones por posición
CREATE INDEX "application_candidate_id_idx" ON "Application"("candidate_id");   -- Búsqueda de aplicaciones por candidato
CREATE INDEX "application_date_idx" ON "Application"("application_date");      -- Ordenamiento por fecha
CREATE INDEX "application_status_idx" ON "Application"("status");              -- Filtrado por estado

-- 7. Índices para entrevistas
CREATE INDEX "interview_application_id_idx" ON "Interview"("application_id");    -- Búsqueda de entrevistas por aplicación
CREATE INDEX "interview_step_id_idx" ON "Interview"("interview_step_id");       -- Búsqueda por paso de entrevista
CREATE INDEX "interview_employee_id_idx" ON "Interview"("employee_id");         -- Búsqueda por entrevistador
CREATE INDEX "interview_date_idx" ON "Interview"("interview_date");            -- Ordenamiento por fecha
CREATE INDEX "interview_result_idx" ON "Interview"("result");                  -- Filtrado por resultado

-- Migración de datos para la tabla Education
ALTER TABLE "Education"
    ADD COLUMN "start_date" TIMESTAMP,
    ADD COLUMN "candidate_id" INTEGER,
    ADD COLUMN "end_date" TIMESTAMP;

-- Migrar datos existentes de Education
UPDATE "Education"
SET "start_date" = COALESCE("startDate", CURRENT_TIMESTAMP),
    "candidate_id" = "candidateId",
    "end_date" = "endDate";

-- Establecer las restricciones NOT NULL después de la migración
ALTER TABLE "Education"
    ALTER COLUMN "start_date" SET NOT NULL,
    ALTER COLUMN "candidate_id" SET NOT NULL;

-- Eliminar columnas antiguas de Education
ALTER TABLE "Education"
    DROP COLUMN "startDate",
    DROP COLUMN "candidateId",
    DROP COLUMN "endDate";

-- Migración de datos para la tabla WorkExperience
ALTER TABLE "WorkExperience"
    ADD COLUMN "start_date" TIMESTAMP,
    ADD COLUMN "candidate_id" INTEGER,
    ADD COLUMN "end_date" TIMESTAMP;

-- Migrar datos existentes de WorkExperience
UPDATE "WorkExperience"
SET "start_date" = COALESCE("startDate", CURRENT_TIMESTAMP),
    "candidate_id" = "candidateId",
    "end_date" = "endDate";

-- Establecer las restricciones NOT NULL después de la migración
ALTER TABLE "WorkExperience"
    ALTER COLUMN "start_date" SET NOT NULL,
    ALTER COLUMN "candidate_id" SET NOT NULL;

-- Eliminar columnas antiguas de WorkExperience
ALTER TABLE "WorkExperience"
    DROP COLUMN "startDate",
    DROP COLUMN "candidateId",
    DROP COLUMN "endDate";

-- Migración de datos para la tabla Resume
ALTER TABLE "Resume"
    ADD COLUMN "file_path" VARCHAR(500),
    ADD COLUMN "file_type" VARCHAR(50),
    ADD COLUMN "upload_date" TIMESTAMP,
    ADD COLUMN "candidate_id" INTEGER;

-- Migrar datos existentes de Resume
UPDATE "Resume"
SET "file_path" = COALESCE("filePath", 'legacy_file_' || id::text),
    "file_type" = COALESCE("fileType", 'application/octet-stream'),
    "upload_date" = COALESCE("uploadDate", CURRENT_TIMESTAMP),
    "candidate_id" = "candidateId";

-- Establecer las restricciones NOT NULL después de la migración
ALTER TABLE "Resume"
    ALTER COLUMN "file_path" SET NOT NULL,
    ALTER COLUMN "file_type" SET NOT NULL,
    ALTER COLUMN "upload_date" SET NOT NULL,
    ALTER COLUMN "candidate_id" SET NOT NULL;

-- Eliminar columnas antiguas de Resume
ALTER TABLE "Resume"
    DROP COLUMN "filePath",
    DROP COLUMN "fileType",
    DROP COLUMN "uploadDate",
    DROP COLUMN "candidateId";

-- 8. Índices para tablas relacionadas con el perfil del candidato
CREATE INDEX "education_candidate_id_idx" ON "Education"("candidate_id");
CREATE INDEX "work_experience_candidate_id_idx" ON "WorkExperience"("candidate_id");
CREATE INDEX "resume_candidate_id_idx" ON "Resume"("candidate_id");
CREATE INDEX "resume_upload_date_idx" ON "Resume"("upload_date");
