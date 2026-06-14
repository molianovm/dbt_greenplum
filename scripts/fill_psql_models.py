import os
import random
from datetime import datetime, timedelta

import pandas as pd
import psycopg2
from dotenv import load_dotenv

load_dotenv()

START_DATE = datetime(2026, 1, 1)
END_DATE = datetime(2026, 1, 31)
DATE_RANGE = (END_DATE - START_DATE).days

TABLES_CONFIG = [
    {
        "table_name": "region",
        "schema": "dict",
        "columns": ["region_id", "region_name", "region_comment"],
        "file_name": "region.tbl",
        "need_updated_at": False,
    },
    {
        "table_name": "nation",
        "schema": "dict",
        "columns": ["nation_id", "nation_name", "region_id", "nation_comment"],
        "file_name": "nation.tbl",
        "need_updated_at": False,
    },
    {
        "table_name": "customer",
        "schema": "src",
        "columns": [
            "customer_key",
            "customer_name",
            "customer_address",
            "nation_id",
            "customer_phone",
            "customer_acctbal",
            "customer_mktsegment",
            "customer_comment",
        ],
        "file_name": "customer.tbl",
        "need_updated_at": True,
    },
    {
        "table_name": "supplier",
        "schema": "src",
        "columns": [
            "supplier_key",
            "supplier_name",
            "supplier_address",
            "nation_id",
            "supplier_phone",
            "supplier_acctbal",
            "supplier_comment",
        ],
        "file_name": "supplier.tbl",
        "need_updated_at": True,
    },
]


def get_connection():
    """Возвращает подключение к PostgreSQL"""
    return psycopg2.connect(
        host=os.getenv("SOURCE_HOST", "localhost"),
        port=os.getenv("SOURCE_PORT", "5433"),
        dbname=os.getenv("SOURCE_DB", "source_db"),
        user=os.getenv("SOURCE_USER", "source_user"),
        password=os.getenv("SOURCE_PASSWORD", "source_pass"),
    )


def create_tables(conn):
    """Создаёт таблицы из SQL файла"""
    sql_path = os.path.join(os.path.dirname(__file__), "..", "sql", "psql_models.sql")
    with open(sql_path, "r", encoding="utf-8") as f:
        sql = f.read()

    with conn.cursor() as cur:
        cur.execute(sql)
        conn.commit()
        print("✅ Модели успешно созданы")


def assign_updated_at(df):
    """Добавляет случайные даты"""
    random_days = [random.randint(0, DATE_RANGE) for _ in range(len(df))]
    df["updated_at"] = [START_DATE + timedelta(days=d) for d in random_days]
    return df


def load_table(conn, table_name, schema, columns, file_name, need_updated_at=False):
    """
    Универсальная загрузка данных из tbl файла
    """
    # Путь к файлу
    file_path = os.path.join(os.path.dirname(__file__), "..", "data", file_name)

    # Загрузка данных
    df = pd.read_csv(file_path, sep="|", header=None)

    df.columns = columns

    # Добавляем updated_at если нужно
    if need_updated_at:
        df = assign_updated_at(df)
        insert_columns = columns + ["updated_at"]
    else:
        insert_columns = columns

    # Формируем колонки для вставки
    col_names = ", ".join(insert_columns)
    placeholders = ", ".join(["%s"] * len(insert_columns))

    # Вставляем данные
    with conn.cursor() as cur:
        for _, row in df.iterrows():
            cur.execute(
                f"INSERT INTO {schema}.{table_name} ({col_names}) VALUES ({placeholders})",
                tuple(row),
            )
        conn.commit()

    print(f"  ✅ {schema}.{table_name}: {len(df)} записей")


def main():
    try:
        conn = get_connection()

        # Проверка подключения
        with conn.cursor() as cur:
            cur.execute("SELECT version();")
            version = cur.fetchone()
            print(f"✅ Подключено к PostgreSQL: {version}...")

        # Создаём таблицы
        create_tables(conn)

        print("✅ Начинаем загрузку данных: ")
        for cfg in TABLES_CONFIG:
            load_table(
                conn,
                cfg["table_name"],
                cfg["schema"],
                cfg["columns"],
                cfg["file_name"],
                cfg["need_updated_at"],
            )

        conn.close()
        print("✅ Все данные успешно загружены!")

    except Exception as e:
        print(f"❌ Ошибка: {e}")


if __name__ == "__main__":
    main()
