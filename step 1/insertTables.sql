
-- TaxReport
INSERT INTO TaxReport VALUES (2022, 500000.00, 300000.00, 100000.00, 95000.00, '2022-12-31');
INSERT INTO TaxReport VALUES (2023, 600000.00, 350000.00, 120000.00, 118000.00, '2023-12-31');
INSERT INTO TaxReport VALUES (2024, 700000.00, 400000.00, 130000.00, 125000.00, '2024-12-31');

-- FinancialAudit
INSERT INTO FinancialAudit VALUES (1, 'John Doe', 'All clear', '2023-01-15');
INSERT INTO FinancialAudit VALUES (2, 'Jane Smith', 'Minor issues', '2023-06-20');
INSERT INTO FinancialAudit VALUES (3, 'Mike Green', 'Pending follow-up', '2024-02-10');

-- ExpenseTypes
INSERT INTO ExpenseTypes VALUES (1, 'Fuel');
INSERT INTO ExpenseTypes VALUES (2, 'Maintenance');
INSERT INTO ExpenseTypes VALUES (3, 'Salaries');

-- Expense
INSERT INTO Expense VALUES (101, 15000.00, 'Paid', '2023-02-10', 'Fuel refill', 2023, 1);
INSERT INTO Expense VALUES (102, 30000.00, 'Unpaid', '2023-03-15', 'Bus repair', 2023, 2);
INSERT INTO Expense VALUES (103, 50000.00, 'Paid', '2023-04-01', 'Monthly payroll', 2023, 3);

-- Revenue
INSERT INTO Revenue VALUES (201, 'Ticket Sales', 100000.00, '2023-01-01', 'January sales', 2023);
INSERT INTO Revenue VALUES (202, 'Ads', 20000.00, '2023-02-01', 'Bus ads revenue', 2023);
INSERT INTO Revenue VALUES (203, 'Ticket Sales', 120000.00, '2023-03-01', 'March sales', 2023);

-- AuditRecord
INSERT INTO AuditRecord VALUES (301, 'Valid', 201, 101, 1);
INSERT INTO AuditRecord VALUES (302, 'Discrepancy found', 202, 102, 2);
INSERT INTO AuditRecord VALUES (303, 'Reviewed', 203, 103, 3);

-- Payment
INSERT INTO Payment VALUES (401, 'Credit Card', '2023-01-05', 201);
INSERT INTO Payment VALUES (402, 'Cash', '2023-02-06', 202);
INSERT INTO Payment VALUES (403, 'Bank Transfer', '2023-03-07', 203);

-- Invoice
INSERT INTO Invoice VALUES (501, 'Customer A', 100000.00, '2023-01-06', 'Paid', 401);
INSERT INTO Invoice VALUES (502, 'Customer B', 20000.00, '2023-02-07', 'Paid', 402);
INSERT INTO Invoice VALUES (503, 'Customer C', 120000.00, '2023-03-08', 'Unpaid', 403);
