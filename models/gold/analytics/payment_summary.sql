
{{ config(materialized='table') }}

SELECT
    payment_mode,

    COUNT(*) AS total_orders,

    SUM(CASE
        WHEN order_status = 'Delivered' THEN 1
        ELSE 0
    END) AS delivered_orders,

    SUM(CASE
        WHEN order_status = 'Cancelled' THEN 1
        ELSE 0
    END) AS cancelled_orders,

    SUM(CASE
        WHEN order_status = 'Returned' THEN 1
        ELSE 0
    END) AS returned_orders,

    SUM(CASE
        WHEN order_status = 'Shipped' THEN 1
        ELSE 0
    END) AS shipped_orders,

    SUM(CASE
        WHEN order_status = 'Processing' THEN 1
        ELSE 0
    END) AS processing_orders,

    ROUND(
        SUM(CASE
            WHEN order_status = 'Delivered'
            THEN total_amount
            ELSE 0
        END), 2
    ) AS delivered_sales,

    ROUND(
        AVG(CASE
            WHEN order_status = 'Delivered'
            THEN total_amount
            ELSE NULL
        END), 2
    ) AS average_delivered_order_value,

    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (), 2
    ) AS order_percentage

FROM {{ ref('gold_sales') }}

GROUP BY payment_mode
