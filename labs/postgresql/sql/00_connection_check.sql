-- 00_connection_check.sql
--
-- Призначення:
-- перевірити, до якого PostgreSQL-сервера, database, user і schema
-- підключена поточна SQL-сесія.
--
-- Цей файл корисно виконувати після:
-- 1. першого підключення;
-- 2. повторного запуску контейнера;
-- 3. зміни credentials або connection settings;
-- 4. підключення до нового environment.

SELECT
    -- Повна версія PostgreSQL та інформація про платформу.
    version() AS server_version,

    -- Назва database, до якої підключена поточна сесія.
    current_database() AS database_name,

    -- PostgreSQL role, від імені якої виконується запит.
    current_user AS user_name,

    -- Schema, у якій PostgreSQL за замовчуванням шукає об'єкти.
    current_schema() AS schema_name,

    -- Внутрішня мережева адреса PostgreSQL-сервера.
    -- У Docker це може бути адреса контейнера, а не localhost.
    inet_server_addr() AS server_address,

    -- Порт, на якому PostgreSQL прийняв connection.
    inet_server_port() AS server_port;