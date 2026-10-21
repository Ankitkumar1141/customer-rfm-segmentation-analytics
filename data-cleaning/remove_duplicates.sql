-- ============================================================
-- Script: Remove Duplicates & Invalid Rows
-- Project : Customer RFM Segmentation Analytics
-- Author  : Ankit Kumar
-- Purpose : Remove 32,907 exact duplicate rows identified via
--           ROW_NUMBER() window function, and filter out
--           invalid/cancelled transactions
-- ============================================================

USE RetailDB;
GO

-- Step 1: Flag exact duplicates using ROW_NUMBER
-- A duplicate is defined as identical Invoice + StockCode + Quantity + InvoiceDate
WITH DuplicateCTE AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY Invoice, StockCode, Quantity, InvoiceDate, Customer_ID
            ORDER BY (SELECT NULL)
        ) AS rn
    FROM dbo.RetailCombined
)
DELETE FROM DuplicateCTE WHERE rn > 1;

PRINT 'Duplicates removed. Rows remaining: ' + CAST(@@ROWCOUNT AS VARCHAR);
GO

-- Step 2: Remove cancellations (Invoice starts with 'C')
DELETE FROM dbo.RetailCombined
WHERE Invoice LIKE 'C%';

PRINT 'Cancelled invoices removed.';
GO

-- Step 3: Remove rows with NULL Customer_ID (no customer linkage possible)
DELETE FROM dbo.RetailCombined
WHERE Customer_ID IS NULL OR LTRIM(RTRIM(Customer_ID)) = '';

PRINT 'Rows with NULL Customer_ID removed.';
GO

-- Step 4: Remove rows with non-positive Quantity or Price
DELETE FROM dbo.RetailCombined
WHERE Quantity <= 0 OR Price <= 0;

PRINT 'Invalid Quantity/Price rows removed.';
GO

-- Step 5: Verify final row count
SELECT COUNT(*) AS FinalRowCount FROM dbo.RetailCombined;
GO
