
{{ config(materialized='table') }}

WITH source AS (

    SELECT *
    FROM {{ ref('sales') }}

),

cleaned AS (

    SELECT
        TRIM(Order_ID) AS order_id,
        TRIM(Customer_ID) AS customer_id,
        TRIM(Product_ID) AS product_id,

        CAST(Order_Date AS DATE) AS order_date,
        Order_Time AS order_time,
        CAST(Delivery_Date AS DATE) AS delivery_date,

        CAST(Quantity AS INT) AS quantity,

        CAST(Unit_Price AS DECIMAL(18,2)) AS unit_price,
        CAST(Order_Value AS DECIMAL(18,2)) AS order_value,
        CAST(Shipping_Cost AS DECIMAL(18,2)) AS shipping_cost,

        NULLIF(TRIM(Coupon_Code), '') AS coupon_code,

        CAST(Coupon_Discount AS DECIMAL(18,2)) AS coupon_discount,
        CAST(Total_Amount AS DECIMAL(18,2)) AS total_amount,

        CASE
            WHEN UPPER(TRIM(Payment_Mode)) = 'UPI' THEN 'UPI'
            WHEN UPPER(TRIM(Payment_Mode)) = 'COD' THEN 'COD'
            WHEN UPPER(TRIM(Payment_Mode)) = 'DEBIT CARD' THEN 'Debit Card'
            WHEN UPPER(TRIM(Payment_Mode)) = 'CREDIT CARD' THEN 'Credit Card'
            ELSE TRIM(Payment_Mode)
        END AS payment_mode,

        INITCAP(TRIM(Order_Status)) AS order_status,

        CAST(Rating AS DECIMAL(3,2)) AS rating,
        NULLIF(TRIM(Review_Text), '') AS review_text,

        TRIM(City) AS city,

        CASE
            WHEN UPPER(TRIM(State)) IN ('UP', 'U.P.', 'UTTAR PRADESH')
                THEN 'Uttar Pradesh'
            ELSE INITCAP(TRIM(State))
        END AS state,

        DATEDIFF(Delivery_Date, Order_Date) AS delivery_days,

        CASE
            WHEN Total_Amount < 0 THEN TRUE
            ELSE FALSE
        END AS is_negative_total_amount,

        CASE
            WHEN Coupon_Discount > Order_Value THEN TRUE
            ELSE FALSE
        END AS is_coupon_discount_excessive,

        CASE
            WHEN ABS(
                Order_Value - (Quantity * Unit_Price)
            ) > 0.02 THEN TRUE
            ELSE FALSE
        END AS is_order_value_mismatch,

        CASE
            WHEN ABS(
                Total_Amount -
                (Order_Value + Shipping_Cost - Coupon_Discount)
            ) > 0.02 THEN TRUE
            ELSE FALSE
        END AS is_total_amount_mismatch

    FROM source

)

SELECT *
FROM cleaned
