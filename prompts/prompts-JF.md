# ❓ Prompts para cambios en base de datos

**IDE y asistente utilizado:** Visual Studio Code y GitHub Copilot con modelo Claude Sonnet 3.5

---

## 1️⃣ PROMPT #1: Refactorización de Base de Datos Relacional

Como experto en bases de datos relacionales, necesito tu ayuda para refactorizar la base de datos de mi proyecto.

Para ello, por favor, realiza lo siguiente:

1.  🔍 **Analiza el contexto del proyecto:**
    * Lee el archivo `Readme.md` para entender el propósito general y la arquitectura del proyecto.
    * Examina el código fuente del proyecto para comprender su lógica de negocio y cómo interactúa con la base de datos.
2.  📝 **Revisa la definición actual de la base de datos:**
    * Lee el archivo `backend/prisma/schema.prisma` para conocer el esquema de base de datos actual.
3.  📊 **Evalúa la propuesta de cambios en el ERD:**
    * Lee el archivo `prompts/ERD.md`, que contiene una propuesta de cambios en el esquema de la base de datos en formato Mermaid.

---

Una vez que tengas este contexto, procede con las siguientes tareas:

1.  ✨ **Normalización del esquema:** Normaliza la propuesta de base de datos (`prompts/ERD.md`) aplicando los principios de normalización relacional (hasta la 3FN o BCNF, según sea apropiado) para eliminar redundancias y mejorar la integridad de los datos.
2.  ⚡ **Optimización de índices:** Identifica las columnas clave y las que se usarán frecuentemente en filtros, ordenamientos y uniones, y genera los índices necesarios para mejorar significativamente el rendimiento de las consultas.
3.  🔄 **Actualización del esquema Prisma:** Aplica los cambios resultantes de la normalización y la adición de índices en el archivo `backend/prisma/schema.prisma`. Asegúrate de que las nuevas definiciones reflejen el esquema optimizado.
4.  📜 **Generación de script de migración:** Crea un archivo `backend/prisma/migrations/cambios.sql` que contenga las instrucciones SQL necesarias para aplicar estos cambios en una base de datos PostgreSQL existente. Este script debe incluir `ALTER TABLE`, `CREATE INDEX`, y cualquier otra sentencia DDL requerida.

---

Si encuentras alguna ambigüedad o necesitas aclaraciones durante este proceso, por favor, házmelo saber.

---

## 2️⃣ PROMPT #2: Revisión de `schema.prisma`

No fueron creados los cambios en `schema.prisma`.

---

## 3️⃣ PROMPT #3: Verificación y Comentarios

Revisa que los archivos `cambios.sql` y `schema.prisma` coincidan y estén optimizados. Además, coloca comentarios en ambos archivos para comprender mejor los cambios.