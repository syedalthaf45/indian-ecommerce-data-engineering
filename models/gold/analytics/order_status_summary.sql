
{{ config(materialized='table') }}

SELECT
    order_status,

    COUNT(*) AS total_orders,

    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS order_percentage,

    SUM(quantity) AS total_quantity,

    ROUND(
        SUM(total_amount), 2
    ) AS total_order_amount,

    ROUND(
        AVG(total_amount), 2
    ) AS average_order_amount,

    ROUND(
        SUM(CASE
            WHEN order_status = 'Delivered'
            THEN total_amount
            ELSE 0
        END), 2
    ) AS delivered_sales

FROM {{ ref('gold_sales') }}

GROUP BY order_status
