{{ config(
    materialized='table'
) }}

with finance_events as (
    select * from {{ ref('finance_campaigns_day') }}
)

select
    -- 1. Tarih sütununu date_date olarak güncelledik ve MONTH ifadesini BigQuery standardına aldık
    date_trunc(date_date, MONTH) as datemonth,
    
    -- Metriklerin aylık toplamları
    sum(revenue) as revenue,
    sum(coalesce(operational_margin, 0)) - sum(coalesce(ads_cost, 0)) as ads_margin,
    sum(operational_margin) as operational_margin,
    sum(coalesce(ads_cost, 0)) as ads_cost,
    
    -- 2. Görseldeki 'impression' sütununu 'ads_impression' alias'ı ile topluyoruz
    sum(coalesce(impression, 0)) as ads_impression,
    
    -- 3. Görseldeki 'click' sütununu 'ads_clicks' alias'ı ile topluyoruz
    sum(coalesce(click, 0)) as ads_clicks,
    
    sum(quantity) as quantity,
    sum(purchase_cost) as purchase_cost,
    sum(margin) as margin,
    sum(shipping_fee) as shipping_fee,
    
    -- 4. Görseldeki birleşik 'logcost' sütununu 'log_cost' yapıyoruz
    sum(coalesce(logcost, 0)) as log_cost,
    
    
    
    -- Ortalama sepet değeri
    round(avg(average_basket), 2) as average_basket

from finance_events
group by 1
order by datemonth desc