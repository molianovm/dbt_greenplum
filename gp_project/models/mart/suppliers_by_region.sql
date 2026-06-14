WITH supplier_nation AS (
    SELECT s.supplier_key,
           s.nation_id,
           n.nation_name,
           n.region_id
    FROM {{ ref('supplier') }} s
    LEFT JOIN {{ ref('nation') }} n ON s.nation_id = n.nation_id
)

SELECT sn.region_id,
       r.region_name,
       sn.nation_id,
       sn.nation_name,
       COUNT(DISTINCT sn.supplier_key) AS supplier_count,
       CURRENT_TIMESTAMP AS calculated_at
FROM supplier_nation sn
LEFT JOIN {{ ref('region') }} r ON sn.region_id = r.region_id
GROUP BY sn.region_id,
         r.region_name,
         sn.nation_id,
         sn.nation_name