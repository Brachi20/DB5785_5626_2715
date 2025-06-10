בטבלת הדו"ח מס:
אחוז מס מאותחל לברירת מחדל 18
קיימים שדות אפשריים ריקים
וכן שדות  לא אפשריים ריקים
סכום המ"ס יהיה מחושב לפי ערכים אחרים - נוסחא

-- Table: public.taxreport

-- DROP TABLE IF EXISTS public.taxreport;

CREATE TABLE IF NOT EXISTS public.taxreport
(
    tax_year integer NOT NULL,
    total_revenue numeric(10,2),
    total_expense numeric(10,2),
    tax_paid numeric(10,2),
    report_date date,
    discount_percent numeric(5,2) NOT NULL DEFAULT 18,
    tax_amount numeric(10,2) GENERATED ALWAYS AS (round((total_revenue * (discount_percent / 100.0)), 2)) STORED,
    CONSTRAINT taxreport_pkey PRIMARY KEY (tax_year),
    CONSTRAINT chk_report_date_window CHECK (report_date IS NULL OR report_date >= make_date(tax_year + 1, 1, 1) AND report_date < make_date(tax_year + 1, 3, 1))
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.taxreport
    OWNER to myuser;



בטבלת קבלה:
תאריך הנפקה לא יכול להיות בעתיד

ALTER TABLE Invoice
ADD CONSTRAINT chk_invoice_issue_date
CHECK (issue_date <= CURRENT_DATE);

-- Table: public.invoice

-- DROP TABLE IF EXISTS public.invoice;

CREATE TABLE IF NOT EXISTS public.invoice
(
    invoice_id integer NOT NULL,
    recipient character varying(50) COLLATE pg_catalog."default" NOT NULL,
    issue_date date NOT NULL,
    payment_id integer NOT NULL,
    amount numeric(10,2),
    status_id integer,
    CONSTRAINT invoice_pkey PRIMARY KEY (invoice_id),
    CONSTRAINT fk_invoice_status FOREIGN KEY (status_id)
        REFERENCES public.invoicestatus (status_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT invoice_payment_id_fkey FOREIGN KEY (payment_id)
        REFERENCES public.payment (payment_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT chk_invoice_issue_date CHECK (issue_date <= CURRENT_DATE)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.invoice
    OWNER to myuser;



בטבלת הוצאה:
מוודאים שסכום ההוצאה חיובי 
ALTER TABLE Expense
ADD CONSTRAINT chk_expense_positive
CHECK (amount > 0);

-- Table: public.expense

-- DROP TABLE IF EXISTS public.expense;

CREATE TABLE IF NOT EXISTS public.expense
(
    expense_id integer NOT NULL,
    amount numeric(10,2) NOT NULL,
    status character varying(20) COLLATE pg_catalog."default" NOT NULL,
    due_date date NOT NULL,
    description character varying(100) COLLATE pg_catalog."default" NOT NULL,
    year integer NOT NULL,
    type_id integer NOT NULL,
    CONSTRAINT expense_pkey PRIMARY KEY (expense_id),
    CONSTRAINT expense_type_id_fkey FOREIGN KEY (type_id)
        REFERENCES public.expensetypes (type_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT expense_year_fkey FOREIGN KEY (year)
        REFERENCES public.taxreport (tax_year) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT chk_expense_positive CHECK (amount > 0::numeric)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.expense
    OWNER to myuser;
