create database project;
use project;
-- Drop existing tables if any
DROP TABLE IF EXISTS Payments;
DROP TABLE IF EXISTS Reservations;
DROP TABLE IF EXISTS Passengers;
DROP TABLE IF EXISTS Flights;
DROP TABLE IF EXISTS Aircrafts;
DROP TABLE IF EXISTS Airports;

-- Airports table
CREATE TABLE Airports (
    airport_id INT PRIMARY KEY,
    name VARCHAR(100),
    city VARCHAR(100),
    country VARCHAR(100)
);

INSERT INTO Airports VALUES
(1, 'Rajiv Gandhi International Airport', 'Hyderabad', 'India'),
(2, 'Indira Gandhi International Airport', 'Delhi', 'India'),
(3, 'Chhatrapati Shivaji Maharaj International Airport', 'Mumbai', 'India');

-- Aircrafts table
CREATE TABLE Aircrafts (
    aircraft_id INT PRIMARY KEY,
    model VARCHAR(100),
    total_seats INT
);

INSERT INTO Aircrafts VALUES
(1, 'Airbus A320', 180),
(2, 'Boeing 737', 160);

-- Flights table
CREATE TABLE Flights (
    flight_id INT PRIMARY KEY,
    aircraft_id INT,
    departure_airport INT,
    arrival_airport INT,
    departure_time DATETIME,
    arrival_time DATETIME,
    FOREIGN KEY (aircraft_id) REFERENCES Aircrafts(aircraft_id),
    FOREIGN KEY (departure_airport) REFERENCES Airports(airport_id),
    FOREIGN KEY (arrival_airport) REFERENCES Airports(airport_id)
);

INSERT INTO Flights VALUES
(101, 1, 1, 2, '2025-08-01 06:00:00', '2025-08-01 08:30:00'),
(102, 2, 2, 3, '2025-08-01 10:00:00', '2025-08-01 12:00:00');

-- Passengers table
CREATE TABLE Passengers (
    passenger_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(15)
);

INSERT INTO Passengers VALUES
(201, 'Aarav Mehta', 'aarav@example.com', '9876543210'),
(202, 'Sneha Reddy', 'sneha@example.com', '9123456789');

-- Reservations table
CREATE TABLE Reservations (
    reservation_id INT PRIMARY KEY,
    flight_id INT,
    passenger_id INT,
    seat_number VARCHAR(50),
    booking_date DATETIME,
    status VARCHAR(20),
    FOREIGN KEY (flight_id) REFERENCES Flights(flight_id),
    FOREIGN KEY (passenger_id) REFERENCES Passengers(passenger_id)
);

INSERT INTO Reservations VALUES
(301, 101, 201, '12A', '2025-07-01 14:00:00', 'Confirmed'),
(302, 102, 202, '8B', '2025-07-01 15:30:00', 'Confirmed');

-- Payments table
CREATE TABLE Payments (
    payment_id INT PRIMARY KEY,
    reservation_id INT,
    amount DECIMAL(10, 2),
    payment_date DATETIME,
    method VARCHAR(50),
    FOREIGN KEY (reservation_id) REFERENCES Reservations(reservation_id)
);

INSERT INTO Payments VALUES
(401, 301, 5500.00, '2025-07-01 14:10:00', 'Credit Card'),
(402, 302, 4800.00, '2025-07-01 15:40:00', 'UPI');

select f.flight_id, a1.name AS from_airport, a2.name AS to_airport, f.departure_time
from flights f
join airports a1 on f.departure_airport = a1.airport_id
join airports a2 on f.arrival_airport = a2.airport_id
where a1.city = 'hyderabad' AND a2.city = 'delhi';

delimiter 
create procedure Bookseat(
in in_flight_id INT,
in in_passenger_id INT,
in in_seat_number varchar(50),
in in_amount DECIMAL(10,2),
out out_status VARCHAR(50)
)
BEGIN 
declare seat_taken INT;
select count(*) into seat_taken
from Reservations
where flight_id = in_flight_id AND seat_number = in_seat_number AND status = 'confirmed';
 IF seat_taken > 0 then
 SET out_status = 'seat already booked';
 else
 INSERT INTO Reservations (reservation_id, flight_id, passenger_id, seat_number, booking_date, status)
 values ( null, in_flight_id, in_passenger_id, in_seat_number, now(), 'confirmed');
 SET @new_res_id = last_insert_id();
 INSERT into payments (payment_id, reservation_id, amount, payment_date, method)
 values (null, @new_res_Id, in_amount, NOW(), 'credit card');
 SET out_status = 'Booking successful';
 END IF ;
 end;
 CALL BookSeat(101, 201, '12A', 5500.00, @status);
SELECT @status;
alter table Reservations
modify seat_number varchar(50);
drop procedure Bookseat;
insert into reservations (reservation_id, flight_id, passenger_id, seat_number, booking_date, status)
values(1, 101, 201, '12A', now(), 'confirmed' );
set @status = '';
call bookseat(101,201,'12A',5500,@status);
select @status; 
select * from reservations
where flight_id = 101 and status = 'confirmed';
