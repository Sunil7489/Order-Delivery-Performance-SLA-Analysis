# Order Delivery Performance & SLA Analysis
**SQL Server | Excel | Power BI**

## Executive Summary
This project focuses on analyzing e-commerce order delivery performance using selected tables from the Olist dataset. The objective is to build a structured analytics workflow covering data understanding, Excel-based cleaning, SQL Server data loading, and downstream KPI analysis for delivery performance, SLA adherence, customer geography, seller activity, and freight-related metrics.

The project is being developed in phases. The current completed phase includes source data understanding, table-level cleaning, key delivery logic preparation, and successful loading of cleaned datasets into SQL Server for analysis.

## Business Problem
E-commerce and logistics operations depend heavily on delivery performance, fulfillment efficiency, and customer location patterns. Business teams need visibility into questions such as:

- How many orders were successfully delivered?
- How many deliveries were completed on time versus late?
- Which customer cities generate the highest order volumes?
- Which sellers contribute the most order items?
- How do freight values vary across order activity?

This project is designed to create a structured analytical foundation for answering those questions.

## Objective
The primary objective of this project is to build an end-to-end delivery analytics workflow using Excel, SQL Server, and Power BI.

The project is intended to:

- prepare and standardize source data for analysis
- define delivery performance logic for on-time vs late fulfillment
- load cleaned tables into SQL Server
- enable SQL-based KPI analysis
- support a Power BI dashboard for business reporting

## Dataset Scope
This project uses selected datasets from the Olist e-commerce data model.

### Tables included in the current scope
- `orders`
- `customers`
- `order_items`
- `sellers`

### Table purpose
**orders**  
Contains order timeline data including order status, purchase timestamp, delivery timestamps, estimated delivery date, and delivery helper fields.

**customers**  
Contains customer-level location information including city and state.

**order_items**  
Contains order item details including seller, product, price, and freight value.

**sellers**  
Contains seller-level location information including city and state.

## Data Model
The current join model is based on the following relationships:

```sql
orders.customer_id = customers.customer_id
orders.order_id = order_items.order_id
order_items.seller_id = sellers.seller_id


That is **3 backticks** only.

After that, press **Enter** and paste this next part:

```md
This model supports order-level, customer-level, seller-level, and item-level analysis.

## Data Preparation
The project followed a staged preparation approach before SQL analysis.

### 1. Data Understanding
Each source table was reviewed to identify:
- key columns
- business meaning
- delivery-relevant fields
- join relationships
- null behavior in timeline columns

### 2. Excel-Based Cleaning
Cleaning was performed in working copies of the source files. Key tasks included:

- validation of headers and key identifiers
- review of blank and partial-null fields
- creation of delivery helper columns in the orders table
- standardization of inconsistent seller city values
- identification of malformed location text in cleaned seller data

### 3. Delivery Logic Preparation
The following logic was prepared in the cleaned orders dataset:

- **On Time**: actual customer delivery date is less than or equal to estimated delivery date
- **Late**: actual customer delivery date is greater than estimated delivery date
- **Unknown**: delivery comparison not possible due to missing timestamps

Additional delivery-day calculation logic was also added in the cleaned orders file.

## SQL Server Data Loading
Because direct Excel import was not reliable in SQL Server 2014, the final load approach used:

- Excel for cleaning
- CSV export for staging
- `BULK INSERT` for SQL Server loading

### SQL Server database
`olist_delivery_db`

### Imported tables
- `customers`
- `sellers`
- `order_items`
- `orders`

## Current Status
**Completed — Data Understanding, Cleaning, and SQL Import**

At this stage, the project has completed:
- source table selection
- data understanding
- Excel-based cleaning
- delivery helper field preparation
- SQL Server database creation
- successful loading of the cleaned tables into SQL Server

## Tools Used
- **Excel** — data understanding and cleaning
- **SQL Server / SSMS** — data loading and table setup
- **Power BI** — planned for later reporting phase