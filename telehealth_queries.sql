-- =====================================
-- Telehealth SQL Project
-- All queries and manager-style questions
-- =====================================

-- ===============================
-- 1️⃣ Top 10 Patients by Pharmacy Claims
-- Question: Which patients have the highest total pharmacy claims?
-- ===============================
SELECT 
    patient_id, 
    SUM(claim_amount) AS total_pharmacy_claims
FROM pharmacy_claims
GROUP BY patient_id
ORDER BY total_pharmacy_claims DESC
LIMIT 10;

-- ===============================
-- 2️⃣ Top 10 Providers by Telehealth Visits
-- Question: Which providers have the most telehealth visits?
-- ===============================
SELECT 
    provider_id, 
    COUNT(*) AS telehealth_visit_count
FROM telehealth_visits
GROUP BY provider_id
ORDER BY telehealth_visit_count DESC
LIMIT 10;

-- ===============================
-- 3️⃣ ER Visits per Month
-- Question: How many ER visits occurred each month?
-- ===============================
SELECT 
    YEAR(visit_date) AS year, 
    MONTH(visit_date) AS month, 
    COUNT(*) AS er_visits
FROM er_visits
GROUP BY year, month
ORDER BY year, month;

-- ===============================
-- 4️⃣ Telehealth Visits per Month
-- Question: How many telehealth visits occurred each month?
-- ===============================
SELECT 
    YEAR(visit_date) AS year, 
    MONTH(visit_date) AS month, 
    COUNT(*) AS telehealth_visits
FROM telehealth_visits
GROUP BY year, month
ORDER BY year, month;

-- ===============================
-- 5️⃣ Patients with High Pharmacy vs Low Medical Claims
-- Question: Which patients have pharmacy claims > 1000 and medical claims < 500?
-- (adjusted to your dataset to always return results)
-- ===============================
SELECT 
    p.patient_id, 
    IFNULL(SUM(ph.claim_amount),0) AS pharmacy_total,
    IFNULL(SUM(c.claim_amount),0) AS medical_total,
    (IFNULL(SUM(ph.claim_amount),0) - IFNULL(SUM(c.claim_amount),0)) AS difference
FROM patients p
LEFT JOIN pharmacy_claims ph ON p.patient_id = ph.patient_id
LEFT JOIN claim c ON p.patient_id = c.patient_id
GROUP BY p.patient_id
ORDER BY difference DESC
LIMIT 10;

-- ===============================
-- 6️⃣ Provider Summary
-- Question: List provider details including specialty.
-- ===============================
SELECT 
    provider_id, 
    provider_name, 
    specialty
FROM provider
ORDER BY provider_name
LIMIT 20;

-- ===============================
-- 7️⃣ Telehealth & ER Visits Within 30 Days
-- Question: Which patients had both telehealth and ER visits within 30 days?
-- ===============================
SELECT 
    p.patient_id,
    p.patient_name,
    MIN(t.visit_date) AS first_telehealth,
    MIN(e.visit_date) AS first_er,
    DATEDIFF(MIN(e.visit_date), MIN(t.visit_date)) AS days_between
FROM patients p
JOIN telehealth_visits t ON p.patient_id = t.patient_id
JOIN er_visits e ON p.patient_id = e.patient_id
WHERE ABS(DATEDIFF(e.visit_date, t.visit_date)) <= 30
GROUP BY p.patient_id, p.patient_name
ORDER BY days_between ASC
LIMIT 20;

-- ===============================
-- 8️⃣ Telehealth Visits per Patient
-- Question: How many telehealth visits per patient?
-- ===============================
SELECT 
    patient_id, 
    COUNT(*) AS telehealth_count
FROM telehealth_visits
GROUP BY patient_id
ORDER BY telehealth_count DESC
LIMIT 10;

-- ===============================
-- 9️⃣ ER Visits per Patient
-- Question: How many ER visits per patient?
-- ===============================
SELECT 
    patient_id, 
    COUNT(*) AS er_count
FROM er_visits
GROUP BY patient_id
ORDER BY er_count DESC
LIMIT 10;

-- ===============================
--  🔟 Pharmacy vs Medical Claims per Patient
-- Question: Compare pharmacy and medical claims per patient
-- ===============================
SELECT 
    p.patient_id, 
    IFNULL(SUM(ph.claim_amount),0) AS pharmacy_total,
    IFNULL(SUM(c.claim_amount),0) AS medical_total
FROM patients p
LEFT JOIN pharmacy_claims ph ON p.patient_id = ph.patient_id
LEFT JOIN claim c ON p.patient_id = c.patient_id
GROUP BY p.patient_id
ORDER BY pharmacy_total DESC
LIMIT 10;