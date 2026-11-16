
SELECT
    order_id,
    order_status,
    order_date,
    delivery_date
FROM {{ ref('gold_sales') }}
WHERE order_status = 'Delivered'
  AND delivery_date IS NULL
