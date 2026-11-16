
{{ config(materialized='table') }}

WITH source AS (

    SELECT *
    FROM {{ ref('products') }}

),

cleaned AS (

    SELECT
        TRIM(Product_ID) AS product_id,
        TRIM(Product_Name) AS product_name,
        INITCAP(TRIM(Category)) AS category,
        TRIM(Brand) AS brand,

        CAST(Original_Price AS DECIMAL(18,2)) AS original_price,
        CAST(Discount_Percent AS DECIMAL(5,2)) AS discount_percent,
        CAST(Discount_Amount AS DECIMAL(18,2)) AS discount_amount,
        CAST(Selling_Price AS DECIMAL(18,2)) AS selling_price,

        CAST(Stock_Quantity AS INT) AS stock_quantity,
        CAST(Weight_kg AS DECIMAL(10,3)) AS weight_kg,
        CAST(Avg_Rating AS DECIMAL(3,2)) AS avg_rating,
        CAST(Total_Reviews AS INT) AS total_reviews

    FROM source

)

SELECT *
FROM cleaned
