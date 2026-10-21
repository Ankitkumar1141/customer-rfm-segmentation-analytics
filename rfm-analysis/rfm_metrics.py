# ============================================================
# Script  : rfm_metrics.py
# Project : Customer RFM Segmentation Analytics
# Author  : Ankit Kumar
# Purpose : Load cleaned retail data, compute RFM metrics,
#           and score each customer 1-5 per dimension
# ============================================================

import pandas as pd
import numpy as np
import warnings
warnings.filterwarnings('ignore')

# ─────────────────────────────────────────
# 1. LOAD DATA
# ─────────────────────────────────────────
print("Loading cleaned dataset...")
df = pd.read_csv('data/RetailCleaned.csv', parse_dates=['InvoiceDate'])
print(f"  Rows loaded : {len(df):,}")
print(f"  Date range  : {df['InvoiceDate'].min().date()} → {df['InvoiceDate'].max().date()}")
print(f"  Customers   : {df['Customer_ID'].nunique():,}")


# ─────────────────────────────────────────
# 2. DEFINE ANALYSIS SNAPSHOT DATE
# ─────────────────────────────────────────
# Use one day after the latest transaction as the reference point
snapshot_date = df['InvoiceDate'].max() + pd.Timedelta(days=1)
print(f"\nSnapshot date: {snapshot_date.date()}")


# ─────────────────────────────────────────
# 3. COMPUTE RFM METRICS
# ─────────────────────────────────────────
rfm = df.groupby('Customer_ID').agg(
    Recency   = ('InvoiceDate',  lambda x: (snapshot_date - x.max()).days),
    Frequency = ('Invoice',      'nunique'),
    Monetary  = ('Revenue',      'sum')
).reset_index()

rfm['Monetary'] = rfm['Monetary'].round(2)
print(f"\nRFM table shape: {rfm.shape}")
print(rfm.describe())


# ─────────────────────────────────────────
# 4. RFM SCORING (1–5 per dimension)
# ─────────────────────────────────────────
# Recency: lower is better → score 5 for lowest recency
rfm['R_Score'] = pd.qcut(rfm['Recency'], 5, labels=[5, 4, 3, 2, 1]).astype(int)

# Frequency: higher is better → score 5 for highest frequency
# rank(method='first') breaks ties so qcut bins are equal
rfm['F_Score'] = pd.qcut(rfm['Frequency'].rank(method='first'), 5, labels=[1, 2, 3, 4, 5]).astype(int)

# Monetary: higher is better → score 5 for highest revenue
rfm['M_Score'] = pd.qcut(rfm['Monetary'], 5, labels=[1, 2, 3, 4, 5]).astype(int)

# Composite RFM score (string concat for segment mapping)
rfm['RFM_Score'] = rfm['R_Score'].astype(str) + rfm['F_Score'].astype(str) + rfm['M_Score'].astype(str)

print("\nScore distribution:")
print(rfm[['R_Score', 'F_Score', 'M_Score']].describe())
