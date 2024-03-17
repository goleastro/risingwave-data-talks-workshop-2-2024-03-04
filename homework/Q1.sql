-- max, min and avg trip times
CREATE MATERIALIZED VIEW avg_max_min_trip_times AS
WITH a AS (
select 
    pulocationid, --pickup_zone.zone as pickup_location,
    dolocationid, --dropoff_zone.zone as dropoff_location,
    max(tpep_dropoff_datetime - tpep_pickup_datetime)  as max_trip_time,
    min(tpep_dropoff_datetime - tpep_pickup_datetime)  as min_trip_time,
    avg(tpep_dropoff_datetime - tpep_pickup_datetime)  as avg_trip_time
from 
    trip_data td 
--inner join taxi_zone pickup_zone on pickup_zone.location_id = td.pulocationid
--inner join taxi_zone dropoff_zone on dropoff_zone.location_id = td.dolocationid
group by
    pulocationid,--pickup_location,
    dolocationid--dropoff_location
--limit 10
)
select 
    pickup_zone.zone as pickup_location,
    dropoff_zone.zone as dropoff_location,
    max_trip_time,
    min_trip_time,
    avg_trip_time
from 
    a
inner join taxi_zone pickup_zone on pickup_zone.location_id = a.pulocationid
inner join taxi_zone dropoff_zone on dropoff_zone.location_id = a.dolocationid;

-- select answer Q1
select 
    pickup_location, dropoff_location, max(avg_trip_time) as max_trip_time
from 
    avg_max_min_trip_times
where 
    avg_trip_time >= max_trip_time
group by 
    pickup_location, dropoff_location
order by 
    max_trip_time desc
limit 10;