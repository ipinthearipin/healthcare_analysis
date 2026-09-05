CREATE OR REPLACE VIEW raw_patients AS
SELECT *
FROM read_csv_auto('data/patients_easy.csv', header = true);

SELECT COUNT(*) AS total_rows
FROM raw_patients;

DESCRIBE raw_patients;

SELECT *
FROM raw_patients
LIMIT 20;