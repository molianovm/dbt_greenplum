{% macro get_load_date() %}
    {% set load_date = var('load_date', '') %}
    {% if load_date != '' %}
        -- Если дата передана через vars, используем её
        '{{ load_date }}'::DATE
    {% else %}
        -- Если нет, берём вчерашний день
        (CURRENT_DATE - INTERVAL '1 DAY')::DATE
    {% endif %}
{% endmacro %}