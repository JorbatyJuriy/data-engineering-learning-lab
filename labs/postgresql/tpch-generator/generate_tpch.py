"""Генерація та експорт TPC-H dataset через DuckDB."""

from pathlib import Path

import duckdb


# Малий scale factor для тестового експорту.
SCALE_FACTOR = 1

# Порядок таблиць від батьківських до залежних.
TABLE_NAMES = (
    "region",
    "nation",
    "supplier",
    "customer",
    "part",
    "partsupp",
    "orders",
    "lineitem",
)

# generate_tpch.py знаходиться в tpch-generator/.
# Батьківська директорія — labs/postgresql/.
POSTGRESQL_LAB_DIRECTORY = Path(__file__).resolve().parent.parent

# Тестові CSV зберігатимуться окремо від майбутнього SF1.
OUTPUT_DIRECTORY = (
    POSTGRESQL_LAB_DIRECTORY / "data" / f"sf{SCALE_FACTOR}"
)


def main() -> None:
    """Згенерувати TPC-H і експортувати таблиці у CSV."""

    OUTPUT_DIRECTORY.mkdir(parents=True, exist_ok=True)

    # База існує лише в RAM протягом роботи скрипту.
    connection = duckdb.connect(database=":memory:")

    try:
        connection.execute("INSTALL tpch")
        connection.execute("LOAD tpch")
        connection.execute(f"CALL dbgen(sf = {SCALE_FACTOR})")

        print(f"TPC-H SF{SCALE_FACTOR} успішно згенеровано.")
        print(f"CSV directory: {OUTPUT_DIRECTORY}")
        print()

        for table_name in TABLE_NAMES:
            row_count = connection.execute(
                f'SELECT count(*) FROM "{table_name}"'
            ).fetchone()[0]

            output_file = OUTPUT_DIRECTORY / f"{table_name}.csv"

            # Видаляємо попередню версію, щоб повторний запуск
            # давав чистий і передбачуваний результат.
            output_file.unlink(missing_ok=True)

            # Екрануємо одинарні лапки для SQL file path.
            sql_file_path = str(output_file).replace("'", "''")

            connection.execute(
                f"""
                COPY "{table_name}"
                TO '{sql_file_path}'
                (FORMAT CSV, HEADER);
                """
            )

            size_mb = output_file.stat().st_size / (1024 * 1024)

            print(
                f"{table_name:10} "
                f"rows={row_count:>8} "
                f"size={size_mb:>7.2f} MB"
            )

    finally:
        connection.close()


if __name__ == "__main__":
    main()