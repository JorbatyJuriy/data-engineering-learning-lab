-- Перевіряємо фактичну кількість завантажених рядків.

SELECT 'region' AS table_name, COUNT(*) AS row_count
FROM tpch.region

UNION ALL
SELECT 'nation', COUNT(*)
FROM tpch.nation

UNION ALL
SELECT 'supplier', COUNT(*)
FROM tpch.supplier

UNION ALL
SELECT 'customer', COUNT(*)
FROM tpch.customer

UNION ALL
SELECT 'part', COUNT(*)
FROM tpch.part

UNION ALL
SELECT 'partsupp', COUNT(*)
FROM tpch.partsupp

UNION ALL
SELECT 'orders', COUNT(*)
FROM tpch.orders

UNION ALL
SELECT 'lineitem', COUNT(*)
FROM tpch.lineitem

ORDER BY table_name;