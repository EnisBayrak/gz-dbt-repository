with aggregated_campaigns as (
    select
        date_date,
        campaign_name,
        sum(cast(ads_cost as float64)) as ads_cost,
        sum(cast(impression as float64)) as impression,
        sum(cast(click as float64)) as click
    from {{ ref('int_campaigns') }}
    GROUP by 
        date_date,
        campaign_name
)

select * from aggregated_campaigns
order by 
    date_date desc,
    campaign_name asc