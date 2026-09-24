-- Окрема schema для змінюваних навчальних experiments.
CREATE SCHEMA IF NOT EXISTS lab;

-- Видаляємо лише таблицю поточного experiment,
-- щоб script можна було безпечно повторити з початкового стану.
DROP TABLE IF EXISTS lab.isolation_accounts;

CREATE TABLE lab.isolation_accounts
(
    account_id integer PRIMARY KEY,
    owner_name text NOT NULL UNIQUE,
    balance    numeric(12, 2) NOT NULL CHECK (balance >= 0)
);

INSERT INTO lab.isolation_accounts (account_id, owner_name, balance)
VALUES
    (1, 'Alice', 1000.00),
    (2, 'Bob',    500.00);

SELECT *
FROM lab.isolation_accounts
ORDER BY account_id;