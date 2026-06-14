from datetime import datetime, timedelta

from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.operators.empty import EmptyOperator

default_args = {
    "owner": "me",
    "depends_on_past": False,
    "start_date": datetime(2026, 1, 1),
    "email_on_failure": False,
    "email_on_retry": False,
    "retries": 1,
    "retry_delay": timedelta(minutes=5),
}

with DAG(
    dag_id="greenplum_dbt_pipeline",
    default_args=default_args,
    description="Инкрементальная загрузка данных из PostgreSQL в Greenplum",
    schedule="@daily",
    catchup=False,
    tags=["greenplum", "dbt"],
    params={"load_date": None},
) as dag:
    start = EmptyOperator(task_id="start")
    end = EmptyOperator(task_id="end")

    dbt_run = BashOperator(
        task_id="dbt_run",
        bash_command="""
            cd /opt/airflow/gp_project &&
            {% if params.load_date %}
                dbt run --vars '{"load_date": "{{ params.load_date }}"}'
            {% else %}
                dbt run
            {% endif %}
        """,
    )

    dbt_test = BashOperator(
        task_id="dbt_test",
        bash_command="""
            cd /opt/airflow/gp_project &&
            {% if params.load_date %}
                dbt test --vars '{"load_date": "{{ params.load_date }}"}'
            {% else %}
                dbt test
            {% endif %}
        """,
    )

    start >> dbt_run >> dbt_test >> end
