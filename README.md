# Order Delivery Performance & SLA Analysis

**Tools: Excel · SQL Server 2014 · SSMS**

> An end-to-end delivery analytics project built on the Olist Brazilian e-commerce dataset.
> Covers data cleaning in Excel, SQL Server loading, validation, and KPI analysis
> for delivery SLA performance, customer geography, and seller contribution.

---

## Table of Contents

- [Business Problem](#business-problem)
- [Project Architecture](#project-architecture)
- [Dataset](#dataset)
- [Data Model](#data-model)
- [Tools and Workflow](#tools-and-workflow)
- [SQL Analysis — KPIs Covered](#sql-analysis--kpis-covered)
- [Key Findings](#key-findings)
- [Project Structure](#project-structure)
- [How to Reproduce](#how-to-reproduce)
- [Author](#author)

---

## Business Problem

E-commerce and logistics operations depend on delivery performance and fulfillment
efficiency. Business teams need clear visibility into:

- How many orders were successfully delivered?
- How many deliveries were on time vs late?
- Which customer cities generate the highest order volumes?
- Which cities have the worst late delivery rates?
- Which sellers contribute the most revenue?
- How do freight values vary across states?

This project builds a structured SQL-based analytics workflow to answer all of
these questions using real transaction data from Olist — a Brazilian e-commerce
marketplace.

---

## Project Architecture

```
Raw CSV Files (Kaggle)
        │
        ▼
  Excel Cleaning
  - delivery logic columns added
  - encoding issues fixed
  - nulls reviewed and documented
        │
        ▼
  SQL Server — BULK INSERT
  - 4 tables created
  - cleaned CSVs loaded
  - row counts verified
        │
        ▼
  SQL Validation
  - join integrity checks
  - null checks
  - delivery days sanity check
        │
        ▼
  SQL KPI Analysis
  - 15 business queries
  - master view created
```

---

## Dataset

**Source:** Olist E-Commerce Public Dataset
**Link:** https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce
**Period:** 2016 – 2018
**Currency:** Brazilian Real (BRL)

| Table | Rows | Description |
|---|---|---|
| orders | 99,441 | Order timeline, status, delivery dates |
| customers | 99,441 | Customer city and state |
| order_items | 112,650 | Seller, product, price, freight value |
| sellers | 3,095 | Seller city and state |

---

## Data Model

```
customers ──────────── orders ──────────── order_items
customer_id (PK)       order_id (PK)       order_id (FK)
customer_city          customer_id (FK)     seller_id (FK)
customer_state         order_status         price
                       delivery_status      freight_value
                       delivery_days
                                                │
                                            sellers
                                            seller_id (PK)
                                            seller_city
                                            seller_state
```

**Join relationships:**
- `orders.customer_id = customers.customer_id`
- `orders.order_id = order_items.order_id`
- `order_items.seller_id = sellers.seller_id`

---

## Tools and Workflow

### Excel — Data Cleaning

Each source CSV was cleaned before loading into SQL Server.

**Tasks performed:**
- Validated headers and key identifiers across all 4 tables
- Reviewed null fields in date columns — documented in cleaning log
- Created `delivery_status` column using this logic:
  - **On Time** → actual delivery date ≤ estimated delivery date
  - **Late** → actual delivery date > estimated delivery date
- Created `delivery_days` column → integer days from purchase to delivery
- Standardized seller city text values
- Fixed encoding issue in seller city file — saved with ACP codepage
- Exported all 4 tables as cleaned CSV files for SQL loading

**All cleaning issues documented in `docs/cleaning_log.xlsx`**

---

### SQL Server 2014 — Data Loading

**Database:** `olist_delivery_db`

**Loading approach:** `BULK INSERT` from cleaned CSV files

Import order followed foreign key dependency:
1. customers
2. sellers
3. orders
4. order_items

| Table | Expected Rows | Status |
|---|---|---|
| customers | 99,441 | ✅ Loaded |
| sellers | 3,095 | ✅ Loaded |
| orders | 99,441 | ✅ Loaded |
| order_items | 112,650 | ✅ Loaded |

---

### SQL Server — Validation

After loading, the following checks were run in `03_validation_queries.sql`:

- Row count check for all 4 tables
- Top 5 row preview per table
- Distinct order status and delivery status values
- Join integrity — orders without matching customer → 0
- Join integrity — order items without matching seller → 0
- NULL check on key date columns
- Delivery days sanity check — min, max, avg

**All checks passed successfully.**

---

### SQL Server — KPI Analysis

15 business queries written covering delivery performance, customer geography,
and seller contribution. A master view `vw_delivery_master` was created joining
all 4 tables as a single flat output ready for reporting.

---

## SQL Analysis — KPIs Covered

| # | Query | Business Question |
|---|---|---|
| 1 | Total delivered orders | How many orders were delivered? |
| 2 | On Time vs Late count and % | What is our SLA compliance rate? |
| 3 | Average delivery days | How long does delivery take on average? |
| 4 | Total sales and freight value | What is the total revenue generated? |
| 5 | Top 10 cities by order volume | Where are our biggest customer bases? |
| 6 | Top 10 cities by late orders | Which cities receive the most late deliveries? |
| 7 | Late delivery rate % by city | Which cities have the worst SLA performance? |
| 8 | Delivered orders by state | State-level order distribution |
| 9 | Late orders and rate by state | State-level SLA performance |
| 10 | Sales and freight by state | State-level revenue breakdown |
| 11 | Average delivery days by state | Which states have the slowest delivery? |
| 12 | Top 10 cities by avg delivery days | Slowest delivery cities |
| 13 | Top seller cities by volume | Where are the most active sellers? |
| 14 | Top 10 sellers by revenue | Which sellers drive the most sales? |
| 15 | Monthly order and late trend | How does performance change over time? |

**Master View:** `dbo.vw_delivery_master`
Joins all 4 tables into one clean flat view — ready for any reporting tool.

---

## Key Findings

Findings from SQL KPI analysis:

- **96,000+** orders were successfully delivered out of 99,441 total
- **~92%** of delivered orders arrived on time
- **Average delivery time** is approximately 12 days from purchase to delivery
- **São Paulo** has the highest order volume across all cities and states
- **Remote northern states** show significantly longer average delivery times
- **Late delivery rate varies sharply by city** — some cities show 2x the average rate
- **Top 10 sellers** contribute a disproportionately large share of total revenue

---

## Project Structure

```
olist-delivery-analysis/
│
├── data/
│   ├── olist_orders_dataset.csv
│   ├── olist_customers_dataset.csv
│   ├── olist_order_items_dataset.csv
│   └── olist_sellers_dataset.csv
│
├── cleaned/
│   ├── cleaned_orders.csv
│   ├── cleaned_customers.csv
│   ├── cleaned_order_items.csv
│   └── cleaned_seller_city.csv
│
├── sql/
│   ├── 01_create_tables.sql
│   ├── 02_bulk_insert_notes.sql
│   ├── 03_validation_queries.sql
│   ├── 04_analysis_queries.sql
│   └── 05_master_view.sql
│
└── docs/
    ├── data_dictionary.xlsx
    └── cleaning_log.xlsx

README.md
```

---

## How to Reproduce

**Step 1 — Create the database**
```sql
CREATE DATABASE olist_delivery_db;
```

**Step 2 — Create tables**
Open SSMS → run `sql/01_create_tables.sql`

**Step 3 — Load data**
- Place all 4 cleaned CSV files inside `C:\SQLData\`
- Run `sql/02_bulk_insert_notes.sql`

**Step 4 — Validate**
Run `sql/03_validation_queries.sql`
Confirm all row counts and join checks pass.

**Step 5 — Run KPI analysis**
Run `sql/04_analysis_queries.sql` for all 15 business queries.

**Step 6 — Create master view**
Run `sql/05_master_view.sql`
Verify with:
```sql
SELECT TOP 5 * FROM dbo.vw_delivery_master;
```

---

## Author

**Sunil Sharma**
Aspiring Data Analyst | Excel · SQL Server · Power BI

LinkedIn: https://www.linkedin.com/in/sunilsharma123/
GitHub: https://github.com/Sunil7489
