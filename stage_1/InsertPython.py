from faker import Faker
import random
from datetime import datetime
fake = Faker()

def esc(text):
    return text.replace("'", "''")

with open("pythonGeneratedInserts.sql", "w", encoding="utf-8") as f:
    for i in range(1, 401):
        # FinancialAudit
        f.write(f"INSERT INTO FinancialAudit (audit_id, auditor_name, summary, audit_date) VALUES ({i}, '{esc(fake.name())}', '{esc(fake.sentence())}', '{fake.date()}');\n")

        # ExpenseTypes
        f.write(f"INSERT INTO ExpenseTypes (type_id, description) VALUES ({i}, '{esc(fake.word().capitalize())}');\n")

        # Expense
        amount = round(random.uniform(100, 5000), 2)
        status = random.choice(['Paid', 'Unpaid', 'Pending'])
        due_date = fake.date_between(start_date='-2y', end_date='today')
        description = esc(fake.sentence())
        year = random.choice([2022, 2023, 2024])
        type_id = random.randint(1, 400)
        f.write(f"INSERT INTO Expense (expense_id, amount, status, due_date, description, year, type_id) VALUES ({i}, {amount}, '{status}', '{due_date}', '{description}', {year}, {type_id});\n")

        # Invoice
        recipient = esc(fake.name())
        invoice_amount = round(random.uniform(100, 10000), 2)
        issue_date = fake.date_between(start_date='-2y', end_date='today')
        invoice_status = random.choice(['Paid', 'Unpaid'])
        payment_id = random.randint(1, 400)
        f.write(f"INSERT INTO Invoice (invoice_id, recipient, amount, issue_date, status, payment_id) VALUES ({i}, '{recipient}', {invoice_amount}, '{issue_date}', '{invoice_status}', {payment_id});\n")

        # AuditRecord
        findings = esc(fake.text(max_nb_chars=50))
        revenue_id = random.randint(1, 400)
        expense_id = random.randint(1, 400)
        audit_id = random.randint(1, 400)
        f.write(f"INSERT INTO AuditRecord (record_id, findings, revenue_id, expense_id, audit_id) VALUES ({i}, '{findings}', {revenue_id}, {expense_id}, {audit_id});\n")
