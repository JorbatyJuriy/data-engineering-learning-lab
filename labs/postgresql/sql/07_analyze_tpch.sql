-- ANALYZE збирає статистику про розподіл даних.
-- PostgreSQL planner використовує її, щоб обирати план виконання запитів.

ANALYZE VERBOSE tpch.region;
ANALYZE VERBOSE tpch.nation;
ANALYZE VERBOSE tpch.supplier;
ANALYZE VERBOSE tpch.customer;
ANALYZE VERBOSE tpch.part;
ANALYZE VERBOSE tpch.partsupp;
ANALYZE VERBOSE tpch.orders;
ANALYZE VERBOSE tpch.lineitem;

-- Перевіряємо, що статистику дійсно зібрано.
SELECT
    relname AS table_name,
    n_live_tup AS estimated_rows,
    last_analyze
FROM pg_stat_user_tables
WHERE schemaname = 'tpch'
ORDER BY relname;