select 
sum(trip_duration)
from`202004-divvy-tripdata`
where member_casual = 'member'
  
INSERT INTO `Sum` (`sum(trip_duration)`) VALUES (78282355);
