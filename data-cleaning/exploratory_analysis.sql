-- ============================================================
-- Script: Exploratory Analysis Queries
-- Project : Customer RFM Segmentation Analytics
-- Author  : Ankit Kumar
-- Purpose : Initial EDA to understand revenue distribution,
--           top customers, top countries, and seasonal patterns
--           before moving to Python for RFM modelling
-- ============================================================

USE RetailDB;
GO

-- 1. Revenue by Country (Top 10)
SELECT TOP 10
    Country,
    COUNT(DISTINCT Customer_ID) AS Customers,
    SUM(Revenue)                AS TotalRevenue,
    AVG(Revenue)                AS AvgOrderRevenue
FROM dbo.RetailCleaned
GROUP BY Country
ORDER BY TotalRevenue DESC;

-- 2. Revenue by Month (seasonal pattern check)
SELECT
    InvoiceYear,
    InvoiceMonth,
    SUM(Revenue) AS MonthlyRevenue
FROM dbo.RetailCleaned
GROUP BY InvoiceYear, InvoiceMonth
ORDER BY InvoiceYear, InvoiceMonth;

-- 3. Top 20 Customers by Revenue
SELECT TOP 20
    Customer_ID,
    Country,
    COUNT(DISTINCT Invoice) AS TotalOrders,
    SUM(Revenue)            AS TotalRevenue
FROM dbo.RetailCleaned
GROUP BY Customer_ID, Country
ORDER BY TotalRevenue DESC;

-- 4. Revenue by Quarter
SELECT
    InvoiceYear,
    InvoiceQuarter,
    SUM(Revenue) AS QuarterlyRevenue
FROM dbo.RetailCleaned
GROUP BY InvoiceYear, InvoiceQuarter
ORDER BY InvoiceYear, InvoiceQuarter;

-- 5. Unique customers per year
SELECT
    InvoiceYear,
    COUNT(DISTINCT Customer_ID) AS UniqueCustomers
FROM dbo.RetailCleaned
GROUP BY InvoiceYear
ORDER BY InvoiceYear;
GO
