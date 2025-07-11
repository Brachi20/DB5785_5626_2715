CREATE OR REPLACE FUNCTION update_tax_paid_on_tax_expense()
RETURNS TRIGGER AS
$$
DECLARE
    v_type_name TEXT;
BEGIN
    -- נוודא שסוג ההוצאה הוא באמת "Tax payment"
    SELECT expense_type INTO v_type_name
    FROM expensetypes
    WHERE type_id = NEW.type_id;

    IF v_type_name = 'Tax Payment' THEN
        UPDATE taxreport
        SET tax_paid = COALESCE(tax_paid, 0) + NEW.amount
        WHERE tax_year = NEW.year;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
