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

### DATA ANALYSIS

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

## find out which start stations were visited the most by members and casuals
select start_station_name, count(*) as visits
from `202004-divvy-tripdata`
where member_casual = 'casual'
group by start_station_name
order by visits desc
limit 1
================================
select start_station_name, count(*) as visits
from `202004-divvy-tripdata`
where member_casual = 'member'
group by start_station_name
order by visits desc
limit 1
# this will give the name and the number of visits for the most visited station 

## find out which start stations were visited the least by members and casuals
select start_station_name, count(*) as visits
from `202004-divvy-tripdata`
where member_casual = 'casual'
group by start_station_name
order by visits asc
limit 1
================================
select start_station_name, count(*) as visits
from `202004-divvy-tripdata`
where member_casual = 'member'
group by start_station_name
order by visits asc
limit 1
# this will give the name and the number of visits for the least visited station 

## find out which date had the most\least rides
SELECT start_date, COUNT(*) as rides
FROM `202004-divvy-tripdata`
GROUP BY start_date
order by rides desc
limit 1
================================
SELECT start_date, COUNT(*) as rides
FROM `202004-divvy-tripdata`
GROUP BY start_date
order by rides asc
limit 1

## find out which week day had the most\least rides
SELECT day_of_the_week, COUNT(*) as rides
FROM `202004-divvy-tripdata`
GROUP BY day_of_the_week
order by rides desc
limit 1
================================
SELECT day_of_the_week, COUNT(*) as rides
FROM `202004-divvy-tripdata`
GROUP BY day_of_the_week
order by rides asc
limit 1

## find out the total number of rides member\casual
select count(*) as total_rides_casual
from`202004-divvy-tripdata`
where member_casual = 'casual'
================================
select count(*) as total_rides_member
from`202004-divvy-tripdata`
where member_casual = 'member'
