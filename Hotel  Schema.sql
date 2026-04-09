CREATE TABLE bookings (
    booking_id INT,
    user_id INT,
    room_id INT,
    booking_date DATE
);

CREATE TABLE items (
    item_id INT,
    item_name VARCHAR(50),
    rate INT
);

CREATE TABLE booking_commercials (
    booking_id INT,
    item_id INT,
    quantity INT
);

INSERT INTO bookings VALUES
(1, 101, 201, '2021-11-10'),
(2, 102, 202, '2021-11-15'),
(3, 103, 203, '2021-12-01');

INSERT INTO items VALUES
(1, 'Food', 200),
(2, 'Laundry', 100),
(3, 'Spa', 500);

INSERT INTO booking_commercials VALUES
(1,1,3),
(1,2,2),
(2,3,1),
(3,1,5);
