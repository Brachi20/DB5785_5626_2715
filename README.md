# 🧑‍💻 DB5785 - PostgreSQL and Docker Workshop 🗄️🐋

---
## 📎 Stage A Report – DBProject

### 👩‍💻 Submitters:

**Naomi Levy 342582715
& 
Brachi Tarkieltaub 325925626**

**Unit**: Finance Department
**System**: Accounting and Revenue Management System for a Transportation Company

---

## 📁 Table of Contents

Stage A – Database Design and Setup
1. Introduction  
2. ERD Diagram  
3. DSD Diagram  
4. Design Decisions  
5. Data Insertion Methods  
6. Database Backup and Restore  

Stage B – Queries and Constraints

7. SELECT Queries  
8. DELETE Queries  
9. UPDATE Queries  
 10. Constraints  
 11. Rollback & Commit

Stage C – Integration & Views  
• Backup and Restore  
• DSD and ERD Diagrams  
• Integration Decisions  
• Integrate.sql Description  
• Views.sql Description  
• View Queries and Screenshots  

---

## 📘 1. Introduction

This system manages financial data for a transportation company. It stores information such as revenues, expenses, audit records, invoices, and tax reports. The system allows accounting staff to track transactions, perform analysis, and generate reports efficiently.

Main features include:

* Revenue and payment tracking
* Recording financial audits
* Storing categorized expenses
* Invoice generation and linkage to payments

---

## 🧩 2. ERD Diagram

> ![ERD](images/erd/ERD.png)

 **[ERD.erdplus](stage_1/ERD.erdplus)**

---

## 🗱 3. DSD Diagram

> ![DSD](stage_1/DSD.png)

 **[DSD.erdplus](stage_1/DSD.erdplus)**


---

## 🧠 4. Design Decisions

* Years are constrained between 2000–2030 to ensure validity in tax reports.
* `ExpenseTypes` is limited to 15 defined categories to simplify reporting.
* Surrogate primary keys (integers) were used for most entities for efficiency.
* All foreign keys were explicitly enforced to ensure referential integrity.

---

## 📅 5. Data Insertion Methods

We used three different methods for populating the database:

### 📂 A. Mockaroo/csv

* Imported `.csv` files using `COPY` or `\copy` via pgAdmin.
* File: [Payment.csv](stage_1/mockarooFiles/csv)
* Folder: `stage_1/mockarooFiles/csv/Payment.csv`

### 🌐 B. Mockaroo/sql

* Used Mockaroo to simulate realistic financial data.
* Files included:
-[TaxReport.sql](stage_1/mockarooFiles/sql/TaxReport.sql)
-[Revenue.sql](stage_1/mockarooFiles/sql/Revenue.sql)
-[The rest of the tables](stage_1/mockarooFiles/sql/insert_all_rest_data.sql)

*Used Formulas in generating data on TaxReport Table:
> ![ERD](stage_1/mockarooFiles/sql/report_date.png)
> ![ERD](stage_1/mockarooFiles/sql/tax_amount.png)
> ![ERD](stage_1/mockarooFiles/sql/tax_paid.png)
> ![ERD](stage_1/mockarooFiles/sql/tax_year.png)


* Folders: `stage_1/mockarooFiles/sql`

### 🐍 C. Python Script (Programmatic Generation)

* Used Python (`faker`, `random`, `datetime`) to generate `INSERT` scripts.
* File: [insertTables.sql](../step%201/insertTables.sql)
* Folder: `step 1/Programing`

---

## 🛡️ 6. Database Backup and Restore

### 🔹 Backup

We used `pg_dump` inside the Docker container to export the database:

```bash
docker exec -t my_postgres pg_dump -U myuser -d mydatabase -F c -f /backup/backup_2025-05-15.backup
docker cp my_postgres:/backup/backup_2025-05-15.backup "D:/projects/DBProject/backups"
```



### 🔹 Restore

On another machine:

```bash
docker exec -it my_postgres_restore bash
psql -U postgres -c "CREATE DATABASE restored_db;"
pg_restore -U postgres -d restored_db /backup/backup_2025-05-15.backup
```

> ![Screenshot Backup](../images/screenshots/backup_success.png)
> ![Screenshot Restore](../images/screenshots/restore_success.png)

Backup file: [backup\_2025-05-15.backup](stage_1/backup_2025-05-15.backup)

---
📊 Stage B Report – Queries and Constraints

📌 7. SELECT Queries

📍 Query 1 – Monthly Average Purchases Per User

Description: Displays how many purchases each user made per month in the past year.
![Query 1 ](stage_2/Screenshots/select1.png)



📍 Query 2 – Products Never Sold

Description: Lists all products that were never part of any purchase.
![Query 1 ](stage_2/Screenshots/select2.png)



📍 Query 3 – Annual Income Summary

Description: Shows the total income per year based on product quantities and unit prices.
![Query 1 ](stage_2/Screenshots/select3.png)



📍 Query 4 – Users Who Spent Over 1000 NIS

Description: Lists users whose cumulative spending exceeds 1000 NIS.
![Query 1 ](stage_2/Screenshots/select4.png)



📍 Query 5 – Last Purchase Date Per User

Description: Retrieves the most recent purchase date for each user.
![Query 1 ](stage_2/Screenshots/select5.png)



📍 Query 6 – Number of Products Per Category

Description: Displays how many products exist in each category.
![Query 1 ](stage_2/Screenshots/select6.png)



📍 Query 7 – Low Stock Products

Description: Shows products with stock quantity less than 10.

![Query 1 ](stage_2/Screenshots/select7.1.png)


![Query 1 ](stage_2/Screenshots/select7.2.png)



📍 Query 8 – Inactive Users in the Last 6 Months

Description: Finds users who haven’t made a purchase in the last 6 months.
![Query 1 ](stage_2/Screenshots/select8.png)



🗑️ 8 DELETE Queries
🧹 Delete 1 – Remove Users Without Purchases

Description: Deletes users who never made a purchase.

📸 Before:

![Query 1 Screenshot](stage_2/Screenshots/delete1_before.png)


After Query Execution:

![Query 1 Screenshot](stage_2/Screenshots/delete1.png)



🧹 Delete 2 – Remove Unsold Products

Description: Deletes products that were never sold.

📸 Before:

![Query 2 Screenshot](stage_2/Screenshots/delete2_before.png)


After Query Execution:

![Query 2 Screenshot](stage_2/Screenshots/delete2.png)



🧹 Delete 3 – Remove Empty Categories

Description: Deletes categories that don’t contain any products.

📸 Before:

![Query 3 Screenshot](stage_2/Screenshots/delete3_before.png)


After Query Execution:

![Query 3 Screenshot](stage_2/Screenshots/delete3.png)



✏️ 9 UPDATE Queries
🧾 Update 1 – Increase Price by 5% for Popular Products

Description: Applies a price increase for products sold in high quantities.

Query Execution:

![Query 1 Screenshot](stage_2/Screenshots/update1.png)


📸 Before:

![Query 1 Screenshot](stage_2/Screenshots/update1_rollback.png)


After:

![Query 1 Screenshot](stage_2/Screenshots/update1_after.png)



🧾 Update 2 – Change User Address
Description: Updates a specific user’s address.

Query Execution:

![Query 2 Screenshot](stage_2/Screenshots/update2.png)


📸 Before:

![Query 2 Screenshot](stage_2/Screenshots/update2_rollback.png)


After:

![Query 2 Screenshot](stage_2/Screenshots/update2_after.png)



🧾 Update 3 – Set Stock to Zero for Unsold Products
Description: Changes stock to zero for products never sold.

Query Execution:

![Query 3 Screenshot](stage_2/Screenshots/update3.png)


📸 Before:

![Query 3 Screenshot](stage_2/Screenshots/update3_rollback.png)


After:

![Query 3 Screenshot](stage_2/Screenshots/update3_after.png)



🛠️ 10 Constraints
🔒 Constraint 1 – NOT NULL on total_expense in taxreport
Description: Prevents insertion of tax report entries without a total_expense value. Attempt to insert a row missing this value resulted in a NOT NULL violation.

📸 Query and Error Test:

![Query 1 Screenshot](stage_2/Screenshots/הפרת אילוץ 1.png)



🔒 Constraint 2 – PRIMARY KEY on invoice_id in invoice
Description: Prevents duplicate invoice_id values. An attempt to insert an invoice with an existing ID caused a primary key violation and an invalid column error.

📸 Query and Error Test:

![Query 2 Screenshot](stage_2/Screenshots/הפרת אילוץ 2.png)



🔒 Constraint 3 – NOT NULL on status in expense
Description: Prevents inserting an expense without a status. An attempt to insert a NULL value in this field caused a NOT NULL constraint violation.

📸 Query and Insertion Test:

![Query 3 Screenshot](stage_2/Screenshots/הפרת אילוץ 3.png)



🔄 11. Rollback & Commit
📄 **SQL File**: [stage_2/RollbackCommit.sql](stage_2/RollbackCommit.sql)


📉 Rollback Test
A record was updated and then reverted using the ROLLBACK command. This confirmed that the database returned to its original state as expected.

📈 Commit Test
A record was updated and the change was saved using the COMMIT command. Verifying the table showed the data remained changed after the commit.

📂 All files used in this stage are located in the folder: stage_2/

Queries.sql, Constraints.sql, RollbackCommit.sql, backup2

---


# 📘 Stage C Report – Integration & Views
**Integration with:** Ticketing & Booking Module

---

## 📁 Table of Contents

- Backup and Restore  
- DSD and ERD Diagrams  
- Integration Decisions  
- Integrate.sql Description  
- Views.sql Description  
- View Queries and Screenshots  

---

## 🧠 Introduction

In this stage, we integrated our **Finance & Accounting** database with another project’s **Ticketing & Booking** system. The goal was to create a unified schema to connect financial payments with ticket purchases, allowing for cross-domain analysis and reporting.

---

## 🗃️ Backup and Restore

We restored the Ticketing system using `pg_restore`, extracted its structure, and imported key tables (`Ticket`, `Passenger`) into our main finance database.

📷 *Add screenshots of:*
- `backup2` (original)
- `backup3` (post-integration)

---

## 📐 DSD and ERD Diagrams

### 📌 DSD – Ticketing System  
📷 *Insert screenshot of DSD from ERDPlus (Ticket & Passenger)*

### 📌 ERD – Ticketing System  
📷 *Insert screenshot of ERD from reverse engineering*

### 📌 ERD – Integrated (Merged)  
📷 *Insert screenshot of ERD with Ticket ↔ Payment and Ticket ↔ Passenger*

---

## 🧩 Integration Decisions

1. **Linking Ticket to Payment**  
   We added `payment_id` as a foreign key in the `ticket` table, creating a Many-to-One relationship: multiple tickets may be linked to a single payment.

2. **Preserving Table Structures**  
   We chose not to merge or recreate tables. Instead, we used `ALTER TABLE` to modify existing ones and enforce foreign keys.

3. **Data Reuse**  
   `Ticket` and `Passenger` were imported using `COPY FROM` based on a `.csv` export from the partner project. All relevant data was preserved.

---

## 🛠️ Integrate.sql – Schema Modification

```sql
-- Add payment_id to ticket table
ALTER TABLE ticket
ADD COLUMN payment_id INTEGER;

-- Link ticket to payment based on matching amount and date
UPDATE ticket t
SET payment_id = p.payment_id
FROM payment p
WHERE 
    t.price = p.amount
    AND t.purchasedate = p.payment_date;

-- Create FK from ticket to payment
ALTER TABLE ticket
ADD CONSTRAINT fk_ticket_payment
FOREIGN KEY (payment_id)
REFERENCES payment(payment_id);

-- Create FK from ticket to passenger
ALTER TABLE ticket
ADD CONSTRAINT fk_ticket_passenger
FOREIGN KEY (passengerid)
REFERENCES passenger(passengerid);
```

📷 *Optional: Add screenshot from pgAdmin Query Tool showing ALTER TABLE execution*

---

## 👁️ Views.sql – Views and Queries

### 🔹 View 1: `view_payment_summary`

**Description:**  
Joins payment and ticket tables to show which tickets were paid in which transaction.

```sql
CREATE OR REPLACE VIEW view_payment_summary AS
SELECT 
    p.payment_id,
    p.payment_method,
    p.payment_date,
    p.amount AS payment_amount,
    t.ticketid,
    t.price AS ticket_price,
    t.purchasedate
FROM payment p
JOIN ticket t ON p.payment_id = t.payment_id;
```

📷 *Add screenshot of:*  
`SELECT * FROM view_payment_summary LIMIT 10;`

---

#### 🧮 Query A: Credit card payments over 100 NIS
```sql
SELECT * 
FROM view_payment_summary
WHERE payment_method = 'Credit' AND ticket_price > 100;
```
📷 *Insert screenshot of result (up to 5 rows)*

#### 🧾 Query B: Total income by date
```sql
SELECT payment_date, SUM(ticket_price) AS total_income
FROM view_payment_summary
GROUP BY payment_date
ORDER BY payment_date;
```
📷 *Insert screenshot of result*

---

### 🔹 View 2: `view_passenger_tickets`

**Description:**  
Displays passengers, their purchased tickets, and the payments linked to them.

```sql
CREATE OR REPLACE VIEW view_passenger_tickets AS
SELECT 
    ps.passengerid,
    ps.fullname,
    ps.email,
    t.ticketid,
    t.purchasedate,
    t.price,
    p.payment_method,
    p.payment_date
FROM passenger ps
JOIN ticket t ON ps.passengerid = t.passengerid
LEFT JOIN payment p ON t.payment_id = p.payment_id;
```

📷 *Add screenshot of:*  
`SELECT * FROM view_passenger_tickets LIMIT 10;`

---

#### 🧮 Query A: Passengers who paid over 150 NIS
```sql
SELECT fullname, email, ticketid, price
FROM view_passenger_tickets
WHERE price > 150;
```
📷 *Insert screenshot of result*

#### 🧾 Query B: Ticket count by payment method
```sql
SELECT payment_method, COUNT(*) AS num_tickets
FROM view_passenger_tickets
GROUP BY payment_method;
```
📷 *Insert screenshot of result*

---

## 🗃️ Files in `stage_3/` Git Folder

- `DSD_new.png`
- `ERD_new.png`
- `ERD_merged.png`
- `DSD_merged.png`
- `Integrate.sql`
- `Views.sql`
- `backup3`
- `README.md` (this file)


## Workshop Outcomes

By the end of this workshop, you will:

- Understand how to set up PostgreSQL and pgAdmin using Docker.
- Learn how to use Docker volumes to persist database data.
- Gain hands-on experience with basic and advanced database operations.

----
<a name="workshop-id"></a>
## 📝 Workshop Files & Scripts (to be modified by the students) 🧑‍🎓 

This workshop introduces key database concepts and provides hands-on practice in a controlled, containerized environment using PostgreSQL within Docker.

### Key Concepts Covered:

1. **Entity-Relationship Diagram (ERD)**:
   - Designed an ERD to model relationships and entities for the database structure.
   - Focused on normalizing the database and ensuring scalability.

   **[Add ERD Snapshot Here]**
   
 images/erd/ERD.png  
> ![add_image_to readme_with_relative_path](images/erd/ERD.png)
  
   *(Upload or link to the ERD image or file)*

3. **Creating Tables**:
   - Translated the ERD into actual tables, defining columns, data types, primary keys, and foreign keys.
   - Utilized SQL commands for table creation.

   **[Add Table Creation Code Here](stage_1/createTables.sql)**
   *(Provide or link to the SQL code used to create the tables)*

4. **Generating Sample Data**:
   - Generated sample data to simulate real-world scenarios using **SQL Insert Statements**.
   - Used scripts to automate bulk data insertion for large datasets.

   **[Add Sample Data Insert Script Here](stage_1/insertTables.sql)**
   *(Upload or link to the sample data insert scripts)*

5. **Writing SQL Queries**:
   - Practiced writing **SELECT**, **JOIN**, **GROUP BY**, and **ORDER BY** queries.
   - Learned best practices for querying data efficiently, including indexing and optimization techniques.

   **[Add Example SQL Query Here]**
   *(Provide or link to example SQL queries)*

6. **Stored Procedures and Functions**:
   - Created reusable **stored procedures** and **functions** to handle common database tasks.
   - Used SQL to manage repetitive operations and improve performance.

   **[Add Stored Procedures/Function Code Here]**
   *(Upload or link to SQL code for stored procedures and functions)*

7. **Views**:
   - Created **views** to simplify complex queries and provide data abstraction.
   - Focused on security by limiting user access to certain columns or rows.

   **[Add View Code Here]**
   *(Provide or link to the SQL code for views)*

---

## 💡 Workshop Outcomes

By the end of this workshop, we were able to:

- Design and create a database schema based on an ERD.
- Perform CRUD (Create, Read, Update, Delete) operations with SQL.
- Write complex queries using joins, aggregations, and subqueries.
- Create and use stored functions and procedures for automation and performance.
- Work effectively with PostgreSQL inside a Docker container for development and testing.

---

## Additional Tasks for Students

### 1. **Database Backup and Restore**
   - Use `pg_dump` to back up your database and `pg_restore` or `psql` to restore it.

   ```bash
   # Backup the database
   pg_dump -U postgres -d your_database_name -f backup.sql

   # Restore the database
   psql -U postgres -d your_database_name -f backup.sql
   ```

### 2. **Indexing and Query Optimization**
   - Create indexes on frequently queried columns and analyze query performance.

   ```sql
   -- Create an index
   CREATE INDEX idx_your_column ON your_table(your_column);

   -- Analyze query performance
   EXPLAIN ANALYZE SELECT * FROM your_table WHERE your_column = 'value';
   ```

### 3. **User Roles and Permissions**
   - Create user roles and assign permissions to database objects.

   ```sql
   -- Create a user role
   CREATE ROLE read_only WITH LOGIN PASSWORD 'password';

   -- Grant read-only access to a table
   GRANT SELECT ON your_table TO read_only;
   ```

### 4. **Advanced SQL Queries**
   - Write advanced SQL queries using window functions, recursive queries, and CTEs.

   ```sql
   -- Example: Using a window function
   SELECT id, name, salary, ROW_NUMBER() OVER (ORDER BY salary DESC) AS rank
   FROM employees;
   ```

### 6. **Database Monitoring**
   - Use PostgreSQL's built-in tools to monitor database performance.

   ```sql
   -- View active queries
   SELECT * FROM pg_stat_activity;

   -- Analyze table statistics
   SELECT * FROM pg_stat_user_tables;
   ```

### 7. **Using Extensions**
   - Install and use PostgreSQL extensions like `pgcrypto` or `postgis`.

   ```sql
   -- Install the pgcrypto extension
   CREATE EXTENSION pgcrypto;

   -- Example: Encrypt data
   INSERT INTO users (username, password) VALUES ('alice', crypt('password', gen_salt('bf')));
   ```

### 8. **Automating Tasks with Cron Jobs**
   - Automate database maintenance tasks (e.g., backups) using cron jobs.

   ```bash
   # Example: Schedule a daily backup at 2 AM
   0 2 * * * pg_dump -U postgres -d your_database_name -f /backups/backup_$(date +\%F).sql
   ```

### 9. **Database Testing**
   - Write unit tests for your database using `pgTAP`.

   ```sql
   -- Example: Test if a table exists
   SELECT * FROM tap.plan(1);
   SELECT tap.has_table('public', 'your_table', 'Table should exist');
   SELECT * FROM tap.finish();
   ```

---

## Troubleshooting

### 1. **Connection Issues**
   - **Problem**: Unable to connect to the PostgreSQL or pgAdmin container.
   - **Solution**:  
     - Ensure both the PostgreSQL and pgAdmin containers are running. You can check their status by running:
       ```bash
       docker ps
       ```
     - Verify that you have the correct container names. If you are unsure of the names, you can list all containers (running and stopped) with:
       ```bash
       docker ps -a
       ```
     - Ensure that the correct ports are mapped (e.g., `5432:5432` for PostgreSQL and `5050:80` for pgAdmin).
     - Verify that the `postgres` container's name is used in pgAdmin's connection settings.
     - If using `localhost` and experiencing connection issues, try using the container name instead (e.g., `postgres`).
     - Check the logs for any error messages:
       ```bash
       docker logs postgres
       docker logs pgadmin
       ```
     - If you are still having trouble, try restarting the containers:
       ```bash
       docker restart postgres
       docker restart pgadmin
       ```

### 2. **Forgot Password**
   - **Problem**: You've forgotten the password for pgAdmin or PostgreSQL.
   - **Solution**:
     - For pgAdmin:
       1. Stop the pgAdmin container:
          ```bash
          docker stop pgadmin
          ```
       2. Restart the container with a new password:
          ```bash
          docker run --name pgadmin -d -p 5050:80 -e PGADMIN_DEFAULT_EMAIL=admin@example.com -e PGADMIN_DEFAULT_PASSWORD=new_password dpage/pgadmin4:latest
          ```
     - For PostgreSQL:
       1. If you've forgotten the `POSTGRES_PASSWORD` for PostgreSQL, you’ll need to reset it. First, stop the container:
          ```bash
          docker stop postgres
          ```
       2. Restart it with a new password:
          ```bash
          docker run --name postgres -e POSTGRES_PASSWORD=new_password -d -p 5432:5432 -v postgres_data:/var/lib/postgresql/data postgres
          ```

### 3. **Port Conflicts**
   - **Problem**: Port is already in use on the host machine (e.g., port 5432 or 5050).
   - **Solution**:  
     - If a port conflict occurs (for example, PostgreSQL's default port `5432` is already in use), you can map a different host port to the container's port by changing the `-p` flag:
       ```bash
       docker run --name postgres -e POSTGRES_PASSWORD=your_password -d -p 5433:5432 -v postgres_data:/var/lib/postgresql/data postgres
       ```
       This would map PostgreSQL’s internal `5432` to the host’s `5433` port.
     - Similarly, for pgAdmin, you can use a different port:
       ```bash
       docker run --name pgadmin -d -p 5051:80 -e PGADMIN_DEFAULT_EMAIL=admin@example.com -e PGADMIN_DEFAULT_PASSWORD=admin dpage/pgadmin4:latest
       ```

### 4. **Unable to Access pgAdmin in Browser**
   - **Problem**: You cannot access pgAdmin through `http://localhost:5050` (or other port you have set).
   - **Solution**:
     - Ensure the pgAdmin container is running:
       ```bash
       docker ps
       ```
     - Double-check that the port mapping is correct and no firewall is blocking the port.
     - If using a non-default port (e.g., `5051` instead of `5050`), ensure you access it by visiting `http://localhost:5051` instead.

### 5. **Data Persistence Issue**
   - **Problem**: After stopping or removing the PostgreSQL container, the data is lost.
   - **Solution**:
     - Ensure that you are using a Docker volume for data persistence. When starting the container, use the `-v` flag to map the volume:
       ```bash
       docker run --name postgres -e POSTGRES_PASSWORD=your_password -d -p 5432:5432 -v postgres_data:/var/lib/postgresql/data postgres
       ```
     - To inspect or back up the volume:
       ```bash
       docker volume inspect postgres_data
       ```

### 6. **Accessing pgAdmin with Docker Network**
   - **Problem**: If you are trying to connect from pgAdmin to PostgreSQL and the connection is unsuccessful.
   - **Solution**:
     - Make sure both containers (PostgreSQL and pgAdmin) are on the same Docker network:
       ```bash
       docker network create pg_network
       docker run --name postgres --network pg_network -e POSTGRES_PASSWORD=your_password -d -p 5432:5432 -v postgres_data:/var/lib/postgresql/data postgres
       docker run --name pgadmin --network pg_network -d -p 5050:80 -e PGADMIN_DEFAULT_EMAIL=admin@example.com -e PGADMIN_DEFAULT_PASSWORD=admin dpage/pgadmin4:latest
       ```
     - This ensures that both containers can communicate over the internal network created by Docker.

---


## 👇 Resources

- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [pgAdmin Documentation](https://www.pgadmin.org/docs/)
- [Docker Documentation](https://docs.docker.com/)

