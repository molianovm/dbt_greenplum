WITH customer_nation AS (
    SELECT c.customer_key,
           c.nation_id,
           n.nation_name,
           n.region_id
    FROM {{ ref('customer') }} c
    LEFT JOIN {{ ref('nation') }} n ON c.nation_id = n.nation_id
)

SELECT cn.region_id,
       r.region_name,
       cn.nation_id,
       cn.nation_name,
       COUNT(DISTINCT cn.customer_key) AS customer_count,
       CURRENT_TIMESTAMP AS calculated_at
FROM customer_nation cn
LEFT JOIN {{ ref('region') }} r ON cn.region_id = r.region_id
GROUP BY cn.region_id,
         r.region_name,
         cn.nation_id,
         cn.nation_name