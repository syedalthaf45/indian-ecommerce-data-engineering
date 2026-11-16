
{{ config(materialized='table') }}

WITH source AS (

    SELECT *
    FROM {{ ref('customers') }}

),

cleaned AS (

    SELECT
        TRIM(Customer_ID) AS customer_id,

        CASE
            WHEN UPPER(TRIM(Gender)) IN ('MALE', 'M') THEN 'Male'
            WHEN UPPER(TRIM(Gender)) IN ('FEMALE', 'F') THEN 'Female'
            ELSE INITCAP(TRIM(Gender))
        END AS gender,

        CAST(Age AS INT) AS age,
        TRIM(Age_Group) AS age_group,
        TRIM(City) AS city,
        CASE
            WHEN UPPER(TRIM(State)) IN ('UP', 'U.P.', 'UTTAR PRADESH')
            THEN 'Uttar Pradesh'
        ELSE INITCAP(TRIM(State))
        END AS state,
        CAST(Registration_Date AS DATE) AS registration_date,
        INITCAP(TRIM(Customer_Tier)) AS customer_tier

    FROM source

)

SELECT *
FROM cleaned
