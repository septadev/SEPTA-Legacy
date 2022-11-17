
-- given a start and end stop, we have what we need for a list of all the available trips
-- making sure that the arrival time is after the start time

--In this case, find stops on route 44, on Saturday, given that the user has already selected
-- stop id 694, 5th St & Market St - FS as the start
-- stop id 638	52nd St & City Av - FS

-- returns 20 rows, eg. 1412	1508




SELECT
  Start.trip_id,Start.arrival_time, End.arrival_time
FROM
  -- get all the trips/ stops from the selected starting point
  (

    SELECT
      ST.trip_id, S.stop_name, ST.arrival_time
    FROM stop_times_bus ST
      JOIN stops_bus S
        ON ST.stop_id = S.stop_id

    WHERE ST.stop_id = 694 AND ST.trip_id IN (
      SELECT trip_id
      FROM trips_bus T WHERE T.route_id == 44 AND T.service_id = 2)


  ) Start
  -- get all the trips and stops from the destination point
  JOIN
  (

    SELECT
      ST.trip_id, S.stop_name, ST.arrival_time
    FROM stop_times_bus ST
      JOIN stops_bus S
        ON ST.stop_id = S.stop_id

    WHERE ST.stop_id = 638 AND ST.trip_id IN (
      SELECT trip_id
      FROM trips_bus T WHERE T.route_id == 44 AND T.service_id = 2)

  ) End
  -- join them together so they show up on the same trip
    ON Start.trip_id = End.trip_id where start.arrival_time < End.arrival_time
ORDER BY Start.arrival_time;