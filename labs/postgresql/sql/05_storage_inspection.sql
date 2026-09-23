-- Стандартний розмір сторінки PostgreSQL.
SELECT current_setting('block_size') AS block_size_bytes;

-- Фізичний шлях до relation — об'єкта зберігання таблиці.
-- Тут буде один шлях для таблиці orders, а не дев'ять шляхів для колонок.
SELECT
    pg_relation_filepath('tpch.orders') AS table_file_path;

-- Окремо порівнюємо розмір самої таблиці та її індексів.
SELECT
    pg_size_pretty(pg_relation_size('tpch.orders')) AS table_data_size,
    pg_size_pretty(pg_indexes_size('tpch.orders')) AS indexes_size,
    pg_size_pretty(pg_total_relation_size('tpch.orders')) AS total_size;

-- Індекси є окремими relations зі своїми фізичними шляхами.
SELECT
    indexrelid::regclass AS index_name,
    pg_relation_filepath(indexrelid) AS index_file_path
FROM pg_index
WHERE indrelid = 'tpch.orders'::regclass;