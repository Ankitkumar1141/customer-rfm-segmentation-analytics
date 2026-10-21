-- ============================================================
-- Script: Fix Mixed Date Formats & Combine Sheets
-- Project : Customer RFM Segmentation Analytics
-- Author  : Ankit Kumar
-- Purpose : Resolve mixed date format issue (affects 50%+ rows)
--           and merge both sheets into a single staging table
-- ============================================================

USE RetailDB;
GO

-- Drop combined table if exists
IF OBJECT_ID('dbo.RetailCombined', 'U') IS NOT NULL DROP TABLE dbo.RetailCombined;
GO

-- Combine and fix date formats for Year 2009-2010
SELECT
    Invoice,
    StockCode,
    Description,
    TRY_CONVERT(INT, Quantity)  AS Quantity,
    COALESCE(
        TRY_CONVERT(datetime2, InvoiceDate, 120),   -- ISO format: yyyy-mm-dd hh:mm:ss
        TRY_CONVERT(datetime2, InvoiceDate, 105)    -- European format: dd-mm-yyyy
    ) AS InvoiceDate,
    TRY_CONVERT(DECIMAL(10,2), Price) AS Price,
    Customer_ID,
    Country
INTO dbo.RetailCombined
FROM dbo.[Year 2009-2010]

UNION ALL

SELECT
    Invoice,
    StockCode,
    Description,
    TRY_CONVERT(INT, Quantity)  AS Quantity,
    COALESCE(
        TRY_CONVERT(datetime2, InvoiceDate, 120),
        TRY_CONVERT(datetime2, InvoiceDate, 105)
    ) AS InvoiceDate,
    TRY_CONVERT(DECIMAL(10,2), Price) AS Price,
    Customer_ID,
    Country
FROM dbo.[Year 2010-2011];

PRINT 'Rows inserted into RetailCombined: ' + CAST(@@ROWCOUNT AS VARCHAR);
GO
