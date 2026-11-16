
{{ config(materialized='table') }}

SELECT
    p.product_id,
    p.product_name,
    p.category,
    p.brand,

    p.original_price,
    p.discount_percent,
    p.selling_price,

    p.avg_rating,
    p.total_reviews,

    COUNT(s.order_id) AS total_orders,

    SUM(CASE
        WHEN s.order_status = 'Delivered' THEN 1
        ELSE 0
    END) AS delivered_orders,

    SUM(CASE
        WHEN s.order_status = 'Delivered'
        THEN s.quantity
        ELSE 0
    END) AS delivered_quantity,

    ROUND(
        SUM(CASE
            WHEN s.order_status = 'Delivered'
            THEN s.total_amount
            ELSE 0
        END), 2
    ) AS delivered_sales,

    ROUND(
        AVG(CASE
            WHEN s.order_status = 'Delivered'
            THEN s.unit_price
            ELSE NULL
        END), 2
    ) AS average_delivered_unit_price

FROM {{ ref('gold_products') }} p

LEFT JOIN {{ ref('gold_sales') }} s
    ON p.product_id = s.product_id

GROUP BY
    p.product_id,
    p.product_name,
    p.category,
    p.brand,
    p.original_price,
    p.discount_percent,
    p.selling_price,
    p.avg_rating,
    p.total_reviews
