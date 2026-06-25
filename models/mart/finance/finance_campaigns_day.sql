{{config(
    materialized='view'
)}}

with finance_days as (
    select * from {{ ref('finance_days') }}
),

int_campaigns_day as (
    select * from {{ ref('int_campaigns_day') }}
)

select 
    f.date_date,
    coalesce(f.operational_margin, 0) - coalesce(c.ads_cost, 0) as ads_margin,
    f.average_basket,
    f.operational_margin,
    coalesce(c.ads_cost, 0) as ads_cost,
    c.impression,
    c.click,
    f.quantity,
    f.revenue,
    f.purchase_cost,
    f.margin,
    f.shipping_fee,
    f.logcost,
from finance_days as f
left join int_campaigns_day as c
    on f.date_date = c.date_date

