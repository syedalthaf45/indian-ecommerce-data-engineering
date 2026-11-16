
{{ config(materialized='table') }}

SELECT
    order_id,
    customer_id,
    product_id,
    order_date,
    order_time,
    delivery_date,
    quantity,
    unit_price,
    order_value,
    shipping_cost,
    coupon_code,
    coupon_discount,
    total_amount,
    payment_mode,
    order_status,
    rating,
    review_text,
    city,
    state,
    delivery_days,
    is_negative_total_amount,
    is_coupon_discount_excessive,
    is_order_value_mismatch,
    is_total_amount_mismatch
FROM {{ ref('stg_sales') }}
