
{{ config(materialized='table') }}

SELECT
    c.customer_id,
    c.gender,
    c.age_group,
    c.city,
    c.state,
    c.customer_tier,

    COUNT(s.order_id) AS total_orders,

    SUM(CASE
        WHEN s.order_status = 'Delivered' THEN 1
        ELSE 0
    END) AS delivered_orders,

    ROUND(
        SUM(CASE
            WHEN s.order_status = 'Delivered'
            THEN s.total_amount
            ELSE 0
        END), 2
    ) AS delivered_sales,

    SUM(CASE
        WHEN s.order_status = 'Delivered'
        THEN s.quantity
        ELSE 0
    END) AS delivered_quantity,

    ROUND(
        AVG(CASE
            WHEN s.order_status = 'Delivered'
            THEN s.total_amount
            ELSE NULL
        END), 2
    ) AS average_delivered_order_value

FROM {{ ref('gold_customers') }} c

LEFT JOIN {{ ref('gold_sales') }} s
    ON c.customer_id = s.customer_id

GROUP BY
    c.customer_id,
    c.gender,
    c.age_group,
    c.city,
    c.state,
    c.customer_tier
