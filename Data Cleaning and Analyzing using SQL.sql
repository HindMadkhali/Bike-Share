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
ADD COLUMN day_of_the_week INT(25)


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

## find statistcs for Casuals and members
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

## find out which stations were visited the most 
select start_station_name, member_casual, count(*)
from `202004-divvy-tripdata`
group by start_station_name, member_casual
* this will give the name and the number of visits for each station 
================================
SELECT end_station_name, COUNT(*) as visits
FROM `202004-divvy-tripdata`
GROUP BY end_station_name;
* this will give the name and the number of visits for each station 

## find out which date was visited the most 
SELECT start_date, COUNT(*) as visits
FROM `202004-divvy-tripdata`
GROUP BY start_date;
================================
SELECT end_date, COUNT(*) as visits
FROM `202004-divvy-tripdata`
GROUP BY end_date;

## find out the total number of rides member\casual
select count(*)
from`202004-divvy-tripdata`
where member_casual = 'member'
================================
select count(*)
from`202004-divvy-tripdata`
where member_casual = 'member'
