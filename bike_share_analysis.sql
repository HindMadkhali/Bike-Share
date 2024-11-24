~~DATA CLEANING

  
## Add new columns:
  
ALTER TABLE `202004-divvy-tripdata`
ADD COLUMN trip_duration INT(25);
================================
ALTER TABLE `202004-divvy-tripdata` 
ADD COLUMN start_date DATE
================================
ALTER TABLE `202004-divvy-tripdata` 
ADD COLUMN day_of_the_week CHAR(25)
================================
ALTER TABLE `202004-divvy-tripdata` 
ADD COLUMN hour_of_the_day varchar(25)


## Add values to new columns:

UPDATE `202004-divvy-tripdata` 
SET start_date = date(started_at)
# this will extract the start date without the timestamp
================================
UPDATE `202004-divvy-tripdata`
SET trip_duration = TIMESTAMPDIFF(SECOND, started_at, ended_at);
# this subtracts the timestamps to give the trip duration in seconds
================================
update `202004-divvy-tripdata`
set day_of_the_week = dayneme(started_at)
#this will extract the day of the week from the timestamp
================================
update `202004-divvy-tripdata`
set hour_of_the_day = case 
 when hour(started_at) > 12 then concat(hour(started_at)-12, ' PM')  ~~ Afternoon
 when hour(started_at) = 12 then concat(hour(started_at), ' PM')     ~~ Noon
 when hour(started_at) = 0 then '12 AM'                              ~~ Midnight
 else concat(hour(started_at),' AM')                                 ~~ Morning
end
#this will extract the hour from the timestamp and, convert it from military to standard time also, adding AM or PM accordingly.

## delete rows with 0 or negative trip duration 
  
delete 
from`202004-divvy-tripdata` 
where trip_duration_time <= 0

~~ DATA ANALYSIS

## find statistcs trip duration for Casuals and members
select 
avg(trip_duration) as average_casual,
min(trip_duration) as minimum_casual,
max(trip_duration) as maximum_casual,
sum(trip_duration) as sum_casual
from `202004-divvy-tripdata`
where member_casual = 'casual'
================================
select 
avg(trip_duration) as average_member,
min(trip_duration) as minimum_member,
max(trip_duration) as maximum_member,
sum(trip_duration) as sum_member
from `202004-divvy-tripdata`
where member_casual = 'member'

## find out which start stations were visited the most\least by members and casuals
select *
from (
select start_station_name, member_casual, count(ride_id) as rides
from `202004-divvy-tripdata`
group by start_station_name, member_casual) as station_rides
having rides = (select 
max(rides)
from (select start_station_name, member_casual, count(ride_id) as rides
from `202004-divvy-tripdata`
group by start_station_name, member_casual) as max_rides
where max_rides.member_casual = station_rides.member_casual
)
union all
select *
from (
select start_station_name, member_casual, count(ride_id) as rides
from `202004-divvy-tripdata`
group by start_station_name, member_casual) as station_rides
having rides = (select 
min(rides)
from (select start_station_name, member_casual, count(ride_id) as rides
from `202004-divvy-tripdata`
group by start_station_name, member_casual) as min_rides
where min_rides.member_casual = station_rides.member_casual
)

## find out which end stations were visited the most\least by members and casuals
select *
from (
select end_station_name, member_casual, count(ride_id) as rides
from `202004-divvy-tripdata`
group by end_station_name, member_casual) as station_rides
having rides = (select 
max(rides)
from (select end_station_name, member_casual, count(ride_id) as rides
from `202004-divvy-tripdata`
group by end_station_name, member_casual) as max_rides
where max_rides.member_casual = station_rides.member_casual
)
union all
select *
from (
select end_station_name, member_casual, count(ride_id) as rides
from `202004-divvy-tripdata`
group by end_station_name, member_casual) as station_rides
having rides = (select 
min(rides)
from (select end_station_name, member_casual, count(ride_id) as rides
from `202004-divvy-tripdata`
group by end_station_name, member_casual) as min_rides
where min_rides.member_casual = station_rides.member_casual
)

## find out which date had the most\least rides by members and casuals
select *
from (
select start_date, member_casual, count(ride_id) as rides 
from `202004-divvy-tripdata` 
group by start_date, member_casual) as date_rides
having rides = (
select 
max(rides)
from (select start_date, member_casual, count(ride_id) as rides 
from `202004-divvy-tripdata` 
group by start_date, member_casual) as max_rides
where max_rides.member_casual = date_rides.member_casual
)
union all
select *
from (
select start_date, member_casual, count(ride_id) as rides 
from `202004-divvy-tripdata` 
group by start_date, member_casual) as date_rides
having rides = (
select 
min(rides)
from (select start_date, member_casual, count(ride_id) as rides 
from `202004-divvy-tripdata` 
group by start_date, member_casual) as min_rides
where min_rides.member_casual = date_rides.member_casual
)

## find out which week day had the most\least rides 
select *
from (
select day_of_the_week, member_casual, count(ride_id) as rides 
from `202004-divvy-tripdata` 
group by day_of_the_week, member_casual) as day_rides
having rides = (
select 
max(rides)
from (select day_of_the_week, member_casual, count(ride_id) as rides 
from `202004-divvy-tripdata` 
group by day_of_the_week, member_casual) as max_rides
where max_rides.member_casual = day_rides.member_casual
)
union all
select *
from (
select day_of_the_week, member_casual, count(ride_id) as rides 
from `202004-divvy-tripdata` 
group by day_of_the_week, member_casual) as day_rides
having rides = (
select 
min(rides)
from (select day_of_the_week, member_casual, count(ride_id) as rides 
from `202004-divvy-tripdata` 
group by day_of_the_week, member_casual) as min_rides
where min_rides.member_casual = day_rides.member_casual
)
  
## find out which hour had the most\least rides  
select *
from (
select hour_of_the_day, member_casual, count(ride_id) as rides 
from `202004-divvy-tripdata` 
group by hour_of_the_day, member_casual) as hour_rides
having rides = (
select 
max(rides)
from (select hour_of_the_day, member_casual, count(ride_id) as rides 
from `202004-divvy-tripdata` 
group by hour_of_the_day, member_casual) as max_rides
where max_rides.member_casual = hour_rides.member_casual
)
union all
select *
from (
select hour_of_the_day, member_casual, count(ride_id) as rides 
from `202004-divvy-tripdata` 
group by hour_of_the_day, member_casual) as hour_rides
having rides = (
select 
min(rides)
from (select hour_of_the_day, member_casual, count(ride_id) as rides 
from `202004-divvy-tripdata` 
group by hour_of_the_day, member_casual) as min_rides
where min_rides.member_casual = hour_rides.member_casual
)
  
## find the total number of rides member\casual
select member_casual, count(*) as total_rides
from`202004-divvy-tripdata`
group by member_casual

## find the total trip duration member\casual
select member_casual, sum(trip_duration) as total_trips
from`202004-divvy-tripdata`
group by member_casual

## find the total trip that took more than a day member\casual
select member_casual, sum(trip_duration) as total_trips
from`202004-divvy-tripdata`
where trip_duration > 86400
group by member_casual
# (86400) is a day in seconds 
