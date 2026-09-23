-- Окрема schema для змінюваних навчальних experiments.
-- TPC-H dataset ми не чіпаємо.

CREATE SCHEMA IF NOT EXISTS lab;

-- GENERATED ALWAYS AS IDENTITY створює для id
-- пов'язану внутрішню sequence.
--
-- PRIMARY KEY окремо гарантує унікальність.

CREATE TABLE lab.identity_demo (
    id   bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    note text NOT NULL
);

-- Значення id не передаємо:
-- PostgreSQL має згенерувати їх автоматично.

INSERT INTO lab.identity_demo (note)
VALUES
    ('first row'),
    ('second row');

SELECT *
FROM lab.identity_demo
ORDER BY id;

-- Знаходимо sequence, пов'язану з identity column.

SELECT
    pg_get_serial_sequence(
            'lab.identity_demo',
            'id'
    ) AS identity_sequence;

-- Починаємо явну transaction.
BEGIN;

-- Sequence видасть наступний номер: очікуємо id = 3.
INSERT INTO lab.identity_demo (note)
VALUES ('this row will be rolled back')
RETURNING id, note;

-- Скасовуємо transaction.
-- Рядок із id = 3 зникне, але sequence назад не повернеться.
ROLLBACK;

-- Наступний INSERT має отримати вже id = 4.
INSERT INTO lab.identity_demo (note)
VALUES ('row after rollback')
RETURNING id, note;

-- Перевіряємо фінальний стан таблиці.
SELECT id, note
FROM lab.identity_demo
ORDER BY id;

-- Перевіряємо поточний стан sequence.
SELECT
    last_value,
    is_called
FROM lab.identity_demo_id_seq;