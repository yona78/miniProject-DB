--
--first
--
SELECT r.origin_station_id, r.destination_station_id, COUNT(*) AS num_tickets_sold,
       AVG(t.fare_amount) AS avg_fare_amount, SUM(t.fare_amount) AS total_revenue
FROM Ticket t
JOIN Train tr ON t.train_id = tr.train_id
JOIN Route r ON tr.route_id = r.route_id
GROUP BY r.origin_station_id, r.destination_station_id
ORDER BY total_revenue DESC;

--
--2
--
SELECT 
  Route.origin_station_id, 
  Route.destination_station_id, 
  AVG(Ticket.fare_amount) AS avg_fare 
FROM 
  Route 
  JOIN Train ON Route.route_id = Train.route_id 
  JOIN Ticket ON Train.train_id = Ticket.train_id 
GROUP BY 
  Route.origin_station_id, Route.destination_station_id;

--
--3
--
SELECT 
    Train.train_id, Train.train_name, COUNT(Ticket.ticket_id) AS Total_Tickets_Sold 
FROM 
    Train 
JOIN 
    Ticket ON Train.train_id = Ticket.train_id 
GROUP BY 
    Train.train_id 
HAVING 
    COUNT(Ticket.ticket_id) > 10;


--
--4
--
SELECT SUM(r.distance) AS total_distance
FROM train AS t
JOIN route AS r ON t.route_id = r.route_id
WHERE r.origin_station_id = 1 AND r.destination_station_id = 4;


--
--5
--
SELECT Train.train_name, COUNT(Ticket.train_id) AS num_tickets
FROM Train
JOIN Ticket ON Train.train_id = Ticket.train_id
GROUP BY Train.train_name;

--
--6
--
SELECT SUM(fare_amount) AS total_revenue FROM Ticket;
