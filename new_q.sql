----
--1--
----
SELECT
    Train.train_id,
    Train.train_name,
    (
        SELECT driver.ID
        FROM driver
        ORDER BY RAND()
        LIMIT 1
    ) AS driver_id,
    (
        SELECT driver.License
        FROM driver
        WHERE driver.ID = driver_id
    ) AS type,
    COUNT(Ticket.ticket_id) AS Total_Tickets_Sold
FROM
    Train
JOIN
    Ticket ON Train.train_id = Ticket.train_id
GROUP BY
    Train.train_id
HAVING
    COUNT(Ticket.ticket_id) > 4;



----
--2--
----
SELECT Route.origin_station_id,
Route.destination_station_id,
AVG(Ticket. fare_amount) AS avg_fare, 
cashier.ID AS c_id 
FROM Route 
JOIN Train ON Route.route_id = Train.route_id 
JOIN Ticket ON Train.train_id = Ticket.train_id
JOIN Station ON Route.origin_station_id = Station.station_id 
JOIN cashier ON Station.station_name = cashier.stationName 
GROUP BY Route.origin_station_id, cashier.ID, Route.destination_station_id;


----
--3--
----
CREATE VIEW RouteStationCashierView AS
SELECT
    Route.route_id,
    Route.origin_station_id,
    Route.destination_station_id,
    Station.station_name,
    cashier.ID,
    cashier.stationName
FROM
    Route
JOIN
    Station ON Route.origin_station_id = Station.station_id
JOIN
    cashier ON Station.station_name = cshier.stationName;

----
--4--
----
CREATE VIEW EngineerTrainView AS
SELECT
    Train.train_id,
    Train.train_name,
    engineer.ID AS engineer_id,
    engineer.type AS engineer_type
FROM
    Train
JOIN engineer ON engineer.type = 'machines'
ORDER BY RAND();

----
--5--
----
DELIMITER //

CREATE PROCEDURE GetPassengerTickets(IN p_passenger_name VARCHAR(20))
BEGIN
    SELECT t.ticket_id, t.train_id, t.passenger_name, t.departure_date, t.seat_number, t.fare_amount
    FROM Ticket t
    JOIN Passenger p ON t.passenger_name = p.passenger_name
    WHERE p.passenger_name = p_passenger_name;
END //

DELIMITER ;


----
--6--
----
DELIMITER //

CREATE PROCEDURE CalculateTrainRevenue(IN train_id INT, OUT total_revenue INT)
BEGIN
    SELECT SUM(fare_amount) INTO total_revenue
    FROM Ticket
    WHERE train_id = train_id;
END //

DELIMITER ;

----
--7--
----
SELECT SUM(Ticket.fare_amount) AS total_revenue
FROM Ticket
JOIN Train ON Ticket.train_id = Train.train_id
JOIN Route ON Train.route_id = Route.route_id
WHERE Route.origin_station_id = ? AND Route.destination_station_id = ?


----
--8--
----
DELIMITER //

CREATE TRIGGER assign_cashier_to_station
AFTER INSERT ON Station
FOR EACH ROW
BEGIN
    INSERT INTO cashier (ID, stationName)
    VALUES ( NEW.station_id,'Default Cashier');
END;
//

DELIMITER ;

----
--9--
----
SELECT s.station_name, s.city, s.country, c.ID
FROM Station s
JOIN Cashier c ON s.station_name = c.stationName
WHERE s.station_name = <station_name>;


----
--10--
----
DELIMITER //

CREATE TRIGGER update_train_status
AFTER INSERT ON Ticket
FOR EACH ROW
BEGIN
    DECLARE num_tickets INT;
    DECLARE train_id INT;

    -- Get the train ID for the inserted ticket
    SELECT train_id INTO train_id FROM Ticket WHERE ticket_id = NEW.ticket_id;

    -- Count the number of tickets for the train
    SELECT COUNT(*) INTO num_tickets FROM Ticket WHERE train_id = train_id;

    -- Update the train type based on the number of tickets
    IF num_tickets > 10 THEN
        UPDATE Train SET train_type = 'bobmobil' WHERE train_id = train_id;
    END IF;
END;
//

DELIMITER ;

