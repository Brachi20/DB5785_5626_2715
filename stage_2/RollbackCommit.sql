-- קובץ RollbackCommit.sql
-- =====================
-- הדגמת ROLLBACK ו-COMMIT עם שלוש שאילתות עדכון

-- ========================================
-- חלק 1: הדגמת ROLLBACK - עדכון TaxReport
-- ========================================

-- 1. הצגת מצב ראשוני של TaxReport
SELECT 'מצב ראשוני - טבלת TaxReport:' as description;
SELECT tax_year, total_revenue, total_expense, tax_amount, tax_paid, report_date 
FROM TaxReport 
ORDER BY tax_year;

-- 2. התחלת טרנזקציה
BEGIN;

-- 3. ביצוע עדכון TaxReport
UPDATE TaxReport TR 
SET total_revenue = COALESCE((
    SELECT SUM(P.amount) 
    FROM Revenue R 
    JOIN Payment P ON R.revenue_id = P.revenue_id 
    WHERE R.year = TR.tax_year 
), 0),
total_expense = COALESCE((
    SELECT SUM(E.amount) 
    FROM Expense E 
    WHERE E.year = TR.tax_year 
), 0),
tax_amount = ROUND(COALESCE((
    SELECT SUM(P.amount) 
    FROM Revenue R 
    JOIN Payment P ON R.revenue_id = P.revenue_id 
    WHERE R.year = TR.tax_year 
), 0) * (TR.discount_percent / 100.0), 2),
tax_paid = COALESCE((
    SELECT SUM(P.amount) 
    FROM Revenue R 
    JOIN Payment P ON R.revenue_id = P.revenue_id 
    WHERE R.year = TR.tax_year 
), 0),
report_date = CURRENT_DATE
WHERE EXISTS (
    SELECT 1 FROM Revenue R WHERE R.year = TR.tax_year 
) OR EXISTS (
    SELECT 1 FROM Expense E WHERE E.year = TR.tax_year 
);

-- 4. הצגת מצב אחרי העדכון
SELECT 'מצב אחרי עדכון TaxReport:' as description;
SELECT tax_year, total_revenue, total_expense, tax_amount, tax_paid, report_date 
FROM TaxReport 
ORDER BY tax_year;

-- 5. ביצוע ROLLBACK
ROLLBACK;

-- 6. הצגת מצב אחרי ROLLBACK
SELECT 'מצב אחרי ROLLBACK - TaxReport חזר למצב מקורי:' as description;
SELECT tax_year, total_revenue, total_expense, tax_amount, tax_paid, report_date 
FROM TaxReport 
ORDER BY tax_year;

-- ==========================================
-- חלק 2: הדגמת COMMIT - עדכון סטטוס Invoice
-- ==========================================

-- 1. הצגת מצב ראשוני של Invoice
SELECT 'מצב ראשוני - טבלת Invoice:' as description;
SELECT invoice_id, recipient, status, payment_id, amount
FROM Invoice 
ORDER BY invoice_id
LIMIT 10;

-- 2. התחלת טרנזקציה חדשה
BEGIN;

-- 3. ביצוע עדכון סטטוס Invoice (שאילתה פשוטה יותר)
UPDATE Invoice 
SET status = 'Updated by Transaction'
WHERE invoice_id IN (
    SELECT invoice_id 
    FROM Invoice 
    LIMIT 5
);

-- 4. הצגת מצב אחרי העדכון
SELECT 'מצב אחרי עדכון Invoice:' as description;
SELECT invoice_id, recipient, status, payment_id, amount
FROM Invoice 
ORDER BY invoice_id
LIMIT 10;

-- 5. ביצוע COMMIT
COMMIT;

-- 6. הצגת מצב אחרי COMMIT
SELECT 'מצב אחרי COMMIT - השינויים נשמרו:' as description;
SELECT invoice_id, recipient, status, payment_id, amount
FROM Invoice 
ORDER BY invoice_id
LIMIT 10;

-- ===============================================
-- חלק 3: הדגמת ROLLBACK נוסף - עדכון status_id
-- ===============================================

-- 1. הצגת מצב ראשוני של Invoice status_id
SELECT 'מצב ראשוני - status_id בטבלת Invoice:' as description;
SELECT invoice_id, status_id, payment_id
FROM Invoice 
WHERE status_id IS NOT NULL
ORDER BY invoice_id
LIMIT 8;

-- 2. התחלת טרנזקציה
BEGIN;

-- 3. עדכון status_id (גרסה פשוטה)
UPDATE Invoice 
SET status_id = 999
WHERE status_id = 1
AND invoice_id IN (
    SELECT invoice_id 
    FROM Invoice 
    WHERE status_id = 1
    LIMIT 3
);

-- 4. הצגת מצב אחרי העדכון
SELECT 'מצב אחרי עדכון status_id:' as description;
SELECT invoice_id, status_id, payment_id
FROM Invoice 
WHERE invoice_id IN (
    SELECT invoice_id 
    FROM Invoice 
    ORDER BY invoice_id
    LIMIT 8
)
ORDER BY invoice_id;

-- 5. ביצוע ROLLBACK
ROLLBACK;

-- 6. הצגת מצב אחרי ROLLBACK
SELECT 'מצב אחרי ROLLBACK - status_id חזר למצב מקורי:' as description;
SELECT invoice_id, status_id, payment_id
FROM Invoice 
WHERE status_id IS NOT NULL
ORDER BY invoice_id
LIMIT 8;

-- ===========================
-- סיכום כללי
-- ===========================

SELECT 'סיכום ביצוע:' as summary,
       'ROLLBACK ביטל שינויים, COMMIT שמר שינויים' as result;

-- בדיקה סופית - ודא שהשינויים מהחלק השני נשמרו
SELECT 'בדיקה סופית - Invoice שעודכן בחלק השני:' as final_check;
SELECT invoice_id, status, payment_id
FROM Invoice 
WHERE status = 'Updated by Transaction'
ORDER BY invoice_id;