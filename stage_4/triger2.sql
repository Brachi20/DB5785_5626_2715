CREATE OR REPLACE FUNCTION trigger_high_expense_audit()
RETURNS TRIGGER AS $$
DECLARE
    v_audit_id INTEGER;
BEGIN
    -- שלב 1: בדוק אם כבר קיימת ביקורת להיום
    SELECT audit_id INTO v_audit_id
    FROM financialaudit
    WHERE audit_date = CURRENT_DATE;

    -- אם אין – צור אחת
    IF v_audit_id IS NULL THEN
        INSERT INTO financialaudit (auditor_name, summary, audit_date)
        VALUES ('Auto System', 'ביקורת אוטומטית על הוצאות חריגות', CURRENT_DATE)
        RETURNING audit_id INTO v_audit_id;
    END IF;

    -- שלב 2: צור auditrecord חדש עם הממצא
    INSERT INTO auditrecord (
        findings, revenue_id, expense_id, audit_id
    )
    VALUES (
        'הוצאה חריגה מעל 10,000 ₪',
        1, -- הכנסה פיקטיבית (נניח שתשמר תמיד)
        NEW.expense_id,
        v_audit_id
    );

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
