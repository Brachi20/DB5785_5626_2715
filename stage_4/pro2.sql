CREATE OR REPLACE PROCEDURE update_tax_report(
    p_year INTEGER,
    p_discount_percent NUMERIC(5,2) DEFAULT 18
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_total_revenue NUMERIC(10,2);
    v_total_expense NUMERIC(10,2);
    v_tax_paid NUMERIC(10,2);
    v_allowed_date DATE := make_date(p_year + 1, 1, 1);
BEGIN
    -- לא מאפשרים לעדכן לפני תחילת השנה הבאה
    IF CURRENT_DATE < v_allowed_date THEN
        RAISE EXCEPTION 'לא ניתן לעדכן דוח מס לשנת % לפני תאריך %', p_year, v_allowed_date;
    END IF;

    -- בדיקה אם הדוח קיים
    IF NOT EXISTS (
        SELECT 1 FROM taxreport WHERE tax_year = p_year
    ) THEN
        RAISE EXCEPTION 'אין דוח קיים לשנת % לעדכון', p_year;
    END IF;

    -- חישוב הכנסות
    SELECT COALESCE(SUM(p.amount), 0)
    INTO v_total_revenue
    FROM payment p
    JOIN revenue r ON p.revenue_id = r.revenue_id
    WHERE r.year = p_year;

    -- חישוב הוצאות
    SELECT COALESCE(SUM(e.amount), 0)
    INTO v_total_expense
    FROM expense e
    WHERE e.year = p_year;

    -- חישוב סכום המס ששולם בפועל לפי הוצאות מסוג Tax Payment
    SELECT COALESCE(SUM(e.amount), 0)
    INTO v_tax_paid
    FROM expense e
    JOIN expensetypes t ON e.type_id = t.type_id
    WHERE lower(t.expense_type) = 'tax payment'
      AND e.year = p_year;

    -- עדכון שורת הדוח
    UPDATE taxreport
    SET 
        total_revenue = v_total_revenue,
        total_expense = v_total_expense,
        tax_paid = v_tax_paid,
        discount_percent = p_discount_percent,
        report_date = make_date(p_year + 1, 2, 1)
    WHERE tax_year = p_year;

    RAISE NOTICE 'דוח מס לשנת % עודכן בהצלחה. tax_paid = %', p_year, v_tax_paid;
END;
$$;
