--Missing Value
SELECT count(*) as missing_dob
from raw_patients
where date_of_birth is null;

SELECT count(*) as missing_gender
from raw_patients
where gender is null;

select count(*) as missing_phone
from raw_patients
where phone is null;

SELECT count(*) as missing_email 
from raw_patients
where email is null;

select count(*) as MISSING_CITY
from raw_patients
where CITY is null; 

SELECT count(*) as missing_state
from raw_patients
where state is null;

SELECT count(*) as missing_zip
from raw_patients
where zip is null;

SELECT count(*) as missing_insurance
from raw_patients
where insurance_provider is null;   

SELECT count(*) as MISSING_REGISTERED_DATE
from raw_patients
WHERE REGISTRATION_DATE is null;


--DUPLICATE
SELECT count(*) as duplicate_patients
from (
    SELECT patient_id, COUNT(*) as cnt
    from raw_patients
    GROUP BY patient_id
    HAVING COUNT(*) > 1
) duplicates;

SELECT count(*) as duplicate_names
from (
    SELECT full_name, COUNT(*) as cnt
    from raw_patients
    GROUP BY full_name
    HAVING COUNT(*) > 1
) duplicates;

SELECT count(*) as duplicate_emails
from (
    SELECT email, COUNT(*) as cnt
    from raw_patients
    GROUP BY email
    HAVING COUNT(*) > 1
) duplicates;


SELECT count(*) as duplicate_phones
from (
    SELECT phone, COUNT(*) as cnt
    from raw_patients
    GROUP BY phone
    HAVING COUNT(*) > 1
) duplicates;

SELECT count(*) as duplicate_dobs
from (
    SELECT date_of_birth, COUNT(*) as cnt
    from raw_patients
    GROUP BY date_of_birth
    HAVING COUNT(*) > 1
) duplicates;

select count(*) as dupicate_city
from (
    SELECT city, COUNT(*) as cnt
    from raw_patients
    GROUP BY city
    HAVING COUNT(*) > 1
) duplicates;   

select count(*) as duplicate_state
from (
    SELECT state, COUNT(*) as cnt
    from raw_patients
    GROUP BY state
    HAVING COUNT(*) > 1
) duplicates;   

select count(*) as duplicate_zip
from (
    SELECT zip, COUNT(*) as cnt
    from raw_patients
    GROUP BY zip
    HAVING COUNT(*) > 1
) duplicates;

select count(*) as duplicate_insurance
from (
    SELECT insurance_provider, COUNT(*) as cnt
    from raw_patients
    GROUP BY insurance_provider
    HAVING COUNT(*) > 1
) duplicates;

-- EXACT DUPLICATES
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT (
        patient_id,
        full_name,
        gender,
        date_of_birth,
        phone,
        email,
        city,
        state,
        zip_code,
        insurance_provider,
        registration_date
    )) AS unique_rows,
    COUNT(*) - COUNT(DISTINCT (
        patient_id,
        full_name,
        gender,
        date_of_birth,
        phone,
        email,
        city,
        state,
        zip_code,
        insurance_provider,
        registration_date
    )) AS exact_duplicate_rows
FROM raw_patients;

--DISTINCT & INCONSISTENT DATA
SELECT
    gender,
    COUNT(*) AS total
FROM raw_patients
GROUP BY gender
ORDER BY total DESC;

SELECT
    state,
    COUNT(*) AS total
FROM raw_patients
GROUP BY state
ORDER BY total DESC;

SELECT
    insurance_provider,
    COUNT(*) AS total
FROM raw_patients
GROUP BY insurance_provider
ORDER BY total DESC;

SELECT
    city,
    COUNT(*) AS total  
FROM raw_patients
GROUP BY city
ORDER BY total DESC;

SELECT
    zip_code,
    COUNT(*) AS total
FROM raw_patients
GROUP BY zip_code 
ORDER BY total DESC;

SELECT
    date_of_birth,
    COUNT(*) AS total
FROM raw_patients
GROUP BY date_of_birth
ORDER BY total DESC;

SELECT
    phone,
    COUNT(*) AS total
FROM raw_patients
GROUP BY phone
ORDER BY total DESC;

SELECT
    registration_date,
    COUNT(*) AS total
FROM raw_patients
GROUP BY registration_date
ORDER BY total DESC;

SELECT
    patient_id,
    email
FROM raw_patients
WHERE email IS NOT NULL
  AND (
       email NOT LIKE '%@%'
       OR email LIKE '%,%'
       OR email LIKE '% at %'
  );

--DOB LOGIC CHECK
SELECT *
FROM raw_patients
WHERE TRY_CAST(date_of_birth AS DATE) > CURRENT_DATE;


