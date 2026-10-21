# ============================================================
# Script  : segmentation_and_churn.py
# Project : Customer RFM Segmentation Analytics
# Author  : Ankit Kumar
# Purpose : Map RFM scores to business segments, add churn flag,
#           and export final enriched dataset for Power BI
# ============================================================

# (Run after rfm_metrics.py — rfm DataFrame must be in scope)

# ─────────────────────────────────────────
# 5. CUSTOMER SEGMENTATION
# ─────────────────────────────────────────
def assign_segment(row):
    r, f, m = row['R_Score'], row['F_Score'], row['M_Score']
    rfm_avg = (r + f + m) / 3

    if r >= 4 and f >= 4 and m >= 4:
        return 'Champions'
    elif r >= 3 and f >= 3:
        return 'Loyal Customers'
    elif r >= 4 and f <= 2:
        return 'New Customers'
    elif r <= 2 and f >= 3 and m >= 3:
        return 'At Risk'
    elif r <= 2 and f >= 4 and m >= 4:
        return 'Cannot Lose Them'
    elif rfm_avg >= 2.5:
        return 'Needs Attention'
    else:
        return 'Lost'

rfm['Segment'] = rfm.apply(assign_segment, axis=1)

print("Segment distribution:")
print(rfm['Segment'].value_counts())
print(f"\nTotal customers segmented: {len(rfm):,}")


# ─────────────────────────────────────────
# 6. CHURN FLAGGING (90-day threshold)
# ─────────────────────────────────────────
CHURN_THRESHOLD_DAYS = 90

rfm['Churned'] = (rfm['Recency'] > CHURN_THRESHOLD_DAYS).astype(int)
rfm['Churned_Label'] = rfm['Churned'].map({1: 'Churned', 0: 'Active'})

churn_rate = rfm['Churned'].mean() * 100
print(f"\nChurn rate ({CHURN_THRESHOLD_DAYS}-day threshold): {churn_rate:.2f}%")
print(rfm['Churned_Label'].value_counts())


# ─────────────────────────────────────────
# 7. MERGE BACK TO TRANSACTION LEVEL
# ─────────────────────────────────────────
rfm_cols = ['Customer_ID', 'Recency', 'Frequency', 'Monetary',
            'R_Score', 'F_Score', 'M_Score', 'RFM_Score',
            'Segment', 'Churned', 'Churned_Label']

df_final = df.merge(rfm[rfm_cols], on='Customer_ID', how='left')
print(f"\nFinal merged dataset shape: {df_final.shape}")


# ─────────────────────────────────────────
# 8. EXPORT FOR POWER BI
# ─────────────────────────────────────────
import os
os.makedirs('data', exist_ok=True)

# Export RFM summary
rfm.to_excel('data/RFM_Segmentation.xlsx', index=False)
print("Exported: data/RFM_Segmentation.xlsx")

# Export full transaction-level enriched dataset
df_final.to_excel('data/RetailAnalysis_Final.xlsx', index=False)
print("Exported: data/RetailAnalysis_Final.xlsx")

print("\nAll exports complete. Ready for Power BI.")
