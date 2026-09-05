--count the number of rows in the raw_patients and cleaned_patients tables
SELECT COUNT(*) AS total_rows
FROM raw_patients;
SELECT COUNT(*) AS total_rows
FROM cleaned_patients;

--dupicate
--all data
SELECT
    *,
    COUNT(*) AS duplicate_count
FROM cleaned_patients
GROUP BY ALL
HAVING COUNT(*) > 1;
--patient_id
SELECT
    patient_id,
    COUNT(*) AS duplicate_count
FROM cleaned_patients
GROUP BY patient_id
having COUNT(*) > 1;

--Null values
SELECT
    COUNT(*) AS total_rows,
    COUNT(*) FILTER (WHERE patient_id IS NULL) AS null_patient_id,
    COUNT(*) FILTER (WHERE full_name IS NULL) AS null_name,
    COUNT(*) FILTER (WHERE gender IS NULL) AS null_gender,
    COUNT(*) FILTER (WHERE phone IS NULL) AS null_phone,
    COUNT(*) FILTER (WHERE email IS NULL) AS null_email,
    COUNT(*) FILTER (WHERE date_of_birth IS NULL) AS null_dob,
    COUNT(*) FILTER (WHERE registration_date IS NULL) AS null_registration,
    COUNT(*) FILTER (WHERE insurance_provider IS NULL) AS null_insurance,
    COUNT(*) FILTER (WHERE state IS NULL) AS null_state,
    COUNT(*) FILTER (WHERE city IS NULL) AS null_city,
    COUNT(*) FILTER (WHERE zip_code IS NULL) AS null_zip
FROM cleaned_patients;

--email validation
SELECT
    patient_id,
    email
FROM cleaned_patients
WHERE email IS NOT NULL
  AND NOT regexp_full_match(
      email,
      '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');

--phone
SELECT
    patient_id,
    phone
FROM cleaned_patients
WHERE phone IS NOT NULL
  AND LENGTH(phone) < 10;

--dob and registration date validation
SELECT
    patient_id,
    date_of_birth,
    registration_date
FROM cleaned_patients
WHERE try_strptime(date_of_birth, '%d-%m-%Y')
      > try_strptime(registration_date, '%d-%m-%Y');

--order by date of birth
SELECT
    cleaned_patients.patient_id,
    cleaned_patients.date_of_birth,
    raw.date_of_birth AS next_patient_dob
FROM cleaned_patients
JOIN raw_patients AS raw
    ON cleaned_patients.patient_id = raw.patient_id
WHERE cleaned_patients.date_of_birth IS NOT NULL
ORDER BY try_strptime(cleaned_patients.date_of_birth, '%d-%m-%Y')

--city and state validation
SELECT
    COUNT(*) AS total_rows,
    COUNT(*) FILTER (WHERE city IS NULL) AS null_city,
    COUNT(*) FILTER (WHERE state IS NULL) AS null_state
FROM cleaned_patients;
SELECT
    state,
    COUNT(*) AS total_patients
FROM cleaned_patients
GROUP BY state
ORDER BY state;
SELECT
    patient_id,
    city
FROM cleaned_patients
WHERE city IS NOT NULL
  AND (
      city LIKE '%&#x20;%'
      OR  city LIKE '%  %'
  );

--zip code validation
SELECT
    patient_id,
    zip_code
FROM cleaned_patients
WHERE zip_code IS NOT NULL
    AND NOT regexp_full_match(zip_code, '^[0-9]{5}$');



