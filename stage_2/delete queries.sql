שאילתה 1

DELETE FROM Payment
WHERE payment_method = 'Cash'
AND revenue_id IN (
    SELECT revenue_id FROM Revenue WHERE year < 2022
)
AND payment_id NOT IN (
    SELECT payment_id FROM Invoice WHERE payment_id IS NOT NULL
);
 

שאילתה 2

-- שלב 1: מחיקת התיעוד מטבלת AuditRecord עבור הרשומות המתאימות
DELETE FROM AuditRecord
WHERE expense_id IN (
    SELECT expense_id
    FROM Expense
    WHERE status = 'Unpaid'
      AND due_date < CURRENT_DATE - INTERVAL '1 year'
      AND description IN ('Maintenance', 'Fuel')
);

-- שלב 2: מחיקת ההוצאות עצמן
DELETE FROM Expense
WHERE status = 'Unpaid'
  AND due_date < CURRENT_DATE - INTERVAL '1 year'
  AND description IN ('Maintenance', 'Fuel');


שאילתה 3

DELETE
FROM AuditRecord
WHERE findings = 'General check'
  AND expense_id IN (
    SELECT expense_id
    FROM Expense
    WHERE amount < 1000
      AND status = 'Paid'
  );

