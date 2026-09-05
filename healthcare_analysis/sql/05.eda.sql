--data overview
SELECT
    COUNT(*) AS total_patients,
    COUNT(DISTINCT patient_id) AS unique_patients,
    COUNT(DISTINCT gender) AS total_genders,
    COUNT(DISTINCT insurance_provider) AS total_insurance_providers,
    COUNT(DISTINCT state) AS total_states,
    COUNT(DISTINCT city) AS total_cities
FROM cleaned_patients;

--patient by gender
SELECT
    gender,
    COUNT(*) AS total_patients,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS percentage
FROM cleaned_patients
WHERE gender IS NOT NULL
GROUP BY gender
ORDER BY total_patients DESC;

--patient by insurance provider
SELECT
    insurance_provider,
    COUNT(*) AS total_patients,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS percentage
FROM cleaned_patients
WHERE insurance_provider IS NOT NULL
GROUP BY insurance_provider
ORDER BY total_patients DESC;

--patient by state
SELECT
    state,
    COUNT(*) AS total_patients,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS percentage
FROM cleaned_patients
WHERE state IS NOT NULL
GROUP BY state
ORDER BY total_patients DESC;

--patient by city
SELECT
    city,
    COUNT(*) AS total_patients,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS percentage
FROM cleaned_patients
WHERE city IS NOT NULL
GROUP BY city
ORDER BY city;

SELECT
    patient_id,
    date_of_birth,
    DATE_DIFF(
        'year',
        TRY_STRPTIME(date_of_birth, '%d-%m-%Y'),
        DATE '2026-01-01'
    ) AS age
FROM cleaned_patients;
