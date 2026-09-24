-- Перший запит на котрому перевіряли роботу та швидкість виконання індекса
EXPLAIN ANALYZE
SELECT * FROM tpch.orders
WHERE o_orderkey = 555;

-- В другому вже будемо азпитуватись по іншому полю котре не є індексом
EXPLAIN ANALYZE
SELECT o_comment
FROM tpch.orders
WHERE o_clerk = 'Clerk#000000986'


-- Створюємо індекс на цьому полі, щоб побачити змінений результат виконання
CREATE INDEX o_cleck_index ON tpch.orders (o_clerk);

-- Повторюємо результат виконання запиту
EXPLAIN ANALYZE
SELECT o_comment
FROM tpch.orders
WHERE o_clerk = 'Clerk#000000436'
