-- ✅ Reset revenue_id sequence
SELECT setval(
  pg_get_serial_sequence('revenue', 'revenue_id'),
  COALESCE((SELECT MAX(revenue_id) FROM revenue), 0)
);

-- ✅ Reset payment_id sequence
SELECT setval(
  pg_get_serial_sequence('payment', 'payment_id'),
  COALESCE((SELECT MAX(payment_id) FROM payment), 0)
);

-- ✅ Reset invoice_id sequence
SELECT setval(
  pg_get_serial_sequence('invoice', 'invoice_id'),
  COALESCE((SELECT MAX(invoice_id) FROM invoice), 0)
);

-- ✅ Reset expense_id sequence
SELECT setval(
  pg_get_serial_sequence('expense', 'expense_id'),
  COALESCE((SELECT MAX(expense_id) FROM expense), 0)
);

-- ✅ Reset audit_id sequence (אם שייך ל-audit או auditrecord)
SELECT setval(
  pg_get_serial_sequence('financialaudit', 'audit_id'),
  COALESCE((SELECT MAX(audit_id) FROM financialaudit), 0)
);

-- ✅ Reset type_id sequence (expensetypes)
SELECT setval(
  pg_get_serial_sequence('expensetypes', 'type_id'),
  COALESCE((SELECT MAX(type_id) FROM expensetypes), 0)
);

-- ✅ Reset status_id sequence (invoicestatus)
SELECT setval(
  pg_get_serial_sequence('invoicestatus', 'status_id'),
  COALESCE((SELECT MAX(status_id) FROM invoicestatus), 0)
);

-- ✅ Reset source_id sequence (paymentsource)
SELECT setval(
  pg_get_serial_sequence('paymentsource', 'source_id'),
  COALESCE((SELECT MAX(source_id) FROM paymentsource), 0)
);

-- ✅ Reset record_id sequence (auditrecord)
SELECT setval(
  pg_get_serial_sequence('auditrecord', 'record_id'),
  COALESCE((SELECT MAX(record_id) FROM auditrecord), 0)
);
