WITH orders_margin AS (
    SELECT * FROM {{ ref('int_orders_margin') }}
),

ship AS (
    SELECT * FROM {{ ref('stg_raw__ship') }}
),

operational_calculation AS (
    SELECT
        orders_margin.orders_id,
        orders_margin.date_date,
        
        -- Operasyonel Marj Hesaplama: margin + shipping_fee - logcost - ship_cost
        ROUND(
            orders_margin.margin 
            + ship.shipping_fee 
            - ship.logcost 
            - ship.ship_cost, 
            2
        ) AS operational_margin,
        
        -- Görseldeki gibi tablonun devamında quantity ve diğer alanları da koruyoruz:
        orders_margin.quantity,
        orders_margin.revenue,
        orders_margin.purchase_cost,
        orders_margin.margin,
        ship.shipping_fee,
        ship.logcost,
        ship.ship_cost

    FROM orders_margin
    LEFT JOIN ship 
        ON orders_margin.orders_id = ship.orders_id
)

SELECT * FROM operational_calculation