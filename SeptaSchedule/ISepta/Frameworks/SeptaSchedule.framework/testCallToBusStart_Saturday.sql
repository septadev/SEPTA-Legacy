
-- search for all bus stops that run on Saturday on Route 44

-- returns 122 rows

-- including 20589	54th St & City Av 39.99696	-75.235135


SELECT
  S.stop_id, S.Stop_name, S.stop_lat, S.stop_lon, s.wheelchair_boarding
FROM stops_bus S
WHERE S.stop_id IN (
  SELECT ST.stop_id
  FROM trips_bus T
    JOIN stop_times_bus ST
      ON T.trip_id = ST.trip_id WHERE
    T.route_id == 44 AND T.service_id = 2)
ORDER BY S.stop_name;

