{{
    config(
        unique_key='customer_hashkey',
        distributed_by='customer_hashkey'
    )
}}

SELECT MD5('postgresql' || '|' || customer_key::text) as customer_hashkey,
       customer_key,
       customer_name,
       customer_address,
       nation_id,
       customer_phone,
       customer_acctbal,
       customer_mktsegment,
       customer_comment,
       CURRENT_TIMESTAMP as loaded_at,
       'postgresql' as record_source
FROM {{ source('ext', 'src_customer') }}

{% if is_incremental() %}
    WHERE updated_at::date = {{ get_load_date() }}
{% endif %}