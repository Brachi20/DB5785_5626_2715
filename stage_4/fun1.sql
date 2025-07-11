CREATE OR REPLACE FUNCTION get_yearly_revenue_summary(p_year INTEGER)
RETURNS TABLE (
    year INTEGER,
    total_revenue NUMERIC(10,2),
    num_payments INTEGER
) AS
$$
DECLARE
    v_total_revenue NUMERIC(10,2);
    v_num_payments INTEGER;
BEGIN
    -- שימוש באליאס כדי למנוע בלבול בשם
    SELECT COALESCE(SUM(tr.total_revenue), 0)
    INTO v_total_revenue
    FROM taxreport tr
    WHERE tr.tax_year = p_year;

    SELECT COUNT(*) INTO v_num_payments
    FROM payment P
   -- JOIN revenue R ON P.revenue_id = R.revenue_id
    --WHERE R.year = p_year;

    IF v_total_revenue = 0 AND v_num_payments = 0 THEN
        RAISE EXCEPTION 'לא נמצאו נתונים לשנה %', p_year;
    END IF;

    RETURN QUERY SELECT p_year, v_total_revenue, v_num_payments;
END;
$$ LANGUAGE plpgsql;
