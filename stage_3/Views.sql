-- יצירת מבט מהצד הפיננסי
CREATE OR REPLACE VIEW view_payment_summary AS
SELECT 
    p.payment_id,
    p.payment_method,
    p.payment_date,
    p.amount AS payment_amount,
    t.ticketid,
    t.price AS ticket_price,
    t.purchasedate
FROM payment p
JOIN ticket t ON p.payment_id = t.payment_id;

-- שאילתה 1 על המבט הפיננסי
SELECT * 
FROM view_payment_summary
WHERE payment_method = 'Credit' AND ticket_price > 100;

-- שאילתה 2 על המבט הפיננסי
SELECT payment_date, SUM(ticket_price) AS total_income
FROM view_payment_summary
GROUP BY payment_date
ORDER BY payment_date;


-- יצירת מבט מהצד של ההזמנות
CREATE OR REPLACE VIEW view_passenger_tickets AS
SELECT 
    ps.passengerid,
    ps.fullname,
    ps.email,
    t.ticketid,
    t.purchasedate,
    t.price,
    p.payment_method,
    p.payment_date
FROM passenger ps
JOIN ticket t ON ps.passengerid = t.passengerid
LEFT JOIN payment p ON t.payment_id = p.payment_id;

-- שאילתה 1 על המבט של ההזמנות
SELECT fullname, email, ticketid, price
FROM view_passenger_tickets
WHERE price > 150;

-- שאילתה 2 על המבט של ההזמנות
SELECT payment_method, COUNT(*) AS num_tickets
FROM view_passenger_tickets
GROUP BY payment_method;
