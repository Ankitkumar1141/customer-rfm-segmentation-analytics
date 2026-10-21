-- ============================================================
-- Script: Create Staging Tables
-- Project : Customer RFM Segmentation Analytics
-- Author  : Ankit Kumar
-- Purpose : Create raw import tables for both dataset sheets
-- ============================================================

USE RetailDB;
GO

-- Drop tables if they already exist (for reruns)
IF OBJECT_ID('dbo.[Year 2009-2010]', 'U') IS NOT NULL DROP TABLE dbo.[Year 2009-2010];
IF OBJECT_ID('dbo.[Year 2010-2011]', 'U') IS NOT NULL DROP TABLE dbo.[Year 2010-2011];
GO

-- Staging table for Year 2009-2010 sheet
CREATE TABLE dbo.[Year 2009-2010] (
    Invoice     NVARCHAR(50),
    StockCode   NVARCHAR(50),
    Description NVARCHAR(255),
    Quantity    NVARCHAR(20),   -- intentionally varchar; will convert after cleaning
    InvoiceDate NVARCHAR(50),   -- intentionally varchar; mixed format issue
    Price       NVARCHAR(20),   -- intentionally varchar; will convert after cleaning
    Customer_ID NVARCHAR(50),
    Country     NVARCHAR(100)
);

-- Staging table for Year 2010-2011 sheet
CREATE TABLE dbo.[Year 2010-2011] (
    Invoice     NVARCHAR(50),
    StockCode   NVARCHAR(50),
    Description NVARCHAR(255),
    Quantity    NVARCHAR(20),
    InvoiceDate NVARCHAR(50),
    Price       NVARCHAR(20),
    Customer_ID NVARCHAR(50),
    Country     NVARCHAR(100)
);

PRINT 'Staging tables created successfully.';
GO
