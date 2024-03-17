-- max, min and avg trip times
CREATE MATERIALIZED VIEW max_avg_trip AS
WITH a AS (
select 
    max(avg_trip_time)  as max_avg_trip_time
from 
    avg_max_min_trip_times a 
--inner join taxi_zone pickup_zone on pickup_zone.location_id = td.pulocationid
--inner join taxi_zone dropoff_zone on dropoff_zone.location_id = td.dolocationid
group by
    pickup_location,
    dropoff_location
order by 1 desc
limit 1
)
select max_avg_trip_time
from
a;

-- select answer Q2
select count(td.vendorid)
from
    trip_data td 
    inner join taxi_zone pickup_zone on pickup_zone.location_id = td.pulocationid
    inner join taxi_zone dropoff_zone on dropoff_zone.location_id = td.dolocationid
    inner join avg_max_min_trip_times as a on a.pickup_location = pickup_zone.zone and a.dropoff_location = dropoff_zone.zone
    , max_avg_trip as b
where a.avg_trip_time >= b.max_avg_trip_time;