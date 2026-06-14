SELECT nation_id,
       nation_name,
       region_id,
       nation_comment
FROM {{ source('ext', 'dict_nation') }}