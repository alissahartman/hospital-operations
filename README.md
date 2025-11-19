# OHSU Hospital Occupancy Analysis (2007–2024)

This project analyzes **17 years of monthly hospital occupancy data** for **Oregon Health & Science University (OHSU)** using PostgreSQL and Python. The goal is to identify long-term utilization trends, periods of capacity strain, and operational insights that can support forecasting and planning.

---

## 🔍 Project Summary
- Built a **PostgreSQL pipeline** to ingest and aggregate hospital data from the Oregon Health Authority.
- Calculated monthly **occupancy rates** using patient days, licensed beds, and days per month.
- Cleaned and transformed data in Python (pandas).
- Produced visualizations showing long-term trends, seasonal patterns, and COVID-era surges.
- Created interpretable metrics such as rolling averages, YoY changes, and over-capacity indicators.

---

## 📊 Key Questions
- How has OHSU’s inpatient occupancy changed over time?
- How often has the hospital operated **above licensed capacity**?
- What structural patterns appear before, during, and after COVID-19?
- Are occupancy levels trending upward or stabilizing?

---

## 🛠️ Tech Stack
**SQL:** PostgreSQL  
**Python:** pandas, matplotlib/seaborn  
**Other:** Jupyter Notebooks, GitHub

---

## 🧪 Data Processing

### SQL Extraction
A core query aggregates patient days, beds, and occupancy rate:

```sql
SELECT
    a.month_start,
    c.days,
    SUM(total_patient_days) AS occupancy,
    SUM(licensed_beds) AS licensed_beds,
    ROUND(
        SUM(total_patient_days)::decimal 
        / (SUM(licensed_beds) * c.days)::decimal,
        4
    ) AS occupancy_rate
FROM oha_hospital_databank a
JOIN ref_date c ON a.month_start = c.month_start
WHERE a.aha_id = 6920570  -- OHSU
GROUP BY 1,2
ORDER BY 1;
```

### Python Analysis
- Converted SQL output to a clean time-series DataFrame  
- Added:
  - 3-mo, 6-mo, 12-mo rolling averages  
  - Year-over-year deltas  
  - COVID-period indicator  
  - Over-capacity months (>100% occupancy)

---

## ✅ Example Insights (Replace with your actual results)
- Occupancy increased **significantly** from 2007–2024.  
- Many months during 2020–2022 exceeded **100% of licensed bed capacity**.  
- Post-2022 shows stabilization but at a higher baseline than pre-COVID.  
- Winter months display consistently higher utilization.

---

## 📈 Visuals
This project includes visualizations such as:
- Long-term occupancy rate trend (2007–2024)  
- Rolling averages with COVID-era shading  
- Histogram of occupancy levels  
- Identification of over-capacity months  

---

## 🚀 Future Enhancements
- Forecasting models (SARIMA, Prophet, etc.)  
- Comparison to other Portland hospitals (Providence, Legacy, Adventist)  
- Interactive Streamlit dashboard  

---

## 📂 Repository Structure
```yaml
data/                 # Raw and processed datasets
sql/                  # SQL extraction queries
notebooks/            # EDA and visualization notebooks
scripts/              # ETL and analysis scripts
visualizations/       # Output charts
project_overview.md   # Detailed documentation
README.md             # You are here
```
