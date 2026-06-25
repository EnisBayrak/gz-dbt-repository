{{ config(
    materialized='table',
    schema='finance'
) }}
WITH orders_operational AS (
    SELECT * FROM {{ ref('int_orders_operational') }}
),

finance_days_aggregation AS (
    SELECT
        date_date,
        
        -- Toplam işlem (sipariş) sayısı
        COUNT(DISTINCT orders_id) AS nb_transactions,
        
        -- Toplam gelir
        ROUND(SUM(revenue), 2) AS revenue,
        
        -- Ortalama Sepet (Gelir / İşlem Sayısı)
        ROUND(SAFE_DIVIDE(SUM(revenue), COUNT(DISTINCT orders_id)), 2) AS average_basket,
        
        -- Toplam operasyonel marj
        ROUND(SUM(operational_margin), 2) AS operational_margin,
        
        -- Toplam satın alma maliyeti
        ROUND(SUM(purchase_cost), 2) AS purchase_cost,
        
        -- Toplam marj (brüt kâr)
        ROUND(SUM(margin), 2) AS margin,
        
        -- Toplam nakliye/kargo ücretleri (Müşteriden alınan)
        ROUND(SUM(shipping_fee), 2) AS shipping_fee,
        
        -- Toplam lojistik maliyetleri
        ROUND(SUM(logcost), 2) AS logcost,
        
        -- Satılan toplam ürün miktarı
        SUM(quantity) AS quantity

    FROM orders_operational
    GROUP BY 
        date_date
)

SELECT * FROM finance_days_aggregation
ORDER BY date_date DESC