
{{ config(materialized='table') }}

SELECT
    city,
    state,

    COUNT(*) AS delivered_orders,

    ROUND(
        AVG(delivery_days), 2
    ) AS average_delivery_days,

    MIN(delivery_days) AS minimum_delivery_days,

    MAX(delivery_days) AS maximum_delivery_days,

    SUM(CASE
        WHEN delivery_days <= 3 THEN 1
        ELSE 0
    END) AS delivered_within_3_days,

    SUM(CASE
        WHEN delivery_days <= 5 THEN 1
        ELSE 0
    END) AS delivered_within_5_days,

    SUM(CASE
        WHEN delivery_days <= 7 THEN 1
        ELSE 0
    END) AS delivered_within_7_days,

    ROUND(
        SUM(CASE
            WHEN delivery_days <= 5 THEN 1
            ELSE 0
        END) * 100.0 / COUNT(*), 2
    ) AS delivered_within_5_days_percentage

FROM {{ ref('gold_sales') }}

WHERE order_status = 'Delivered'

GROUP BY
    city,
    state
