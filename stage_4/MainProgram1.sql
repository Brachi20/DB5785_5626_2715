DO $$
DECLARE
    rec RECORD;
    arr_clients TEXT[] := ARRAY['יעקב כהן', 'רחל לוי', 'דוד ישראלי', 'חני רוזן', 'יוסי פרץ'];
    arr_sources TEXT[] := ARRAY['Credit Card', 'Cash', 'Direct Debit', 'Other'];
    arr_desc TEXT[] := ARRAY['נסיעה עירונית', 'קנס חניה', 'תרומה', 'פרסום', 'שירות פרטי'];
    arr_expenses TEXT[] := ARRAY[
        'Fuel', 'Maintenance', 'Rent', 'Equipment', 'Services',
        'Repair', 'Insurance', 'Travel', 'Hardware', 'Software',
        'Water', 'Electricity', 'Phone', 'Printing', 'Salary', 'Tax Payment'
    ];
    i INT;
    year INT;
    payment_amount NUMERIC;
    expense_amount NUMERIC;
    exp_type_id INT;
BEGIN
    -- שלב 1: הוספת תשלומים וחשבוניות
    FOR i IN 1..100 LOOP
        year := 2004 + (random() * 20)::INT; -- בין 2004 ל־2024
        payment_amount := 500 + random()*9500;
        CALL create_full_payment_flow(
            arr_desc[(random()*4 + 1)::INT],
            payment_amount,
            arr_sources[(random()*3 + 1)::INT],
            arr_clients[(random()*4 + 1)::INT],
            make_date(year, (random()*11 + 1)::INT, (random()*27 + 1)::INT)
        );
    END LOOP;

    -- שלב 2: הוספת הוצאות שונות כולל מס
    FOR i IN 1..100 LOOP
        year := 2004 + (random() * 20)::INT;
        expense_amount := 300 + random()*10000;
        exp_type_id := (random()*15 + 1)::INT;

        INSERT INTO expense (amount, status, due_date, description, year, type_id)
        VALUES (
            expense_amount,
            'Paid',
            make_date(year, (random()*11 + 1)::INT, (random()*27 + 1)::INT),
            'הוצאה רגילה',
            year,
            exp_type_id
        );
    END LOOP;

    -- שלב 3: עדכון כל דוחות המס
    FOR year IN 2004..2024 LOOP
        BEGIN
            CALL update_tax_report(year);
        EXCEPTION
            WHEN OTHERS THEN
                RAISE NOTICE 'לא ניתן לעדכן את השנה % - אולי התאריך טרם הגיע', year;
        END;
    END LOOP;

-- שלב 4: הדפסת סיכומים לכל השנים מ־2004 עד 2024
FOR year IN 2004..2024 LOOP
    FOR rec IN SELECT * FROM get_yearly_revenue_summary(year) LOOP
        RAISE NOTICE 'שנה: %, סה"כ הכנסות: %, סה"כ תשלומים: %', rec.year, rec.total_revenue, rec.num_payments;
    END LOOP;
END LOOP;

END $$;
