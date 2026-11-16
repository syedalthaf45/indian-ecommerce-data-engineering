
{{ config(materialized='table') }}

SELECT
    customer_id,
    gender,
    age,
    age_group,
    city,
    state,
    customer_tier,
    registration_date
FROM {{ ref('stg_customers') }}
