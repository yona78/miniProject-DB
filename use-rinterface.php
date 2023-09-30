<html>
<body>

<form method="post" action="<?php echo $_SERVER['PHP_SELF'];?>">
  Write 1 to delete a data, write 2 to update a row, write 3 to print a table, 
  write 4 to insert the queries that change the base from part 4, write 5 to insert the queries that return things from parts 4 and 2, write 6 to write sql : <input type="text" name="value1"><br>
  Enter the name of the database or, if you chose 4 or 5, enter the specific SQL, if you chose 6 write your sql: <input type="text" name="value2"><br>
  Enter the specific ID, or if you chose 5 or 7 write the data you would like to be printed : <input type="text" name="value3"><br>
  If you chose 2, enter the value to change: <input type="text" name="value4"><br>
  If you chose 2, enter the changing value: <input type="text" name="value5"><br>

  <input type="submit" value="Go">
</form>

<?php
if ($_SERVER["REQUEST_METHOD"] == "POST") {
  // collect values from input fields
  $action = $_POST['value1'];
  $name = $_POST['value2'];
  $what = $_POST['value3'];
  $val1 = $_POST['value4'];
  $val2 = $_POST['value5'];
  
  if (empty($action) || empty($name)) {
    echo "Action is empty";
  } else {
    $servername = "localhost";
    $username = "root";
    $password = "";
    $dbname = "project1";

    $conn = new mysqli($servername, $username, $password, $dbname);
    
    if ($conn->connect_error) {
      die("Connection failed: " . $conn->connect_error);
    }

    if ($action == 1) {
      // Delete a record
      $sql = "DELETE FROM " . $name . " WHERE " . $name . "_id = " . $what;
      
      if ($conn->query($sql) === TRUE) {
        echo "Record deleted successfully";
      } else {
        echo "Error deleting record: " . $conn->error;
      }
    } elseif ($action == 2) {
      // Update a record
      $sql = "UPDATE " . $name . " SET " . $val1 . " = '" . $val2 . "' WHERE " . $name . "_id = " . $what;
      
      if ($conn->query($sql) === TRUE) {
        echo "Record updated successfully";
      } else {
        echo "Error updating record: " . $conn->error;
      }
    } elseif ($action == 3) {
      // Retrieve a list
      // Assuming the list name is provided in the 'fname' input field
      $sql = "SELECT * FROM " . $name;
      $result = $conn->query($sql);

      if ($result->num_rows > 0) {
        while ($row = $result->fetch_assoc()) {
          echo $row[$what] . "<br>";
        }
      } else {
        echo "0 results";
      }
    } elseif ($action == 4) {
      // Custom queries
      if ($name == 1) {
        $sql = "SELECT
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
                COUNT(Ticket.ticket_id) > 4";
      } elseif ($name == 2) {
        $sql = "SELECT
            Route.origin_station_id,
            Route.destination_station_id,
            AVG(Ticket.fare_amount) AS avg_fare, 
            cashier.ID AS c_id 
            FROM Route 
            JOIN Train ON Route.route_id = Train.route_id 
            JOIN Ticket ON Train.train_id = Ticket.train_id
            JOIN Station ON Route.origin_station_id = Station.station_id 
            JOIN cashier ON Station.station_name = cashier.stationName 
            GROUP BY Route.origin_station_id, cashier.ID, Route.destination_station_id";
      } elseif ($name == 3) {
        $sql = "CREATE VIEW RouteStationCashierView AS
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
                cashier ON Station.station_name = cashier.stationName";
      } elseif ($name == 4) {
        $sql = "CREATE VIEW EngineerTrainView AS
            SELECT
                Train.train_id,
                Train.train_name,
                engineer.ID AS engineer_id,
                engineer.type AS engineer_type
            FROM
                Train
            JOIN engineer ON engineer.type = 'machines'
            ORDER BY RAND()";
      } elseif ($name == 5) {
        $sql = "CREATE PROCEDURE GetPassengerTickets(IN p_passenger_name VARCHAR(20))
            BEGIN
                SELECT t.ticket_id, t.train_id, t.passenger_name, t.departure_date, t.seat_number, t.fare_amount
                FROM Ticket t
                JOIN Passenger p ON t.passenger_name = p.passenger_name
                WHERE p.passenger_name = p_passenger_name";
      } elseif ($name == 6) {
        $sql = "CREATE PROCEDURE CalculateTrainRevenue(IN train_id INT, OUT total_revenue INT)
            BEGIN
                SELECT SUM(fare_amount) INTO total_revenue
                FROM Ticket
                WHERE train_id = train_id";
      } elseif ($name == 7) {
        $sql = "SELECT SUM(Ticket.fare_amount) AS total_revenue
            FROM Ticket
            JOIN Train ON Ticket.train_id = Train.train_id
            JOIN Route ON Train.route_id = Route.route_id
            WHERE Route.origin_station_id = ? AND Route.destination_station_id = ?";
      } elseif ($name == 8) {
        $sql = "CREATE TRIGGER assign_cashier_to_station
            AFTER INSERT ON Station
            FOR EACH ROW
            BEGIN
                INSERT INTO cashier (ID, stationName)
                VALUES (NEW.station_id, 'Default Cashier')";
      } elseif ($name == 9) {
        $sql = "SELECT s.station_name, s.city, s.country, c.ID
            FROM Station s
            JOIN Cashier c ON s.station_name = c.stationName
            WHERE s.station_name = <station_name>";
      } elseif ($name == 10) {
        $sql = "DELIMITER //

            CREATE TRIGGER update_train_status
            AFTER INSERT ON Ticket
            FOR EACH ROW
            BEGIN
                DECLARE num_tickets INT;
                DECLARE train_id INT;

                -- Get the train ID for the inserted ticket
                SELECT train_id INTO train_id FROM Ticket WHERE ticket_id = NEW.ticket_id;

                -- Count the number of tickets for the train
                SELECT COUNT(*) INTO num_tickets FROM Ticket WHERE train_id = train_id";
				}
		
		
		
	  $result = $conn->query($sql);
	}elseif ($action == 5) {
      // Custom queries
      if ($name == 1) {
        $sql = "SELECT
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
                COUNT(Ticket.ticket_id) > 4";
      } elseif ($name == 2) {
        $sql = "SELECT
            Route.origin_station_id,
            Route.destination_station_id,
            AVG(Ticket.fare_amount) AS avg_fare, 
            cashier.ID AS c_id 
            FROM Route 
            JOIN Train ON Route.route_id = Train.route_id 
            JOIN Ticket ON Train.train_id = Ticket.train_id
            JOIN Station ON Route.origin_station_id = Station.station_id 
            JOIN cashier ON Station.station_name = cashier.stationName 
            GROUP BY Route.origin_station_id, cashier.ID, Route.destination_station_id";
      } elseif ($name == 3) {
        $sql = "SELECT r.origin_station_id, r.destination_station_id, COUNT(*) AS num_tickets_sold,
       AVG(t.fare_amount) AS avg_fare_amount, SUM(t.fare_amount) AS total_revenue
FROM Ticket t
JOIN Train tr ON t.train_id = tr.train_id
JOIN Route r ON tr.route_id = r.route_id
GROUP BY r.origin_station_id, r.destination_station_id
ORDER BY total_revenue DESC";
      } elseif ($name == 4) {
        $sql = "SELECT 
  Route.origin_station_id, 
  Route.destination_station_id, 
  AVG(Ticket.fare_amount) AS avg_fare 
FROM 
  Route 
  JOIN Train ON Route.route_id = Train.route_id 
  JOIN Ticket ON Train.train_id = Ticket.train_id 
GROUP BY 
  Route.origin_station_id, Route.destination_station_id";
      } elseif ($name == 5) {
        $sql = "SELECT 
    Train.train_id, Train.train_name, COUNT(Ticket.ticket_id) AS Total_Tickets_Sold 
FROM 
    Train 
JOIN 
    Ticket ON Train.train_id = Ticket.train_id 
GROUP BY 
    Train.train_id 
HAVING 
    COUNT(Ticket.ticket_id) > 10";
      } elseif ($name == 6) {
        $sql = "SELECT SUM(r.distance) AS total_distance
FROM train AS t
JOIN route AS r ON t.route_id = r.route_id
WHERE r.origin_station_id = 1 AND r.destination_station_id = 4";
      } elseif ($name == 7) {
        $sql = "SELECT Train.train_name, COUNT(Ticket.train_id) AS num_tickets
FROM Train
JOIN Ticket ON Train.train_id = Ticket.train_id
GROUP BY Train.train_name";
      } elseif ($name == 8) {
        $sql = "SELECT SUM(fare_amount) AS total_revenue FROM Ticket";
      }
       
		
		
		
	  $result = $conn->query($sql);
      if ($result->num_rows > 0) {
        while ($row = $result->fetch_assoc()) {
          echo $row[$what] . "<br>";
        }
      } else {
        echo "0 results";
      }
      
    }elseif ($action == 6) {
		$result = $conn->query($name);
	  echo $result->num_rows;
      if ($result->num_rows > 0) {
        while ($row = $result->fetch_assoc()) {
          echo $row[$what] . "<br>";
        }
      } else {
        echo "0 results";
      }
	}else {
      echo "Invalid action";
    }

    $conn->close();
  }
}
?>

</body>
</html>
