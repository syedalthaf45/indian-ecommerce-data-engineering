
SELECT
    order_id,
    order_date,
    delivery_date,
    order_status
FROM {{ ref('gold_sales') }}
WHERE delivery_date < order_date
