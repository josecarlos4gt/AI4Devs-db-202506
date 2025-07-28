/*
  Warnings:

  - You are about to drop the column `firstName` on the `Candidate` table. All the data in the column will be lost.
  - You are about to drop the column `lastName` on the `Candidate` table. All the data in the column will be lost.
  - You are about to drop the column `candidateId` on the `Education` table. All the data in the column will be lost.
  - You are about to drop the column `endDate` on the `Education` table. All the data in the column will be lost.
  - You are about to drop the column `startDate` on the `Education` table. All the data in the column will be lost.
  - You are about to drop the column `candidateId` on the `Resume` table. All the data in the column will be lost.
  - You are about to drop the column `filePath` on the `Resume` table. All the data in the column will be lost.
  - You are about to drop the column `fileType` on the `Resume` table. All the data in the column will be lost.
  - You are about to drop the column `uploadDate` on the `Resume` table. All the data in the column will be lost.
  - You are about to drop the column `candidateId` on the `WorkExperience` table. All the data in the column will be lost.
  - You are about to drop the column `endDate` on the `WorkExperience` table. All the data in the column will be lost.
  - You are about to drop the column `startDate` on the `WorkExperience` table. All the data in the column will be lost.
  - Added the required column `first_name` to the `Candidate` table without a default value. This is not possible if the table is not empty.
  - Added the required column `last_name` to the `Candidate` table without a default value. This is not possible if the table is not empty.
  - Added the required column `candidate_id` to the `Education` table without a default value. This is not possible if the table is not empty.
  - Added the required column `start_date` to the `Education` table without a default value. This is not possible if the table is not empty.
  - Added the required column `candidate_id` to the `Resume` table without a default value. This is not possible if the table is not empty.
  - Added the required column `file_path` to the `Resume` table without a default value. This is not possible if the table is not empty.
  - Added the required column `file_type` to the `Resume` table without a default value. This is not possible if the table is not empty.
  - Added the required column `upload_date` to the `Resume` table without a default value. This is not possible if the table is not empty.
  - Added the required column `candidate_id` to the `WorkExperience` table without a default value. This is not possible if the table is not empty.
  - Added the required column `start_date` to the `WorkExperience` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "Education" DROP CONSTRAINT "Education_candidateId_fkey";

-- DropForeignKey
ALTER TABLE "Resume" DROP CONSTRAINT "Resume_candidateId_fkey";

-- DropForeignKey
ALTER TABLE "WorkExperience" DROP CONSTRAINT "WorkExperience_candidateId_fkey";

-- AlterTable
ALTER TABLE "Candidate" DROP COLUMN "firstName",
DROP COLUMN "lastName",
ADD COLUMN     "first_name" VARCHAR(100) NOT NULL,
ADD COLUMN     "last_name" VARCHAR(100) NOT NULL,
ALTER COLUMN "address" SET DATA TYPE VARCHAR(200);

-- AlterTable
ALTER TABLE "Education" DROP COLUMN "candidateId",
DROP COLUMN "endDate",
DROP COLUMN "startDate",
ADD COLUMN     "candidate_id" INTEGER NOT NULL,
ADD COLUMN     "end_date" TIMESTAMP(3),
ADD COLUMN     "start_date" TIMESTAMP(3) NOT NULL;

-- AlterTable
ALTER TABLE "Resume" DROP COLUMN "candidateId",
DROP COLUMN "filePath",
DROP COLUMN "fileType",
DROP COLUMN "uploadDate",
ADD COLUMN     "candidate_id" INTEGER NOT NULL,
ADD COLUMN     "file_path" VARCHAR(500) NOT NULL,
ADD COLUMN     "file_type" VARCHAR(50) NOT NULL,
ADD COLUMN     "upload_date" TIMESTAMP(3) NOT NULL;

-- AlterTable
ALTER TABLE "WorkExperience" DROP COLUMN "candidateId",
DROP COLUMN "endDate",
DROP COLUMN "startDate",
ADD COLUMN     "candidate_id" INTEGER NOT NULL,
ADD COLUMN     "end_date" TIMESTAMP(3),
ADD COLUMN     "start_date" TIMESTAMP(3) NOT NULL,
ALTER COLUMN "description" SET DATA TYPE TEXT;

-- CreateTable
CREATE TABLE "Company" (
    "id" SERIAL NOT NULL,
    "name" VARCHAR(100) NOT NULL,

    CONSTRAINT "Company_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Employee" (
    "id" SERIAL NOT NULL,
    "company_id" INTEGER NOT NULL,
    "name" VARCHAR(100) NOT NULL,
    "email" VARCHAR(255) NOT NULL,
    "role" VARCHAR(50) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "Employee_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Position" (
    "id" SERIAL NOT NULL,
    "company_id" INTEGER NOT NULL,
    "interview_flow_id" INTEGER NOT NULL,
    "title" VARCHAR(200) NOT NULL,
    "description" TEXT,
    "status" VARCHAR(50) NOT NULL,
    "is_visible" BOOLEAN NOT NULL DEFAULT true,
    "location" VARCHAR(100) NOT NULL,
    "job_description" TEXT NOT NULL,
    "requirements" TEXT NOT NULL,
    "responsibilities" TEXT NOT NULL,
    "salary_min" DECIMAL(10,2) NOT NULL,
    "salary_max" DECIMAL(10,2) NOT NULL,
    "employment_type" VARCHAR(50) NOT NULL,
    "benefits" TEXT NOT NULL,
    "company_description" TEXT NOT NULL,
    "application_deadline" TIMESTAMP(3) NOT NULL,
    "contact_info" VARCHAR(255) NOT NULL,

    CONSTRAINT "Position_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "InterviewFlow" (
    "id" SERIAL NOT NULL,
    "description" TEXT NOT NULL,

    CONSTRAINT "InterviewFlow_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "InterviewStep" (
    "id" SERIAL NOT NULL,
    "interview_flow_id" INTEGER NOT NULL,
    "interview_type_id" INTEGER NOT NULL,
    "name" VARCHAR(100) NOT NULL,
    "order_index" INTEGER NOT NULL,

    CONSTRAINT "InterviewStep_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "InterviewType" (
    "id" SERIAL NOT NULL,
    "name" VARCHAR(100) NOT NULL,
    "description" TEXT NOT NULL,

    CONSTRAINT "InterviewType_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Application" (
    "id" SERIAL NOT NULL,
    "position_id" INTEGER NOT NULL,
    "candidate_id" INTEGER NOT NULL,
    "application_date" TIMESTAMP(3) NOT NULL,
    "status" VARCHAR(50) NOT NULL,
    "notes" TEXT,

    CONSTRAINT "Application_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Interview" (
    "id" SERIAL NOT NULL,
    "application_id" INTEGER NOT NULL,
    "interview_step_id" INTEGER NOT NULL,
    "employee_id" INTEGER NOT NULL,
    "interview_date" TIMESTAMP(3) NOT NULL,
    "result" VARCHAR(50),
    "score" INTEGER,
    "notes" TEXT,

    CONSTRAINT "Interview_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Employee_email_key" ON "Employee"("email");

-- CreateIndex
CREATE INDEX "Employee_company_id_idx" ON "Employee"("company_id");

-- CreateIndex
CREATE INDEX "Position_company_id_idx" ON "Position"("company_id");

-- CreateIndex
CREATE INDEX "Position_status_idx" ON "Position"("status");

-- CreateIndex
CREATE INDEX "Position_is_visible_idx" ON "Position"("is_visible");

-- CreateIndex
CREATE INDEX "Position_application_deadline_idx" ON "Position"("application_deadline");

-- CreateIndex
CREATE INDEX "InterviewStep_interview_flow_id_idx" ON "InterviewStep"("interview_flow_id");

-- CreateIndex
CREATE INDEX "InterviewStep_order_index_idx" ON "InterviewStep"("order_index");

-- CreateIndex
CREATE INDEX "Application_position_id_idx" ON "Application"("position_id");

-- CreateIndex
CREATE INDEX "Application_candidate_id_idx" ON "Application"("candidate_id");

-- CreateIndex
CREATE INDEX "Application_application_date_idx" ON "Application"("application_date");

-- CreateIndex
CREATE INDEX "Application_status_idx" ON "Application"("status");

-- CreateIndex
CREATE INDEX "Interview_application_id_idx" ON "Interview"("application_id");

-- CreateIndex
CREATE INDEX "Interview_interview_step_id_idx" ON "Interview"("interview_step_id");

-- CreateIndex
CREATE INDEX "Interview_employee_id_idx" ON "Interview"("employee_id");

-- CreateIndex
CREATE INDEX "Interview_interview_date_idx" ON "Interview"("interview_date");

-- CreateIndex
CREATE INDEX "Interview_result_idx" ON "Interview"("result");

-- CreateIndex
CREATE INDEX "Candidate_last_name_first_name_idx" ON "Candidate"("last_name", "first_name");

-- CreateIndex
CREATE INDEX "Education_candidate_id_idx" ON "Education"("candidate_id");

-- CreateIndex
CREATE INDEX "Resume_candidate_id_idx" ON "Resume"("candidate_id");

-- CreateIndex
CREATE INDEX "Resume_upload_date_idx" ON "Resume"("upload_date");

-- CreateIndex
CREATE INDEX "WorkExperience_candidate_id_idx" ON "WorkExperience"("candidate_id");

-- AddForeignKey
ALTER TABLE "Employee" ADD CONSTRAINT "Employee_company_id_fkey" FOREIGN KEY ("company_id") REFERENCES "Company"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Position" ADD CONSTRAINT "Position_company_id_fkey" FOREIGN KEY ("company_id") REFERENCES "Company"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Position" ADD CONSTRAINT "Position_interview_flow_id_fkey" FOREIGN KEY ("interview_flow_id") REFERENCES "InterviewFlow"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "InterviewStep" ADD CONSTRAINT "InterviewStep_interview_flow_id_fkey" FOREIGN KEY ("interview_flow_id") REFERENCES "InterviewFlow"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "InterviewStep" ADD CONSTRAINT "InterviewStep_interview_type_id_fkey" FOREIGN KEY ("interview_type_id") REFERENCES "InterviewType"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Application" ADD CONSTRAINT "Application_position_id_fkey" FOREIGN KEY ("position_id") REFERENCES "Position"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Application" ADD CONSTRAINT "Application_candidate_id_fkey" FOREIGN KEY ("candidate_id") REFERENCES "Candidate"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Interview" ADD CONSTRAINT "Interview_application_id_fkey" FOREIGN KEY ("application_id") REFERENCES "Application"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Interview" ADD CONSTRAINT "Interview_interview_step_id_fkey" FOREIGN KEY ("interview_step_id") REFERENCES "InterviewStep"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Interview" ADD CONSTRAINT "Interview_employee_id_fkey" FOREIGN KEY ("employee_id") REFERENCES "Employee"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Education" ADD CONSTRAINT "Education_candidate_id_fkey" FOREIGN KEY ("candidate_id") REFERENCES "Candidate"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WorkExperience" ADD CONSTRAINT "WorkExperience_candidate_id_fkey" FOREIGN KEY ("candidate_id") REFERENCES "Candidate"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Resume" ADD CONSTRAINT "Resume_candidate_id_fkey" FOREIGN KEY ("candidate_id") REFERENCES "Candidate"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
