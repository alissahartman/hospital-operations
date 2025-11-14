-- Hospitals in Jackson County, OR
SELECT
aha_id
,hospital_name
FROM ref_hospital
WHERE county = 'Jackson';

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
TO_DATE(CONCAT(year,'-',month,'-',1),'YYYY-MM-DD') as month
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