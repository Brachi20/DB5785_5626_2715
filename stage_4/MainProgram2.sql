DO $$
DECLARE
    rec RECORD;
    min_payment NUMERIC := 10000;
BEGIN
    CALL update_paid_invoices();
    RAISE NOTICE 'סטטוס חשבוניות עודכן בהתאם לסכום ששולם בפועל.';

    FOR rec IN
        SELECT * FROM get_top_clients_and_payment_source(min_payment)
    LOOP
        RAISE NOTICE 'לקוח: %, סה"כ תשלומים: ₪%, מספר תשלומים: %, מקור תשלום עיקרי: %',
            rec.recipient, rec.total_paid, rec.num_payments, rec.most_used_source;
    END LOOP;
END $$;