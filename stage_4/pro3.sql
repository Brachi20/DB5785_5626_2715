CREATE OR REPLACE PROCEDURE create_full_payment_flow(
    p_description VARCHAR,
    p_amount NUMERIC(10,2),
    p_payment_method VARCHAR,
    p_recipient VARCHAR,
    p_issue_date DATE DEFAULT CURRENT_DATE
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_year INTEGER := EXTRACT(YEAR FROM p_issue_date)::INT;
    v_revenue_id INTEGER;
    v_payment_id INTEGER;
    v_invoice_id INTEGER;
BEGIN
    -- 1. יצירת הכנסה וקבלת ה-ID החדש
    INSERT INTO revenue (description, year)
    VALUES (p_description, v_year)
    RETURNING revenue_id INTO v_revenue_id;

    -- 2. יצירת תשלום וקבלת ה-ID החדש
    INSERT INTO payment (payment_method, payment_date, amount, revenue_id)
    VALUES (p_payment_method, p_issue_date, p_amount, v_revenue_id)
    RETURNING payment_id INTO v_payment_id;

    -- 3. יצירת חשבונית וקבלת ה-ID החדש
    INSERT INTO invoice (recipient, issue_date, payment_id, amount)
    VALUES (p_recipient, p_issue_date, v_payment_id, p_amount)
    RETURNING invoice_id INTO v_invoice_id;

    RAISE NOTICE 'תהליך הושלם: revenue_id = %, payment_id = %, invoice_id = %',
        v_revenue_id, v_payment_id, v_invoice_id;
END;
$$;
