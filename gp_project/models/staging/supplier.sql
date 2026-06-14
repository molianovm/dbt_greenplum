{{
    config(
        unique_key='supplier_hashkey',
        distributed_by='supplier_hashkey'
    )
}}

SELECT MD5('postgresql' || '|' || supplier_key::text) as supplier_hashkey,
       supplier_key,
       supplier_name,
       supplier_address,
       nation_id,
       supplier_phone,
       supplier_acctbal,
       supplier_comment,
       CURRENT_TIMESTAMP as loaded_at,
       'postgresql' as record_source
FROM {{ source('ext', 'src_supplier') }}

{% if is_incremental() %}
    WHERE updated_at::date = {{ get_load_date() }}
{% endif %}