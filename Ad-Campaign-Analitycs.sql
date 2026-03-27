with facebookCTE as (
	select 
		fabd.ad_date,
		fabd.spend,
		fabd.clicks,
        fabd.impressions,
        fabd.value,
		fa.adset_name,
		fc.campaign_name 
	from facebook_ads_basic_daily as fabd 
	left join public.facebook_adset as fa
		on fa.adset_id = fabd.adset_id 
	left join public.facebook_campaign as fc 
		on fc.campaign_id = fabd.campaign_id
),
combinedCTE as (
   select 
		ad_date,
		'Facebook Ads' as media_source,
		spend,
		clicks,
        impressions,
        value as conversion_value,
		adset_name,
		campaign_name 
	from facebookCTE
	union all
	select 
		ad_date,
		'Google Ads' as media_source,
		spend,
		clicks,
        impressions,
        value as conversion_value,
		adset_name,
		campaign_name
	from public.google_ads_basic_daily
)
select 
	ad_date, 
	media_source, 
	campaign_name, 
	adset_name,
	SUM(spend) as total_cost,
    SUM(impressions) as total_impressions,
    SUM(clicks) as total_clicks,
    SUM(conversion_value) as total_conversion_value
from combinedCTE 
where ad_date is not null
group by 
 	ad_date, 
 	media_source, 
 	campaign_name, 
 	adset_name
 order by ad_date;