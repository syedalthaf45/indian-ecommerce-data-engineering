
{{ config(materialized='table') }}

SELECT
    product_id,
    product_name,
    category,
    brand,
    original_price,
    discount_percent,
    discount_amount,
    selling_price,
    stock_quantity,
    weight_kg,
    avg_rating,
    total_reviews
FROM {{ ref('stg_products') }}
