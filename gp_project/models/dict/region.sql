SELECT region_id,
       region_name,
       region_comment
FROM {{ source('ext', 'dict_region') }}