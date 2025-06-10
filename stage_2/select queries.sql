

✅ שאילתה 1
עבור כל הכנסה: כמה תשלומים שולמו, ומה סכום הכולל
SELECT 
  R.revenue_id,
  R.description,
  P.source,
  COUNT(P.payment_id) AS num_payments,
  SUM(P.amount) AS total_paid
FROM Revenue R
JOIN Payment P ON R.revenue_id = P.revenue_id
GROUP BY R.revenue_id, R.description, P.source
ORDER BY R.revenue_id, total_paid DESC;
🧩 שימוש במערכת: נוכל לראות איזה שירותים מכניסים הכי הרבה כסף, גם אם הם משולמים בתשלומים שונים (כמו מנוי חודשי, קנס משולם בתשלומים, וכו').


✅ שאילתה 2
 – תרחיש: "חשבונית לא שולמה – מי האחראי?"
סיטואציה: מנהלת חשבונות שמה לב שיש חשבוניות רבות שלא שולמו. היא רוצה רשימה של כל החשבוניות שמצב ההחזר שלהן "Unpaid" או "Pending", יחד עם מקור התשלום, סכום, ותאריך ההנפקה.
SELECT 
  I.invoice_id,
  I.recipient,
  I.amount,
  I.issue_date,
  I.status,
  P.source AS payment_source
FROM Invoice I
JOIN Payment P ON I.payment_id = P.payment_id
WHERE I.status IN ('Unpaid', 'Pending')
ORDER BY I.issue_date DESC;
🧩 שימוש: מאפשר למנהלת החזרות לדעת ממי צריך לדרוש תשלום ובאיזה ערוץ (האם שילם במזומן? אשראי?...)


✅ שאילתה 3
"כמה כסף שילמנו על כל סוג הוצאה?"
שימוש: מאפשר לראות מה הכי יקר לחברה – תחזוקה? דלק? שכר?
SELECT 
  ET.expense_type,
  SUM(E.amount) AS total_spent,
  COUNT(*) AS num_expenses
FROM Expense E
JOIN ExpenseTypes ET ON E.type_id = ET.type_id
GROUP BY ET.expense_type
ORDER BY total_spent DESC;


✅ שאילתה 4
 – תרחיש: 🔍 "מי הגורם הבעייתי בדוחות הביקורת?"
סיטואציה:
המבקר הראשי רוצה לדעת אילו ממצאי ביקורת (AuditRecord) כוללים סכומים גבוהים מאוד או סטטוס חריג בהוצאה/הכנסה – כדי לבדוק חריגות.
SELECT 
  AR.record_id,
  FA.auditor_name,
  AR.findings,
  E.description AS expense_desc,
  E.amount AS expense_amount,
  R.description AS revenue_desc,
  R.revenue_id
FROM AuditRecord AR
JOIN Expense E ON AR.expense_id = E.expense_id
JOIN Revenue R ON AR.revenue_id = R.revenue_id
JOIN FinancialAudit FA ON AR.audit_id = FA.audit_id
WHERE E.amount > 100000 OR AR.findings LIKE '%הפרה%' OR AR.findings LIKE '%שגיאה%'
ORDER BY E.amount DESC;
🧩 שימוש: עוזר לזהות בעיות פיננסיות/התנהלות לקויה שנמצאה בביקורת.


✅ שאילתה 5
🧩 תרחיש: מהו מקור התשלום הפופולרי ביותר בכל שנה?
מטרה:
לגלות מה מקור התשלום (כמו CASH, CREDIT, ONLINE) שהיה הנפוץ ביותר בכל שנה לפי מספר התשלומים.
SELECT 
  pay_by_year.year,
  pay_by_year.source,
  pay_by_year.total_payments
FROM (
  SELECT 
    EXTRACT(YEAR FROM payment_date) AS year,
    source,
    COUNT(*) AS total_payments,
    RANK() OVER (PARTITION BY EXTRACT(YEAR FROM payment_date) ORDER BY COUNT(*) DESC) AS rnk
  FROM Payment
  GROUP BY EXTRACT(YEAR FROM payment_date), source
) AS pay_by_year
WHERE pay_by_year.rnk = 1
ORDER BY year DESC;


✅ שאילתה 6
🧩 תרחיש: אילו שנים סבלו מהפסדים? (כלומר הוצאות גבוהות מהכנסות)
מטרה:
במערכת רוצים לדעת האם הייתה שנה בה החברה סיימה בגירעון, לפי סכום ההכנסות וההוצאות של אותה שנה.
SELECT 
  TR.tax_year,
  TR.total_revenue,
  TR.total_expense,
  (TR.total_revenue - TR.total_expense) AS balance,
  CASE 
    WHEN TR.total_revenue < TR.total_expense THEN 'Deficit'
    ELSE 'Surplus'
  END AS financial_status
FROM TaxReport TR
ORDER BY balance ASC;



✅ שאילתה 7
"תחקיר על חריגות כספיות במערכת – מי גרם לגירעון חריף?"
רקע:
ברבעון האחרון דווח על גירעון כספי חריג בחברה. מנהלת הכספים מקבלת פנייה מהנהלת החברה לבדוק:
האם קיימות שנים שבהן סכום ההוצאות עלה משמעותית על ההכנסות?
באותן שנים – מה היו הקטגוריות המרכזיות של ההוצאה שתרמו לכך?
ומה היו מקורות ההכנסה – כדי לבדוק אם מדובר גם בירידה בהכנסות או רק עלייה בהוצאות?

המטרה:
לבצע תחקיר על השנה בה נרשם הגירעון הגבוה ביותר, להבין את פירוט ההוצאות לפי סוג, סך ההכנסות לפי מקור, ולתת למנכ"ל תמונה מלאה.
שאילתה – ניתוח הגירעון הגדול ביותר לפי סוגי הוצאה והכנסה

-- שלב 1: מציאת השנה עם הפער הכי גדול (גירעון)
WITH DeficitYear AS (
  SELECT 
    tax_year,
    total_revenue,
    total_expense,
    (total_expense - total_revenue) AS deficit
  FROM TaxReport
  WHERE total_expense > total_revenue
  ORDER BY deficit DESC
  LIMIT 1
),

-- שלב 2: סיכום ההוצאות לפי סוג עבור אותה שנה
ExpensesBreakdown AS (
  SELECT 
    E.year,
    ET.expense_type,
    SUM(E.amount) AS total_expense_by_type
  FROM Expense E
  JOIN ExpenseTypes ET ON E.type_id = ET.type_id
  WHERE E.year = (SELECT tax_year FROM DeficitYear)
  GROUP BY E.year, ET.expense_type
),

-- שלב 3: סיכום ההכנסות לפי מקור תשלום עבור אותה שנה
RevenueBreakdown AS (
  SELECT 
    R.year,
    P.source,
    SUM(P.amount) AS total_paid_by_source
  FROM Revenue R
  JOIN Payment P ON R.revenue_id = P.revenue_id
  WHERE R.year = (SELECT tax_year FROM DeficitYear)
  GROUP BY R.year, P.source
)

-- שלב 4: איחוד הפלט
SELECT 
  DY.tax_year AS deficit_year,
  DY.total_revenue,
  DY.total_expense,
  DY.deficit,
  EB.expense_type,
  EB.total_expense_by_type,
  RB.source AS payment_source,
  RB.total_paid_by_source
FROM DeficitYear DY
LEFT JOIN ExpensesBreakdown EB ON DY.tax_year = EB.year
LEFT JOIN RevenueBreakdown RB ON DY.tax_year = RB.year
ORDER BY EB.total_expense_by_type DESC NULLS LAST, RB.total_paid_by_source DESC NULLS LAST;
📊 מה השאילתה הזאת מספקת?
זיהוי השנה עם הגירעון הכספי הגדול ביותר.
ניתוח ההוצאות לפי קטגוריות – כמו שכר, תחזוקה, דלק...
ניתוח הכנסות לפי מקור – מזומן, אשראי, אתר.


✅ שאילתה 8
תרחיש: "זיהוי מבקרים עם אחוז חריג של ממצאים שליליים בדוחות ביקורת"
רקע:
חברת התחבורה עוברת ביקורת פנימית וחיצונית שוטפת. על כל הכנסה/הוצאה מתקיים תיעוד בביקורת (AuditRecord), ומי שאחראי הוא המבקר (FinancialAudit.auditor_name).
הנהלת החברה רוצה לגלות:
האם יש מבקרים מסוימים שבדוחות שבפיקוחם היו הרבה ממצאים שליליים?
האם הם אחראים לרוב החריגות שנמצאות בדוחות?
כמה חריגות לעומת סה"כ ביקורות הם טיפלו?

מטרת השאילתה:
לקבל רשימה של כל המבקרים, עם:
מספר כולל של ממצאים שהם ערכו
כמה מתוכם הכילו מילים כמו "חריגה", "אי התאמה", "בעיה", "ליקוי"
לחשב את אחוז הממצאים השליליים שלהם
להציג אותם לפי אחוז שלילי מהגבוה לנמוך

SELECT 
  FA.auditor_name,
  COUNT(AR.record_id) AS total_audits,
  SUM(CASE 
        WHEN AR.findings ILIKE '%חריגה%' 
           OR AR.findings ILIKE '%בעיה%' 
           OR AR.findings ILIKE '%אי התאמה%' 
           OR AR.findings ILIKE '%ליקוי%' 
        THEN 1 ELSE 0 END) AS negative_findings,
  ROUND(
    100.0 * SUM(CASE 
        WHEN AR.findings ILIKE '%חריגה%' 
           OR AR.findings ILIKE '%בעיה%' 
           OR AR.findings ILIKE '%אי התאמה%' 
           OR AR.findings ILIKE '%ליקוי%' 
        THEN 1 ELSE 0 END) / COUNT(AR.record_id),
    2
  ) AS percent_negative
FROM FinancialAudit FA
JOIN AuditRecord AR ON FA.audit_id = AR.audit_id
GROUP BY FA.auditor_name
HAVING COUNT(AR.record_id) > 5
ORDER BY percent_negative DESC;
שימוש עסקי אמיתי:
החברה תגיד:
"המבקרת רונית בן שושן ביצעה 19 ביקורות, מתוכן 11 כללו חריגות – שיעור חריג של 57.9%. נדרש תחקיר על איכות הביקורות במחוז הדרומי."

