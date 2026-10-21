-- ============================================================
-- Script: Create Final Cleaned Table (RetailCleaned)
-- Project : Customer RFM Segmentation Analytics
-- Author  : Ankit Kumar
-- Purpose : Produce the final, analysis-ready table with
--           proper data types, derived columns (Revenue),
--           and validated row counts vs. UCI published total
-- ============================================================

USE RetailDB;
GO

IF OBJECT_ID('dbo.RetailCleaned', 'U') IS NOT NULL DROP TABLE dbo.RetailCleaned;
GO

SELECT
    Invoice,
    StockCode,
    LTRIM(RTRIM(Description))       AS Description,
    Quantity,
    CAST(InvoiceDate AS DATE)       AS InvoiceDate,
    DATEPART(YEAR,  InvoiceDate)    AS InvoiceYear,
    DATEPART(MONTH, InvoiceDate)    AS InvoiceMonth,
    DATEPART(QUARTER, InvoiceDate)  AS InvoiceQuarter,
    Price,
    CAST(Quantity * Price AS DECIMAL(12,2)) AS Revenue,
    CAST(Customer_ID AS INT)        AS Customer_ID,
    Country
INTO dbo.RetailCleaned
FROM dbo.RetailCombined
WHERE
    InvoiceDate IS NOT NULL
    AND Quantity  IS NOT NULL
    AND Price     IS NOT NULL
    AND Customer_ID IS NOT NULL;

PRINT 'RetailCleaned created. Row count: ' + CAST(@@ROWCOUNT AS VARCHAR);
GO

-- Validation: check row count matches expected clean total
-- UCI raw total: 1,067,371 | Expected clean total after dedup + filter: ~824,364
SELECT COUNT(*) AS CleanRowCount FROM dbo.RetailCleaned;
SELECT COUNT(DISTINCT Customer_ID) AS UniqueCustomers FROM dbo.RetailCleaned;
SELECT MIN(InvoiceDate) AS EarliestDate, MAX(InvoiceDate) AS LatestDate FROM dbo.RetailCleaned;
GO
