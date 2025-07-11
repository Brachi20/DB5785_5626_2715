CREATE OR REPLACE PROCEDURE update_paid_invoices()
LANGUAGE plpgsql
AS $$
DECLARE
    v_paid_id INTEGER;
    r_invoice RECORD;
BEGIN
    -- שליפת הקוד של הסטטוס "Paid"
    SELECT status_id INTO v_paid_id
    FROM invoicestatus
    WHERE status_name = 'Paid';

    IF v_paid_id IS NULL THEN
        RAISE EXCEPTION 'לא קיים סטטוס בשם Paid בטבלת invoicestatus';
    END IF;

    -- מעבר על כל החשבוניות שעוד לא סומנו כ"שולמה"
    FOR r_invoice IN
        SELECT i.invoice_id, i.amount, p.amount AS paid_amount
        FROM invoice i
        JOIN payment p ON i.payment_id = p.payment_id
        WHERE i.status_id IS DISTINCT FROM v_paid_id
    LOOP
        -- אם הסכום ששולם זהה לסכום החשבונית – נעדכן ל"Paid"
        IF r_invoice.amount = r_invoice.paid_amount THEN
            UPDATE invoice
            SET status_id = v_paid_id
            WHERE invoice_id = r_invoice.invoice_id;
        END IF;
    END LOOP;
END;
$$;
