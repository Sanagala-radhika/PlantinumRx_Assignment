1.Revenue per sales channel (year)

SELECT 
    sales_channel,
    SUM(amount) AS revenue
FROM clinic_sales
WHERE YEAR(datetime) = 2021
GROUP BY sales_channel; 

2.Top 10 valuable customers 

  SELECT 
    uid,
    SUM(amount) AS total_spent
FROM clinic_sales
WHERE YEAR(datetime) = 2021
GROUP BY uid
ORDER BY total_spent DESC
LIMIT 10;

3.Month-wise revenue,expense profit,status 

WITH revenue AS (
    SELECT 
        MONTH(datetime) AS month,
        SUM(amount) AS revenue
    FROM clinic_sales
    WHERE YEAR(datetime) = 2021
    GROUP BY month
),
expense AS (
    SELECT 
        MONTH(datetime) AS month,
        SUM(amount) AS expense
    FROM expenses
    WHERE YEAR(datetime) = 2021
    GROUP BY month
)
SELECT 
    r.month,
    r.revenue,
    e.expense,
    (r.revenue - e.expense) AS profit,
    CASE 
        WHEN (r.revenue - e.expense) > 0 THEN 'Profitable'
        ELSE 'Not Profitable'
    END AS status
FROM revenue r
JOIN expense e ON r.month = e.month;

4.Most profitable clinic per city 

SELECT *
FROM (
    SELECT 
        c.city,
        cs.cid,
        SUM(cs.amount) - COALESCE(SUM(e.amount),0) AS profit,
        RANK() OVER (PARTITION BY c.city ORDER BY (SUM(cs.amount) - COALESCE(SUM(e.amount),0)) DESC) AS rnk
    FROM clinic_sales cs
    JOIN clinics c ON cs.cid = c.cid
    LEFT JOIN expenses e ON cs.cid = e.cid 
        AND MONTH(cs.datetime) = MONTH(e.datetime)
    WHERE MONTH(cs.datetime) = 11
    GROUP BY c.city, cs.cid
) t
WHERE rnk = 1;

5.2nd least profitable clinic per state 
SELECT *
FROM (
    SELECT 
        c.state,
        cs.cid,
        SUM(cs.amount) - COALESCE(SUM(e.amount),0) AS profit,
        DENSE_RANK() OVER (
            PARTITION BY c.state 
            ORDER BY (SUM(cs.amount) - COALESCE(SUM(e.amount),0)) ASC
        ) AS rnk
    FROM clinic_sales cs
    JOIN clinics c ON cs.cid = c.cid
    LEFT JOIN expenses e ON cs.cid = e.cid 
        AND MONTH(cs.datetime) = MONTH(e.datetime)
    WHERE MONTH(cs.datetime) = 11
    GROUP BY c.state, cs.cid
) t
WHERE rnk = 2;

