SELECT
  R.Route_id,
  R.route_short_name || ' to ' || S.stop_name route_short_name,
  R.route_long_name,
  T.direction_id                              dircode

FROM routes_rail R
  JOIN trips_rail T ON R.route_id = T.route_id
  JOIN stop_times_rail ST ON T.trip_id = ST.trip_id
  JOIN stops_rail S ON ST.stop_id = S.stop_id
  JOIN
  (
    SELECT
      R.route_id,
      T.direction_id,
      max(ST.stop_sequence) max_stop_sequence

    FROM routes_rail R
      JOIN trips_rail T ON R.route_id = T.route_id
      JOIN stop_times_rail ST ON T.trip_id = ST.trip_id
      JOIN stops_rail S ON ST.stop_id = S.stop_id
    GROUP BY R.route_id, T.direction_id) lastStop
    ON R.route_id = lastStop.route_id AND T.direction_id = lastStop.direction_id AND
       ST.stop_sequence = lastStop.max_stop_sequence
GROUP BY R.Route_id,R.route_short_name, R.route_long_name,T.direction_id ,S.stop_name;


SELECT
  cast(R.route_id AS TEXT)          route_id,
  'to ' || BSD.DirectionDescription route_short_name,
  R.route_long_name,
  BSD.dircode
FROM bus_stop_directions BSD
  JOIN routes_bus R
    ON BSD.Route = R.route_id
WHERE R.route_type = 3
      AND R.route_id NOT IN ('BSO', 'BSL', 'MFL');



SELECT
R.Route_id,
R.route_short_name || 'to ' || S.stop_name route_short_name,
' to ' || S.stop_name route_long_name,
cast (T.direction_id  as TEXT )                            dircode

FROM routes_rail R
JOIN trips_rail T ON R.route_id = T.route_id
JOIN stop_times_rail ST ON T.trip_id = ST.trip_id
JOIN stops_rail S ON ST.stop_id = S.stop_id
JOIN
(
SELECT
R.route_id,
T.direction_id,
max(ST.stop_sequence) max_stop_sequence

FROM routes_rail R
JOIN trips_rail T ON R.route_id = T.route_id
JOIN stop_times_rail ST ON T.trip_id = ST.trip_id
JOIN stops_rail S ON ST.stop_id = S.stop_id
GROUP BY R.route_id, T.direction_id) lastStop
ON R.route_id = lastStop.route_id AND T.direction_id = lastStop.direction_id AND
ST.stop_sequence = lastStop.max_stop_sequence
GROUP BY R.Route_id,R.route_short_name, R.route_long_name,T.direction_id ,S.stop_name;

SELECT
  S.stop_id                   stopId,
  S.stop_name                 stopName,
  cast(S.stop_lat AS DECIMAL) stopLatitude,
  cast(S.stop_lon AS DECIMAL) stopLongitude,
  CASE WHEN S.wheelchair_boarding = '1'
    THEN 1
  ELSE 0 END                  wheelchairBoarding,
  MAX(CASE WHEN T.service_id = '1'
    THEN 1
      ELSE 0 END)             weekdayService,
  MAX(CASE WHEN
    T.service_id = '2'
    THEN 1
      ELSE 0 END)             saturdayService,
  MAX(CASE WHEN
    T.service_id = '3'
    THEN 1
      ELSE 0 END) AS          sundayService
FROM trips_bus T
JOIN routes_bus R
ON T.route_id = R.route_id
JOIN stop_times_bus ST
ON T.trip_id = ST.trip_id
join stops_bus S
  on ST.stop_id = S.Stop_id
JOIN (SELECT
  T.trip_id,
  ST.stop_sequence
FROM trips_bus T
JOIN stop_times_bus ST
ON T.trip_id = ST.trip_id
WHERE route_id = '44' AND T.direction_id = 0 AND ST.stop_id = 1167) Start
ON T.trip_id = Start.trip_id AND ST.stop_sequence > Start.stop_sequence
WHERE T.route_id = '44' AND direction_id = '0'
GROUP BY S.stop_id, S.stop_name, S.stop_lat, S.stop_lon;

SELECT
R.Route_id,
R.route_short_name || ' to ' || S.stop_name route_short_name,
'to ' || S.stop_name route_long_name,
cast (T.direction_id  as TEXT )                            dircode

FROM routes_rail R
JOIN trips_rail T ON R.route_id = T.route_id
JOIN stop_times_rail ST ON T.trip_id = ST.trip_id
JOIN stops_rail S ON ST.stop_id = S.stop_id
JOIN
(
SELECT
R.route_id,
T.direction_id,
max(ST.stop_sequence) max_stop_sequence

FROM routes_rail R
JOIN trips_rail T ON R.route_id = T.route_id
JOIN stop_times_rail ST ON T.trip_id = ST.trip_id
JOIN stops_rail S ON ST.stop_id = S.stop_id
GROUP BY R.route_id, T.direction_id) lastStop
ON R.route_id = lastStop.route_id AND T.direction_id = lastStop.direction_id AND
ST.stop_sequence = lastStop.max_stop_sequence
GROUP BY R.Route_id,R.route_short_name, R.route_long_name,T.direction_id ,S.stop_name;

-- Sunday, Monday, Tuesday, Wed, Thursday, Friday, Saturday
--  64       32       16       8     4        2        1

select * from calendar_rail where days & 2 order by days desc;
select * from calendar_rail where days & 32 order by days desc;

select * from calendar_bus where days & 32 order by days desc;


SELECT
cast(R.route_id AS TEXT) route_id,
route_long_name route_short_name,
'to ' || BSD.DirectionDescription route_long_name,
BSD.dircode
  BSD.dircode
FROM bus_stop_directions BSD
JOIN routes_bus R
ON BSD.Route = R.route_id
where BSD.dircode != '0' and R.route_id = '2';

  SELECT
  start.arrival_time DepartureTime,
  Stop.arrival_time  ArrivalTime,
  Start.block_id
  FROM

  (SELECT
  T.trip_id,
  ST.arrival_time,
  T.block_id
  FROM
  stop_times_bus ST
  JOIN trips_bus T
  ON ST.trip_id = T.trip_id
WHERE ST.stop_id = 22990 AND T.service_id = 2 and T.direction_id = 1) Start

JOIN (SELECT
T.trip_id, T.direction_id, T.service_id,
ST.arrival_time
FROM
stop_times_bus  ST
JOIN trips_bus T
ON ST.trip_id = T.trip_id
WHERE  stop_id = 22997 AND T.service_id = 2 and T.direction_id = 1) Stop
ON start.trip_id = stop.trip_id
group by start.arrival_time, Stop.arrival_time
ORDER BY DepartureTime;



SELECT
start.arrival_time DepartureTime,
Stop.arrival_time  ArrivalTime,
start.block_id
FROM

(SELECT
T.trip_id,T.route_id,
ST.arrival_time,
T.block_id
FROM
stop_times_rail ST
JOIN trips_rail T
ON ST.trip_id = T.trip_id
WHERE ST.stop_id = 90403 and T.direction_id = 1 and T.service_id in (select service_id from calendar_rail C where days & 32)) Start

JOIN (SELECT
T.trip_id, T.direction_id, T.service_id,
ST.arrival_time
FROM
stop_times_rail ST
JOIN trips_rail T
ON ST.trip_id = T.trip_id
WHERE  stop_id = 90401 and T.direction_id = 1  and T.service_id in (select service_id from calendar_rail  C where days & 32)) Stop
ON start.trip_id = stop.trip_id
group by start.arrival_time, stop.arrival_time;


SELECT
  NewStart.arrival_time,
  NewEnd.arrival_time
FROM

  (
    SELECT
      S.stop_id,
      T.trip_id,
      ST.arrival_time
    FROM stops_rail S
      JOIN stop_times_rail ST
      ON S.stop_id = ST.stop_id
      JOIN trips_rail T
      ON ST.trip_id = T.trip_id
    WHERE S.stop_id = 90713 AND T.direction_id = 1 AND T.service_id = 4) NewStart
  JOIN
  (SELECT
    S.stop_id,
    T.trip_id,
    ST.arrival_time
  FROM stops_rail S
    JOIN stop_times_rail ST
    ON S.stop_id = ST.stop_id
    JOIN trips_rail T
    ON ST.trip_id = T.trip_id
  WHERE S.stop_id = 90720 AND T.direction_id = 1 AND T.service_id = 4) NewEnd
  ON NewStart.trip_id = NewEnd.trip_id;


SELECT
  NewStart.arrival_time,
  NewEnd.arrival_time,
NewStart.block_id
FROM

(SELECT
T.trip_id,
ST.arrival_time,
T.block_id
FROM

  (
    SELECT
      S.stop_id,
      T.trip_id,
      ST.arrival_time
    FROM stops_bus S
      JOIN stop_times_bus ST
      ON S.stop_id = ST.stop_id
      JOIN trips_bus T
      ON ST.trip_id = T.trip_id
    WHERE S.stop_id = 5229 AND T.direction_id = 1 AND T.service_id = 1) NewStart
  JOIN
  (SELECT
    S.stop_id,
    T.trip_id,
    ST.arrival_time
  FROM stops_bus S
    JOIN stop_times_bus ST
    ON S.stop_id = ST.stop_id
    JOIN trips_bus T
    ON ST.trip_id = T.trip_id
  WHERE S.stop_id = 17277 AND T.direction_id = 1 AND T.service_id = 1) NewEnd
  ON NewStart.trip_id = NewEnd.trip_id;





SELECT
  NewStart.arrival_time,
  NewEnd.arrival_time,
  NewStart.block_id
FROM

  (
    SELECT
      S.stop_id,
      T.trip_id,
      ST.arrival_time,
      T.block_id
    FROM stops_bus S
      JOIN stop_times_bus ST
      ON S.stop_id = ST.stop_id
      JOIN trips_bus T
      ON ST.trip_id = T.trip_id
    WHERE S.stop_id = 20965 AND T.direction_id = 1 AND T.service_id = 1) NewStart
  JOIN
  (SELECT
    S.stop_id,
    T.trip_id,
    ST.arrival_time
  FROM stops_bus S
    JOIN stop_times_bus ST
    ON S.stop_id = ST.stop_id
    JOIN trips_bus T
    ON ST.trip_id = T.trip_id
  WHERE S.stop_id = 152 AND T.direction_id = 1 AND T.service_id = 1) NewEnd
  ON NewStart.trip_id = NewEnd.trip_id;