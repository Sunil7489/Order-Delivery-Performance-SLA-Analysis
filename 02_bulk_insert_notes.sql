USE olist_delivery_db;
GO

/*
Bulk insert notes for SQL Server 2014

Steps followed:
1. Clean data in Excel
2. Save cleaned sheets as CSV
3. Move CSV files to C:\SQLData
4. Use BULK INSERT to load tables into SQL Server

Important:
- Close CSV files before running BULK INSERT
- Use simple file paths
- Use ROWTERMINATOR = '0x0d0a'
- Use CODEPAGE = 'ACP' when needed for older SQL Server versions
*/

BULK INSERT dbo.customers
FROM 'C:\SQLData\cleaned_customers.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0d0a',
    TABLOCK
);
GO

BULK INSERT dbo.sellers
FROM 'C:\SQLData\cleaned_seller_city.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0d0a',
    TABLOCK,
    CODEPAGE = 'ACP'
);
GO

BULK INSERT dbo.order_items
FROM 'C:\SQLData\cleaned_order_items.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0d0a',
    TABLOCK,
    CODEPAGE = 'ACP'
);
GO

BULK INSERT dbo.orders
FROM 'C:\SQLData\orders_cleaned.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0d0a',
    TABLOCK,
    CODEPAGE = 'ACP'
);
GO