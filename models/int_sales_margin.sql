WITH sales AS (
    SELECT * FROM {{ ref('stg_raw__sales') }}
),

product AS (
    SELECT * FROM {{ ref('stg_raw_product') }}
),

margin_calculation AS (
    SELECT
        sales.date_date,
        sales.orders_id,
        sales.products_id,
        sales.revenue,
        sales.quantity,
        product.purchase_price,
        
        -- Satın alma maliyeti hesaplama: miktar * satın alma fiyatı
        ROUND(sales.quantity * product.purchase_price, 2) AS purchase_cost,
        
        -- Marj hesaplama: gelir - satın alma maliyeti
        ROUND(sales.revenue - (sales.quantity * product.purchase_price), 2) AS margin

    FROM sales
    LEFT JOIN product 
        ON sales.products_id = product.products_id
)

SELECT * FROM margin_calculation