
SELECT
    order_id,
    order_value,
    shipping_cost,
    coupon_discount,
    total_amount
FROM {{ ref('gold_sales') }}
WHERE ABS(
    total_amount -
    (order_value + shipping_cost - coupon_discount)
) > 0.02
