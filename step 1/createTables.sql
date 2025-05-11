
CREATE TABLE TaxReport (
  tax_year INT PRIMARY KEY,
  total_revenue NUMERIC(10,2) NOT NULL,
  total_expense NUMERIC(10,2) NOT NULL,
  tax_amount NUMERIC(10,2) NOT NULL,
  tax_paid NUMERIC(10,2) NOT NULL,
  report_date DATE NOT NULL
);

CREATE TABLE FinancialAudit (
  audit_id INT PRIMARY KEY,
  auditor_name VARCHAR(50) NOT NULL,
  summary VARCHAR(100) NOT NULL,
  audit_date DATE NOT NULL
);

CREATE TABLE ExpenseTypes (
  type_id INT PRIMARY KEY,
  description VARCHAR(30) NOT NULL
);

CREATE TABLE Expense (
  expense_id INT PRIMARY KEY,
  amount NUMERIC(10,2) NOT NULL,
  status VARCHAR(20) NOT NULL,
  due_date DATE NOT NULL,
  description VARCHAR(100) NOT NULL,
  year INT NOT NULL,
  type_id INT NOT NULL,
  FOREIGN KEY (year) REFERENCES TaxReport(tax_year),
  FOREIGN KEY (type_id) REFERENCES ExpenseTypes(type_id)
);

CREATE TABLE Revenue (
  revenue_id INT PRIMARY KEY,
  source VARCHAR(50) NOT NULL,
  amount NUMERIC(10,2) NOT NULL,
  revenue_date DATE NOT NULL,
  description VARCHAR(100) NOT NULL,
  year INT NOT NULL,
  FOREIGN KEY (year) REFERENCES TaxReport(tax_year)
);

CREATE TABLE AuditRecord (
  record_id INT PRIMARY KEY,
  findings VARCHAR(100) NOT NULL,
  revenue_id INT NOT NULL,
  expense_id INT NOT NULL,
  audit_id INT NOT NULL,
  FOREIGN KEY (revenue_id) REFERENCES Revenue(revenue_id),
  FOREIGN KEY (expense_id) REFERENCES Expense(expense_id),
  FOREIGN KEY (audit_id) REFERENCES FinancialAudit(audit_id)
);

CREATE TABLE Payment (
  payment_id INT PRIMARY KEY,
  payment_method VARCHAR(30) NOT NULL,
  payment_date DATE NOT NULL,
  revenue_id INT NOT NULL,
  FOREIGN KEY (revenue_id) REFERENCES Revenue(revenue_id)
);

CREATE TABLE Invoice (
  invoice_id INT PRIMARY KEY,
  recipient VARCHAR(50) NOT NULL,
  amount NUMERIC(10,2) NOT NULL,
  issue_date DATE NOT NULL,
  status VARCHAR(20) NOT NULL,
  payment_id INT NOT NULL,
  FOREIGN KEY (payment_id) REFERENCES Payment(payment_id)
);
