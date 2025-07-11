CREATE OR REPLACE FUNCTION get_top_clients_and_payment_source(p_min_total NUMERIC)
RETURNS TABLE (
    recipient TEXT,
    total_paid NUMERIC,
    num_payments INTEGER,
    most_used_source TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    WITH invoice_payment AS (
        SELECT
            i.recipient::TEXT AS inv_recipient,
            ps.source_name::TEXT AS source_name,
            p.amount
        FROM invoice i
        JOIN payment p ON i.payment_id = p.payment_id
        JOIN paymentsource ps ON p.source_id = ps.source_id
    ),
    total_by_recipient AS (
        SELECT
            inv_recipient,
            SUM(amount) AS total_paid,
            COUNT(*)::INTEGER AS num_payments
        FROM invoice_payment
        GROUP BY inv_recipient
        HAVING SUM(amount) > p_min_total
    ),
    usage_by_source AS (
        SELECT
            ip.inv_recipient,
            ip.source_name,
            COUNT(*) AS usage_count,
            ROW_NUMBER() OVER (
                PARTITION BY ip.inv_recipient
                ORDER BY COUNT(*) DESC
            ) AS rn
        FROM invoice_payment ip
        JOIN total_by_recipient tbr ON ip.inv_recipient = tbr.inv_recipient
        GROUP BY ip.inv_recipient, ip.source_name
    )
    SELECT
        tbr.inv_recipient,
        tbr.total_paid,
        tbr.num_payments,
        ubs.source_name AS most_used_source
    FROM total_by_recipient tbr
    JOIN usage_by_source ubs ON tbr.inv_recipient = ubs.inv_recipient AND ubs.rn = 1;
END;
$$;
