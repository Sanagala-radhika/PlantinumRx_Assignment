1.Last booked room per user

SELECT user_id, room_no
FROM (
    SELECT 
        user_id,
        room_no,
        ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY booking_date DESC) AS rn
    FROM bookings
) t
WHERE rn = 1;

2.Booking_id +total billig(Nov 2021) 

  SELECT 
    bc.booking_id,
    SUM(bc.item_quantity * i.item_rate) AS total_bill
FROM booking_commercials bc
JOIN items i ON bc.item_id = i.item_id
WHERE MONTH(bc.bill_date) = 11 
  AND YEAR(bc.bill_date) = 2021
GROUP BY bc.booking_id;

3.Bills in oct 2021>1000 

SELECT 
    bill_id,
    SUM(item_quantity * i.item_rate) AS bill_amount
FROM booking_commercials bc
JOIN items i ON bc.item_id = i.item_id
WHERE MONTH(bill_date) = 10 
  AND YEAR(bill_date) = 2021
GROUP BY bill_id
HAVING bill_amount > 1000;

4.Most& least ordered item per month 2021

SELECT *
FROM (
    SELECT 
        MONTH(bc.bill_date) AS month,
        i.item_name,
        SUM(bc.item_quantity) AS total_qty,
        RANK() OVER (PARTITION BY MONTH(bc.bill_date) ORDER BY SUM(bc.item_quantity) DESC) AS rnk_max,
        RANK() OVER (PARTITION BY MONTH(bc.bill_date) ORDER BY SUM(bc.item_quantity) ASC) AS rnk_min
    FROM booking_commercials bc
    JOIN items i ON bc.item_id = i.item_id
    WHERE YEAR(bc.bill_date) = 2021
    GROUP BY month, i.item_name
) t
WHERE rnk_max = 1 OR rnk_min = 1; 

5.Cutomers with 2nd highest each month 

SELECT *
FROM (
    SELECT 
        MONTH(bc.bill_date) AS month,
        i.item_name,
        SUM(bc.item_quantity) AS total_qty,
        RANK() OVER (PARTITION BY MONTH(bc.bill_date) ORDER BY SUM(bc.item_quantity) DESC) AS rnk_max,
        RANK() OVER (PARTITION BY MONTH(bc.bill_date) ORDER BY SUM(bc.item_quantity) ASC) AS rnk_min
    FROM booking_commercials bc
    JOIN items i ON bc.item_id = i.item_id
    WHERE YEAR(bc.bill_date) = 2021
    GROUP BY month, i.item_name
) t
WHERE rnk_max = 1 OR rnk_min = 1;

