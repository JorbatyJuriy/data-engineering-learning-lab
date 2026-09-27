# Data Engineering Learning Lab

Навчальний репозиторій із практичними лабораторними роботами, SQL-експериментами та зафіксованим прогресом за напрямом Data Engineering.

Проєкт створений у межах стажування Data Engineer Intern. Його мета — не просто зберігати конспекти, а підтверджувати знання практикою: локальними середовищами, кодом, експериментами, планами запитів і короткими перевірками за методом Фейнмана.

> [!NOTE]
> Це навчальне середовище, а не production-рішення. Корпоративна інфраструктура, внутрішні адреси, облікові дані та закриті матеріали тут не зберігаються.

## Поточний прогрес

| Етап | Статус | Практичний результат |
|---|---|---|
| Основи Data Engineering | Завершено | SQL, реляційна модель, OLTP та OLAP, рядкове й колонкове зберігання |
| ClickHouse Awareness | Завершено | Архітектурна модель ClickHouse, MergeTree, parts, partitions, sparse index, replication basics |
| PostgreSQL Awareness | Завершено — **4/5** | Локальна лабораторія, транзакції, MVCC, VACUUM, індекси та плани запитів |
| Apache Airflow Awareness | Наступний етап | Оркестрація локального pipeline з PostgreSQL |
| Apache Kafka | Заплановано | Події, topics, partitions, consumer groups і Kafka ecosystem |
| DataHub та Data Quality | Заплановано | Metadata management, data discovery і перевірки якості даних |

## Що вже реалізовано

### PostgreSQL Local Lab

Локальне середовище працює на PostgreSQL 18.6 у Docker із persistent volume. Для роботи з базою використовується DataGrip, а команди Docker і Git виконуються у WSL2.

У лабораторії:

- розгорнуто PostgreSQL через Docker Compose;
- створено схеми `tpch` і `lab`;
- завантажено TPC-H SF1: 8 таблиць і **8 661 245 рядків**;
- перевірено PK, FK, constraints, sequences та identity columns;
- виконано експерименти з `BEGIN`, `COMMIT`, `ROLLBACK` і `SAVEPOINT`;
- порівняно `READ COMMITTED` та `REPEATABLE READ` у паралельних сесіях;
- відтворено row-level blocking і serialization failure `40001`;
- досліджено MVCC, snapshots, `VACUUM`, visibility map і `Heap Fetches`;
- створено B-tree indexes і порівняно `Seq Scan`, `Index Scan`, `Bitmap Heap Scan` та `Index Only Scan`;
- використано `EXPLAIN (ANALYZE, BUFFERS)` для перевірки реальної вартості запитів;
- сформовано базову модель WAL, backup, replication і PITR.

### ClickHouse Awareness

Окремо опрацьовано:

- різницю між OLTP та OLAP;
- колонкове зберігання і data skipping;
- `MergeTree`, parts, partitions і background merges;
- sorting key, primary key і sparse primary index;
- materialized views, projections і TTL;
- shards, replicas, `Distributed` tables і Keeper;
- базову навігацію в ClickHouse Cloud та `system` tables.

## Технології та інструменти

| Категорія | Інструменти |
|---|---|
| Операційне середовище | Windows 11, WSL2 Ubuntu |
| Контейнери | Docker Desktop, Docker Compose |
| Бази даних | PostgreSQL 18.6, ClickHouse |
| Робота з SQL | DataGrip, PyCharm, ClickHouse SQL Console |
| Мови | SQL, Python |
| Python tooling | `uv`, DuckDB helper для генерації TPC-H |
| Документація | Markdown, Obsidian |
| Контроль версій | Git, GitHub |

## Структура репозиторію

```text
data-engineering-learning-lab/
├── README.md
├── context/                 # Контекст, Skill Matrix, learning path і progress
├── notes/                   # Навчальні конспекти та daily recaps
├── exercises/               # Невеликі вправи й checkpoints
├── labs/
│   └── postgresql/          # Docker Compose, SQL і PostgreSQL experiments
└── projects/                # Майбутні наскрізні Data Engineering projects
```

Основні керівні документи:

- [`MY_CONTEXT.md`](context/MY_CONTEXT.md) — навчальний і технічний контекст;
- [`SKILL_MATRIX_ORIGINAL.md`](context/SKILL_MATRIX_ORIGINAL.md) — початкові вимоги ментора;
- [`LEARNING_PROTOCOL.md`](context/LEARNING_PROTOCOL.md) — правила навчання та перевірки знань;
- [`LEARNING_PATH.md`](context/LEARNING_PATH.md) — послідовність технологій і тем;
- [`PROGRESS.md`](context/PROGRESS.md) — підтверджені знання, evidence, прогалини та blockers.

## Запуск PostgreSQL-лабораторії

### Передумови

- Windows 11 із WSL2 або Linux;
- Docker Desktop із WSL integration;
- Docker Compose;
- SQL-клієнт, наприклад DataGrip;
- Git.

### Запуск

```bash
cd labs/postgresql
docker compose up -d
docker compose ps
```

Після запуску потрібно підключитися до PostgreSQL параметрами з локального `.env`. Реальні паролі в Git не зберігаються; публічний приклад конфігурації варто оформити у `.env.example`.

### Завершення роботи

```bash
docker compose stop
```

Команда зупиняє контейнер, але залишає дані в Docker volume.

> ⚠️ Не запускайте `docker compose down -v`, якщо не плануєте свідомо видалити локальні дані PostgreSQL.

## Дані

TPC-H dataset генерується локально через допоміжний Python/DuckDB-проєкт і завантажується в PostgreSQL через `COPY`.

Згенеровані CSV, локальні database files і Docker volumes не зберігаються в Git. У репозиторії залишаються тільки код генератора, SQL-скрипти та конфігурація, необхідні для відтворення середовища.

## Навчальний підхід

Кожна технологія проходить однаковий цикл:

1. коротка діагностика поточного рівня;
2. формування ментальної моделі;
3. практичний експеримент;
4. пояснення результату власними словами;
5. виправлення неточностей;
6. checkpoint без підказок;
7. фіксація evidence у `PROGRESS.md`.

Ціль більшості модулів — міцний рівень **Awareness**: розуміння призначення технології, ключових компонентів, базових сценаріїв і меж власної компетенції без передчасного заглиблення в production tuning.

## Roadmap

Наступний практичний етап — Apache Airflow:

- DAG і task;
- operators і dependencies;
- scheduling, retries та timeouts;
- catchup і backfill;
- Airflow UI та logs;
- connections і secrets;
- pipeline, який читає дані з локального PostgreSQL;
- базове спостереження за виконанням і помилками.

Після Airflow заплановано перейти до Apache Kafka, DataHub, Data Quality та інших пунктів Skill Matrix.

## Правила безпеки репозиторію

У Git не додаються:

- `.env` і реальні credentials;
- API tokens, SSH keys та паролі;
- згенеровані CSV/Parquet/DuckDB files;
- Docker volumes і `pgdata`;
- `.venv`, IDE cache та logs;
- корпоративні URL, dashboards, runbooks і внутрішні дані.

Перед кожним push перевіряються `git status`, staged diff і відсутність секретів.

---

**Поточний milestone:** PostgreSQL Awareness завершено. Наступна ціль — Apache Airflow Awareness і перший оркестрований pipeline.
