-- 01_catalog_navigation.sql
--
-- Призначення:
-- навчитися отримувати metadata про PostgreSQL-об'єкти
-- не лише через графічний Database Explorer, а й через SQL.
--
-- pg_catalog — PostgreSQL-specific системний catalog.
-- information_schema — стандартизоване SQL-представлення metadata.


-- ============================================================
-- 1. Користувацькі таблиці
-- ============================================================
--
-- Виводимо таблиці, крім системних schemas PostgreSQL.

SELECT
    -- Schema, у якій знаходиться таблиця.
    schemaname,

    -- Назва таблиці.
    tablename,

    -- PostgreSQL role, яка володіє таблицею.
    tableowner
FROM pg_catalog.pg_tables
WHERE schemaname NOT IN ('pg_catalog', 'information_schema')
ORDER BY schemaname, tablename;


-- ============================================================
-- 2. Columns таблиці public.persistence_check
-- ============================================================
--
-- Виводимо структуру columns у тому порядку,
-- в якому вони оголошені в таблиці.

SELECT
    -- Позиція column у структурі таблиці: 1, 2, 3...
    ordinal_position,

    -- Назва column.
    column_name,

    -- SQL data type column.
    data_type,

    -- Чи дозволене значення NULL.
    is_nullable
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name = 'persistence_check'
ORDER BY ordinal_position;


-- ============================================================
-- 3. Constraints таблиці public.persistence_check
-- ============================================================
--
-- Виводимо правила цілісності, визначені для таблиці:
-- PRIMARY KEY, UNIQUE, FOREIGN KEY, CHECK та інші.

SELECT
    -- Системне або явно задане ім'я constraint.
    constraint_name,

    -- Тип constraint.
    constraint_type
FROM information_schema.table_constraints
WHERE table_schema = 'public'
  AND table_name = 'persistence_check'
ORDER BY constraint_type, constraint_name;