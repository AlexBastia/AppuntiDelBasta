SELECT MIN(Mile), MAX(Mile)
FROM TRAIN AS T
WHERE T.Departure = 'Boston' AND T.Arrival = 'Chicago'