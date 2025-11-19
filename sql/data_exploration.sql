-- Dates
SELECT
year,
month
FROM oha_hospital_databank
GROUP BY 1,2
ORDER BY 1 DESC,2 DESC;

-- Hospitals in a county
SELECT
aha_id
,hospital_name
FROM ref_hospital
WHERE county = 'Multnomah'
ORDER BY hospital_name;

-- Birth ounts
WITH births as (
SELECT
TO_DATE(CONCAT(year,'-',month,'-',1),'YYYY-MM-DD') as date
,SUM(births) as births
FROM oha_hospital_databank a
JOIN ref_hospital b ON a.aha_id = b.aha_id
WHERE b.county = 'Jackson'
GROUP BY 1
)
SELECT
date
,births
,AVG(births) OVER (
        ORDER BY date
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) as moving_avg
FROM births
;

-- Available beds
SELECT
TO_DATE(CONCAT(year,'-',month,'-',1),'YYYY-MM-DD') as month
,SUM(available_beds) as available_beds
FROM oha_hospital_databank a
JOIN ref_hospital b ON a.aha_id = b.aha_id
WHERE b.county = 'Jackson'
GROUP BY 1
ORDER BY 1 ASC;

-- Financials
SELECT
TO_DATE(CONCAT(year,'-',month,'-',1),'YYYY-MM-DD') as month_start
,SUM(total_charges) as charges
,SUM(total_margin) as margin
,SUM(total_operating_expense) as operating_expense
,SUM(total_revenue) as revenue
FROM oha_hospital_databank a
JOIN ref_hospital b ON a.aha_id = b.aha_id
WHERE b.county = 'Jackson'
GROUP BY 1
ORDER BY 1 ASC;

-- Admissions
SELECT
TO_DATE(CONCAT(year,'-',month,'-',1),'YYYY-MM-DD') as month
,sum(admissions_from_ed) as admissions_from_ed
,sum(ambulatory_surgery_visits) as ambulatory_surgery_visits
,sum(inpatient_surgeries) as inpatient_surgeries
,sum(observation_visits) as observation_visits
,sum(other_outpatient_visits) as other_outpatient_visits
FROM oha_hospital_databank a
JOIN ref_hospital b ON a.aha_id = b.aha_id
WHERE b.county = 'Jackson'
GROUP BY 1
ORDER BY 1 ASC;

-- Occupancy metrics for OHSU
SELECT
a.month_start
,c.days
,sum(total_patient_days) as occupancy
,sum(available_beds) as available_beds
,sum(licensed_beds) as licensed_beds
,ROUND(
    sum(total_patient_days)::decimal / (sum(licensed_beds)* c.days)::decimal
    ,4) as occupancy_rate
FROM oha_hospital_databank a
JOIN ref_hospital b ON a.aha_id = b.aha_id
JOIN ref_date c ON a.month_start = c.month_start
WHERE a.aha_id = 6920570
AND a.month_start BETWEEN '2007-01-01' AND '2024-12-01'
GROUP BY 1,2
ORDER BY 1 ASC;