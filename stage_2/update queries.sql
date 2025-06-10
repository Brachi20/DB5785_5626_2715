
✅ השאילתא 1 
UPDATE TaxReport TR
SET 
  total_revenue = COALESCE((
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
  OR EXISTS (
    SELECT 1 FROM Expense E WHERE E.year = TR.tax_year
  )
);

עשינו עדכון לטבלה הוספנו עמודה לפיה נחשב את אחוז המס - והשדה יהיה מאותחל ל18:
ALTER TABLE TaxReport
ADD discount_percent NUMERIC(5,2) DEFAULT 18 NOT NULL;

עדכון נוסף האילוץ עבור חישוב השדה של סכום המס בפועלL:
UPDATE TaxReport
SET tax_amount = ROUND(total_revenue * (discount_percent / 100.0), 2);


עידכנתי את הטבלה : Invoice כך שהשדה amount  כבר לא קיים כי זה מיותר יש את סכום התשלום ששמור כבר



✅2 השאילתה:
תרחיש: "סגירת חודש – עדכון מצב חשבוניות לפי סכומי תשלום בפועל"
🎯 מטרה:
בסוף כל חודש, על המערכת לבדוק האם:
החשבונית שולמה במלואה → נעדכן status = 'Paid'
החשבונית שולמה חלקית → status = 'Partial'
החשבונית לא שולם עליה כלל → status = 'Unpaid'
התהליך הזה הוא חלק מ"סגירת חודש פיננסי", והוא נדרש לדוחות, התראות, והעברה לרואה חשבון/מערכת ERP.

דרישות:
לכל חשבונית יש שדה amount (סכום החשבונית)
ויש payment_id שמפנה לרשומה ב־Payment
ב־Payment.amount יש את הסכום ששולם בפועל

UPDATE Invoice I
SET status = CASE
    WHEN P.amount >= I.amount THEN 'Paid'
    WHEN P.amount > 0 AND P.amount < I.amount THEN 'Partial'
    WHEN P.amount = 0 THEN 'Unpaid'
    ELSE I.status
  END
FROM Payment P
WHERE I.payment_id = P.payment_id
  AND (
    (P.amount >= I.amount AND I.status <> 'Paid') OR
    (P.amount > 0 AND P.amount < I.amount AND I.status <> 'Partial') OR
    (P.amount = 0 AND I.status <> 'Unpaid')
  );

🧩 שימוש אמיתי:
מריצים את השאילתה בסוף כל חודש
הממשק של ניהול החשבוניות מציג רק חשבוניות עם status <> 'Paid'
מנוע התראות שולח מיילים על Partial או Unpaid
משמש לדוחות הנהלת חשבונות חודשיים / חיתוך תשלומים לפי חודשים




✅שאילתה 3 :
 תרחיש: "אירוע גבייה כפולה בעקבות באג במערכת – תיקון אוטומטי לחשבוניות שנרשם להן תשלום כפול"
🎯 רקע:
בחודש האחרון התגלה באג באפליקציית התשלומים של החברה – לקוחות שביצעו תשלום דרך האתר קיבלו הודעת שגיאה, ולכן חשבו שהתשלום לא עבר – וביצעו אותו שוב.
בפועל: נוצרו שתי רשומות בתשלום (Payment) לאותה חשבונית (Invoice), וכל אחת מהן עם אותו סכום, בהפרש של דקות.
🔍 הבעיה:
המערכת ראתה את שתי ההעברות כתשלומים נפרדים (ולא כפולים), ולכן:
סכום כולל ב־Payment גבוה מה־Invoice.amount
והחשבונית קיבלה סטטוס Paid – למרות שהסכום בפועל גבוה מהנדרש
🛠️ מה נעשה?
נזהה חשבוניות שבהן:
יש יותר מתשלום אחד מקושר
סכום התשלום גבוה מהסכום הרשום בחשבונית
ההפרש קטן מ־₪5 (כלומר, כנראה הקליק פעמיים)
ונעדכן את החשבונית ל־status = 'Duplicate Payment'
השאילתה:

UPDATE Invoice I
SET status = 'Duplicate Payment'
WHERE I.status = 'Paid'
AND EXISTS (
  SELECT 1
  FROM Payment P
  WHERE P.payment_id = I.payment_id
  GROUP BY P.revenue_id
  HAVING COUNT(*) > 1
)
AND EXISTS (
  SELECT 1
  FROM Payment P
  WHERE P.payment_id = I.payment_id
  AND P.amount > I.amount
  AND P.amount - I.amount < 5
);

🧩 תוצאה:
המערכת מסמנת חשבוניות חשודות לתשלום כפול
ניתן לסמן אותן ללקוח להחזר / קיזוז
משפרת את אמינות הדוחות – לא נספור פעמיים תשלום שלא צריך


