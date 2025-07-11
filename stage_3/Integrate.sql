-- קובץ Integrate.sql
-- אינטגרציה בין אגף הכספים לאגף ההזמנות  וכרטיסים

-- הוספת עמודה payment_id לטבלת Ticket
ALTER TABLE ticket
ADD COLUMN payment_id INTEGER;

-- עדכון עמודת payment_id בטבלה Ticket
-- התאמה לפי סכום ותאריך (ניתן להתאים לפי הצורך)
UPDATE ticket t
SET payment_id = p.payment_id
FROM payment p
WHERE 
    t.price = p.amount
    AND t.purchasedate = p.payment_date;

-- הוספת מפתח זר לקישור בין Ticket ל-Payment
ALTER TABLE ticket
ADD CONSTRAINT fk_ticket_payment
FOREIGN KEY (payment_id)
REFERENCES payment(payment_id);
