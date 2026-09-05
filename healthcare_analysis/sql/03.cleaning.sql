CREATE OR REPLACE TABLE cleaned_patients AS
SELECT
--PatientID
    patient_id,
--FullName
    TRIM(full_name) AS full_name,
--Gender
    CASE
        WHEN LOWER(TRIM(gender)) IN ('m', 'male') THEN 'Male'
        WHEN LOWER(TRIM(gender)) IN ('f', 'female') THEN 'Female'
        WHEN LOWER(TRIM(gender)) IN ('o', 'other') THEN 'Other'
        ELSE NULL
    END AS gender,
--PhoneNumber 
       CASE
        WHEN phone IS NULL THEN NULL
        WHEN LOWER(TRIM(phone)) IN ('', 'n/a', 'na', 'unknown', 'none') THEN NULL
        ELSE regexp_replace(
            TRIM(phone),
            '[^0-9]',
            '',
            'g'
        )
    END AS phone,
--Email
       CASE
    WHEN email IS NULL THEN NULL
    WHEN LOWER(TRIM(email))
        IN ('', 'n/a', 'na', 'unknown', 'none')
        THEN NULL
    ELSE
        REPLACE(
            REPLACE(
                REPLACE(
                    REPLACE(
                        REPLACE(
                            REPLACE(
                                REPLACE(
                                    LOWER(TRIM(email)),
                                    ',', '.'
                                ),
                                ' at ', '@'
                            ),
                            'gmial', 'gmail'
                        ),
                        'gamil', 'gmail'
                    ),
                    'hotmial', 'hotmail'
                ),
                'yaho', 'yahoo'
            ),
            'outlok', 'outlook'
        )
    END AS email,
--DateOfBirth
CASE
    -- MM-DD-YY
    WHEN regexp_full_match(
        TRIM(date_of_birth),
        '^[0-9]{2}-[0-9]{2}-[0-9]{2}$'
    )
    THEN strftime(
        try_strptime(
            TRIM(date_of_birth),
            '%m-%d-%y'
        ),
        '%d-%m-%Y'
    )

    ELSE strftime(

        COALESCE(

            -- YYYY-MM-DD
            try_strptime(
                TRIM(date_of_birth),
                '%Y-%m-%d'
            ),

            -- MM/DD/YYYY
            try_strptime(
                TRIM(date_of_birth),
                '%m/%d/%Y'
            ),

            -- DD-Mon-YYYY
            try_strptime(
                TRIM(date_of_birth),
                '%d-%b-%Y'
            ),

            -- Month DD, YYYY
            try_strptime(
                TRIM(date_of_birth),
                '%B %d, %Y'
            ),

            -- Mon DD, YYYY
            try_strptime(
                TRIM(date_of_birth),
                '%b %d, %Y'
            )

        ),

        '%d-%m-%Y'
    )

END AS date_of_birth
--registration_date
CASE
    -- MM-DD-YY
    WHEN regexp_full_match(
        TRIM(registration_date),
        '^[0-9]{2}-[0-9]{2}-[0-9]{2}$'
    )
    THEN strftime(
        make_date(
            2000 + CAST(RIGHT(TRIM(registration_date), 2) AS INTEGER),
            CAST(LEFT(TRIM(registration_date), 2) AS INTEGER),
            CAST(SUBSTRING(TRIM(registration_date), 4, 2) AS INTEGER)
        ),
        '%d-%m-%Y'
    )
    ELSE strftime(
        COALESCE(
            -- YYYY-MM-DD
            try_strptime(TRIM(registration_date),'%Y-%m-%d'
            ),
            -- MM/DD/YYYY
            try_strptime(TRIM(registration_date),'%m/%d/%Y'
            ),
            -- DD-Mon-YYYY
            try_strptime(TRIM(registration_date),
                '%d-%b-%Y'
            ),
            -- Month DD, YYYY
            try_strptime(TRIM(registration_date),
                '%B %d, %Y'
            ),
            -- Mon DD, YYYY
            try_strptime(TRIM(registration_date),
                '%b %d, %Y'
            )
        ),
        '%d-%m-%Y'
    )
END AS registration_date,
--InsuranceProvider
CASE
    WHEN insurance_provider IS NULL
        OR LOWER(TRIM(insurance_provider)) IN ('', 'n/a', 'none', 'null')
        THEN NULL
    WHEN LOWER(TRIM(insurance_provider)) = 'medicaid'
        THEN 'Medicaid'
    WHEN LOWER(TRIM(insurance_provider)) IN (
        'medicare',
        'medi-care'
    )
        THEN 'Medicare'
    WHEN LOWER(TRIM(insurance_provider)) IN (
        'unitedhealth',
        'uhc',
        'united health'
    )
        THEN 'UnitedHealth'
    WHEN LOWER(TRIM(insurance_provider)) IN (
        'bluecross',
        'blue-cross',
        'blue cross'
    )
        THEN 'BlueCross'

    WHEN LOWER(TRIM(insurance_provider)) IN (
        'cigna',
        'cigna health'
    )
        THEN 'Cigna'

    WHEN LOWER(TRIM(insurance_provider)) IN (
        'aetna',
        'aetnaa',
        'aetna inc.'
    )
        THEN 'Aetna'

    WHEN LOWER(TRIM(insurance_provider)) IN (
        'self-pay',
        'self pay'
    )
        THEN 'Self-Pay'
    ELSE TRIM(insurance_provider)
END AS insurance_provider,
--State
CASE
    WHEN state IS NULL THEN NULL

    WHEN UPPER(TRIM(state)) = 'AL' OR LOWER(TRIM(state)) = 'alabama'
        THEN 'Alabama'

    WHEN UPPER(TRIM(state)) = 'AK' OR LOWER(TRIM(state)) = 'alaska'
        THEN 'Alaska'

    WHEN UPPER(TRIM(state)) = 'AZ' OR LOWER(TRIM(state)) = 'arizona'
        THEN 'Arizona'

    WHEN UPPER(TRIM(state)) = 'AR' OR LOWER(TRIM(state)) = 'arkansas'
        THEN 'Arkansas'

    WHEN UPPER(TRIM(state)) = 'CA' OR LOWER(TRIM(state)) = 'california'
        THEN 'California'

    WHEN UPPER(TRIM(state)) = 'CO' OR LOWER(TRIM(state)) = 'colorado'
        THEN 'Colorado'

    WHEN UPPER(TRIM(state)) = 'CT' OR LOWER(TRIM(state)) = 'connecticut'
        THEN 'Connecticut'

    WHEN UPPER(TRIM(state)) = 'DE' OR LOWER(TRIM(state)) = 'delaware'
        THEN 'Delaware'

    WHEN UPPER(TRIM(state)) = 'FL' OR LOWER(TRIM(state)) = 'florida'
        THEN 'Florida'

    WHEN UPPER(TRIM(state)) = 'GA' OR LOWER(TRIM(state)) = 'georgia'
        THEN 'Georgia'

    WHEN UPPER(TRIM(state)) = 'HI' OR LOWER(TRIM(state)) = 'hawaii'
        THEN 'Hawaii'

    WHEN UPPER(TRIM(state)) = 'ID' OR LOWER(TRIM(state)) = 'idaho'
        THEN 'Idaho'

    WHEN UPPER(TRIM(state)) = 'IL' OR LOWER(TRIM(state)) = 'illinois'
        THEN 'Illinois'

    WHEN UPPER(TRIM(state)) = 'IN' OR LOWER(TRIM(state)) = 'indiana'
        THEN 'Indiana'

    WHEN UPPER(TRIM(state)) = 'IA' OR LOWER(TRIM(state)) = 'iowa'
        THEN 'Iowa'

    WHEN UPPER(TRIM(state)) = 'KS' OR LOWER(TRIM(state)) = 'kansas'
        THEN 'Kansas'

    WHEN UPPER(TRIM(state)) = 'KY' OR LOWER(TRIM(state)) = 'kentucky'
        THEN 'Kentucky'

    WHEN UPPER(TRIM(state)) = 'LA' OR LOWER(TRIM(state)) = 'louisiana'
        THEN 'Louisiana'

    WHEN UPPER(TRIM(state)) = 'ME' OR LOWER(TRIM(state)) = 'maine'
        THEN 'Maine'

    WHEN UPPER(TRIM(state)) = 'MD' OR LOWER(TRIM(state)) = 'maryland'
        THEN 'Maryland'

    WHEN UPPER(TRIM(state)) = 'MA' OR LOWER(TRIM(state)) = 'massachusetts'
        THEN 'Massachusetts'

    WHEN UPPER(TRIM(state)) = 'MI' OR LOWER(TRIM(state)) = 'michigan'
        THEN 'Michigan'

    WHEN UPPER(TRIM(state)) = 'MN' OR LOWER(TRIM(state)) = 'minnesota'
        THEN 'Minnesota'

    WHEN UPPER(TRIM(state)) = 'MS' OR LOWER(TRIM(state)) = 'mississippi'
        THEN 'Mississippi'

    WHEN UPPER(TRIM(state)) = 'MO' OR LOWER(TRIM(state)) = 'missouri'
        THEN 'Missouri'

    WHEN UPPER(TRIM(state)) = 'MT' OR LOWER(TRIM(state)) = 'montana'
        THEN 'Montana'

    WHEN UPPER(TRIM(state)) = 'NE' OR LOWER(TRIM(state)) = 'nebraska'
        THEN 'Nebraska'

    WHEN UPPER(TRIM(state)) = 'NV' OR LOWER(TRIM(state)) = 'nevada'
        THEN 'Nevada'

    WHEN UPPER(TRIM(state)) = 'NH' OR LOWER(TRIM(state)) = 'new hampshire'
        THEN 'New Hampshire'

    WHEN UPPER(TRIM(state)) = 'NJ' OR LOWER(TRIM(state)) = 'new jersey'
        THEN 'New Jersey'

    WHEN UPPER(TRIM(state)) = 'NM' OR LOWER(TRIM(state)) = 'new mexico'
        THEN 'New Mexico'

    WHEN UPPER(TRIM(state)) = 'NY' OR LOWER(TRIM(state)) = 'new york'
        THEN 'New York'

    WHEN UPPER(TRIM(state)) = 'NC' OR LOWER(TRIM(state)) = 'north carolina'
        THEN 'North Carolina'

    WHEN UPPER(TRIM(state)) = 'ND' OR LOWER(TRIM(state)) = 'north dakota'
        THEN 'North Dakota'

    WHEN UPPER(TRIM(state)) = 'OH' OR LOWER(TRIM(state)) = 'ohio'
        THEN 'Ohio'

    WHEN UPPER(TRIM(state)) = 'OK' OR LOWER(TRIM(state)) = 'oklahoma'
        THEN 'Oklahoma'

    WHEN UPPER(TRIM(state)) = 'OR' OR LOWER(TRIM(state)) = 'oregon'
        THEN 'Oregon'

    WHEN UPPER(TRIM(state)) = 'PA' OR LOWER(TRIM(state)) = 'pennsylvania'
        THEN 'Pennsylvania'

    WHEN UPPER(TRIM(state)) = 'RI' OR LOWER(TRIM(state)) = 'rhode island'
        THEN 'Rhode Island'

    WHEN UPPER(TRIM(state)) = 'SC' OR LOWER(TRIM(state)) = 'south carolina'
        THEN 'South Carolina'

    WHEN UPPER(TRIM(state)) = 'SD' OR LOWER(TRIM(state)) = 'south dakota'
        THEN 'South Dakota'

    WHEN UPPER(TRIM(state)) = 'TN' OR LOWER(TRIM(state)) = 'tennessee'
        THEN 'Tennessee'

    WHEN UPPER(TRIM(state)) = 'TX' OR LOWER(TRIM(state)) = 'texas'
        THEN 'Texas'

    WHEN UPPER(TRIM(state)) = 'UT' OR LOWER(TRIM(state)) = 'utah'
        THEN 'Utah'

    WHEN UPPER(TRIM(state)) = 'VT' OR LOWER(TRIM(state)) = 'vermont'
        THEN 'Vermont'

    WHEN UPPER(TRIM(state)) = 'VA' OR LOWER(TRIM(state)) = 'virginia'
        THEN 'Virginia'

    WHEN UPPER(TRIM(state)) = 'WA' OR LOWER(TRIM(state)) = 'washington'
        THEN 'Washington'

    WHEN UPPER(TRIM(state)) = 'WV' OR LOWER(TRIM(state)) = 'west virginia'
        THEN 'West Virginia'

    WHEN UPPER(TRIM(state)) = 'WI' OR LOWER(TRIM(state)) = 'wisconsin'
        THEN 'Wisconsin'

    WHEN UPPER(TRIM(state)) = 'WY' OR LOWER(TRIM(state)) = 'wyoming'
        THEN 'Wyoming'

    WHEN UPPER(TRIM(state)) = 'DC'
        THEN 'District of Columbia'

    WHEN UPPER(TRIM(state)) = 'GU'
        THEN 'Guam'

    WHEN UPPER(TRIM(state)) = 'MP'
        THEN 'Northern Mariana Islands'

    WHEN UPPER(TRIM(state)) = 'VI'
        THEN 'U.S. Virgin Islands'

    WHEN UPPER(TRIM(state)) = 'AS'
        THEN 'American Samoa'

    WHEN UPPER(TRIM(state)) = 'MH'
        THEN 'Marshall Islands'

    WHEN UPPER(TRIM(state)) = 'FM'
        THEN 'Micronesia'

    WHEN UPPER(TRIM(state)) = 'PW'
        THEN 'Palau'

    ELSE TRIM(state)
END AS state,
--city
CASE
    WHEN city IS NULL
         OR LOWER(TRIM(city)) IN ('', 'n/a', 'na', 'none', 'null')
    THEN NULL
    ELSE lower(TRIM(city ))
END AS city,
--zip_code
CASE
    WHEN zip_code IS NULL
         OR LOWER(TRIM(zip_code)) IN ('', 'n/a', 'na', 'none', 'null')
    THEN NULL
    ELSE LEFT(TRIM(zip_code), 5)
END AS zip_code
FROM raw_patients;

------------------------------------------------------------------------------------------------------

SELECT 

from raw_patients
order by try_strptime(date_of_birth, '%d-%m-%Y')

SELECT
    patient_id,
    date_of_birth AS raw_dob,

    CASE
        WHEN date_of_birth IS NULL
             OR LOWER(TRIM(date_of_birth)) IN ('', 'n/a', 'na', 'none', 'null')
        THEN NULL

        ELSE STRFTIME(
            COALESCE(
                TRY_STRPTIME(TRIM(date_of_birth), '%Y-%m-%d'),
                TRY_STRPTIME(TRIM(date_of_birth), '%d-%b-%Y'),
                TRY_STRPTIME(TRIM(date_of_birth), '%B %d, %Y'),
                TRY_STRPTIME(TRIM(date_of_birth), '%m-%d-%y'),
                TRY_STRPTIME(TRIM(date_of_birth), '%m/%d/%Y')
            ),
            '%d-%m-%Y'
        )
    END AS date_of_birth

FROM raw_patients
ORDER BY TRY_STRPTIME(date_of_birth, '%d-%m-%Y');

SELECT
--PatientID
    patient_id,
--FullName
    TRIM(full_name) AS full_name,
--Gender
    CASE
        WHEN LOWER(TRIM(gender)) IN ('m', 'male') THEN 'Male'
        WHEN LOWER(TRIM(gender)) IN ('f', 'female') THEN 'Female'
        WHEN LOWER(TRIM(gender)) IN ('o', 'other') THEN 'Other'
        ELSE NULL
    END AS gender,phone,
--PhoneNumber 
       CASE
        WHEN phone IS NULL THEN NULL
        WHEN LOWER(TRIM(phone)) IN ('', 'n/a', 'na', 'unknown', 'none') THEN NULL
        ELSE regexp_replace(
            TRIM(phone),
            '[^0-9]',
            '',
            'g'
        )
    END AS phone_clean, email,
--Email
       CASE
    WHEN email IS NULL THEN NULL
    WHEN LOWER(TRIM(email))
        IN ('', 'n/a', 'na', 'unknown', 'none')
        THEN NULL
    ELSE
        REPLACE(
            REPLACE(
                REPLACE(
                    REPLACE(
                        REPLACE(
                            REPLACE(
                                REPLACE(
                                    LOWER(TRIM(email)),
                                    ',', '.'
                                ),
                                ' at ', '@'
                            ),
                            'gmial', 'gmail'
                        ),
                        'gamil', 'gmail'
                    ),
                    'hotmial', 'hotmail'
                ),
                'yaho', 'yahoo'
            ),
            'outlok', 'outlook'
        )
    END AS email_clean, date_of_birth,
--DateOfBirth
    strftime(   COALESCE(
        try_strptime(TRIM(date_of_birth), '%Y-%m-%d'),
        try_strptime(TRIM(date_of_birth), '%d-%b-%Y'),
        try_strptime(TRIM(date_of_birth), '%B %d, %Y'),
        try_strptime(TRIM(date_of_birth), '%m-%d-%y'),
        try_strptime(TRIM(date_of_birth), '%m/%d/%Y')
        ),
        '%d-%m-%Y'
    ) AS date_of_birth_clean,registration_date,
--registration_date
CASE
    -- MM-DD-YY
    WHEN regexp_full_match(
        TRIM(registration_date),
        '^[0-9]{2}-[0-9]{2}-[0-9]{2}$'
    )
    THEN strftime(
        make_date(
            2000 + CAST(RIGHT(TRIM(registration_date), 2) AS INTEGER),
            CAST(LEFT(TRIM(registration_date), 2) AS INTEGER),
            CAST(SUBSTRING(TRIM(registration_date), 4, 2) AS INTEGER)
        ),
        '%d-%m-%Y'
    )
    ELSE strftime(
        COALESCE(
            -- YYYY-MM-DD
            try_strptime(TRIM(registration_date),'%Y-%m-%d'
            ),
            -- MM/DD/YYYY
            try_strptime(TRIM(registration_date),'%m/%d/%Y'
            ),
            -- DD-Mon-YYYY
            try_strptime(TRIM(registration_date),
                '%d-%b-%Y'
            ),
            -- Month DD, YYYY
            try_strptime(TRIM(registration_date),
                '%B %d, %Y'
            ),
            -- Mon DD, YYYY
            try_strptime(TRIM(registration_date),
                '%b %d, %Y'
            )
        ),
        '%d-%m-%Y'
    )
END AS registration_date_clean,insurance_provider,
--InsuranceProvider
CASE
    WHEN insurance_provider IS NULL
        OR LOWER(TRIM(insurance_provider)) IN ('', 'n/a', 'none', 'null')
        THEN NULL
    WHEN LOWER(TRIM(insurance_provider)) = 'medicaid'
        THEN 'Medicaid'
    WHEN LOWER(TRIM(insurance_provider)) IN (
        'medicare',
        'medi-care'
    )
        THEN 'Medicare'
    WHEN LOWER(TRIM(insurance_provider)) IN (
        'unitedhealth',
        'uhc',
        'united health'
    )
        THEN 'UnitedHealth'
    WHEN LOWER(TRIM(insurance_provider)) IN (
        'bluecross',
        'blue-cross',
        'blue cross'
    )
        THEN 'BlueCross'

    WHEN LOWER(TRIM(insurance_provider)) IN (
        'cigna',
        'cigna health'
    )
        THEN 'Cigna'

    WHEN LOWER(TRIM(insurance_provider)) IN (
        'aetna',
        'aetnaa',
        'aetna inc.'
    )
        THEN 'Aetna'

    WHEN LOWER(TRIM(insurance_provider)) IN (
        'self-pay',
        'self pay'
    )
        THEN 'Self-Pay'
    ELSE TRIM(insurance_provider)
END AS insurance_provider_clean,state,
--State
CASE
    WHEN state IS NULL THEN NULL

    WHEN UPPER(TRIM(state)) = 'AL' OR LOWER(TRIM(state)) = 'alabama'
        THEN 'Alabama'

    WHEN UPPER(TRIM(state)) = 'AK' OR LOWER(TRIM(state)) = 'alaska'
        THEN 'Alaska'

    WHEN UPPER(TRIM(state)) = 'AZ' OR LOWER(TRIM(state)) = 'arizona'
        THEN 'Arizona'

    WHEN UPPER(TRIM(state)) = 'AR' OR LOWER(TRIM(state)) = 'arkansas'
        THEN 'Arkansas'

    WHEN UPPER(TRIM(state)) = 'CA' OR LOWER(TRIM(state)) = 'california'
        THEN 'California'

    WHEN UPPER(TRIM(state)) = 'CO' OR LOWER(TRIM(state)) = 'colorado'
        THEN 'Colorado'

    WHEN UPPER(TRIM(state)) = 'CT' OR LOWER(TRIM(state)) = 'connecticut'
        THEN 'Connecticut'

    WHEN UPPER(TRIM(state)) = 'DE' OR LOWER(TRIM(state)) = 'delaware'
        THEN 'Delaware'

    WHEN UPPER(TRIM(state)) = 'FL' OR LOWER(TRIM(state)) = 'florida'
        THEN 'Florida'

    WHEN UPPER(TRIM(state)) = 'GA' OR LOWER(TRIM(state)) = 'georgia'
        THEN 'Georgia'

    WHEN UPPER(TRIM(state)) = 'HI' OR LOWER(TRIM(state)) = 'hawaii'
        THEN 'Hawaii'

    WHEN UPPER(TRIM(state)) = 'ID' OR LOWER(TRIM(state)) = 'idaho'
        THEN 'Idaho'

    WHEN UPPER(TRIM(state)) = 'IL' OR LOWER(TRIM(state)) = 'illinois'
        THEN 'Illinois'

    WHEN UPPER(TRIM(state)) = 'IN' OR LOWER(TRIM(state)) = 'indiana'
        THEN 'Indiana'

    WHEN UPPER(TRIM(state)) = 'IA' OR LOWER(TRIM(state)) = 'iowa'
        THEN 'Iowa'

    WHEN UPPER(TRIM(state)) = 'KS' OR LOWER(TRIM(state)) = 'kansas'
        THEN 'Kansas'

    WHEN UPPER(TRIM(state)) = 'KY' OR LOWER(TRIM(state)) = 'kentucky'
        THEN 'Kentucky'

    WHEN UPPER(TRIM(state)) = 'LA' OR LOWER(TRIM(state)) = 'louisiana'
        THEN 'Louisiana'

    WHEN UPPER(TRIM(state)) = 'ME' OR LOWER(TRIM(state)) = 'maine'
        THEN 'Maine'

    WHEN UPPER(TRIM(state)) = 'MD' OR LOWER(TRIM(state)) = 'maryland'
        THEN 'Maryland'

    WHEN UPPER(TRIM(state)) = 'MA' OR LOWER(TRIM(state)) = 'massachusetts'
        THEN 'Massachusetts'

    WHEN UPPER(TRIM(state)) = 'MI' OR LOWER(TRIM(state)) = 'michigan'
        THEN 'Michigan'

    WHEN UPPER(TRIM(state)) = 'MN' OR LOWER(TRIM(state)) = 'minnesota'
        THEN 'Minnesota'

    WHEN UPPER(TRIM(state)) = 'MS' OR LOWER(TRIM(state)) = 'mississippi'
        THEN 'Mississippi'

    WHEN UPPER(TRIM(state)) = 'MO' OR LOWER(TRIM(state)) = 'missouri'
        THEN 'Missouri'

    WHEN UPPER(TRIM(state)) = 'MT' OR LOWER(TRIM(state)) = 'montana'
        THEN 'Montana'

    WHEN UPPER(TRIM(state)) = 'NE' OR LOWER(TRIM(state)) = 'nebraska'
        THEN 'Nebraska'

    WHEN UPPER(TRIM(state)) = 'NV' OR LOWER(TRIM(state)) = 'nevada'
        THEN 'Nevada'

    WHEN UPPER(TRIM(state)) = 'NH' OR LOWER(TRIM(state)) = 'new hampshire'
        THEN 'New Hampshire'

    WHEN UPPER(TRIM(state)) = 'NJ' OR LOWER(TRIM(state)) = 'new jersey'
        THEN 'New Jersey'

    WHEN UPPER(TRIM(state)) = 'NM' OR LOWER(TRIM(state)) = 'new mexico'
        THEN 'New Mexico'

    WHEN UPPER(TRIM(state)) = 'NY' OR LOWER(TRIM(state)) = 'new york'
        THEN 'New York'

    WHEN UPPER(TRIM(state)) = 'NC' OR LOWER(TRIM(state)) = 'north carolina'
        THEN 'North Carolina'

    WHEN UPPER(TRIM(state)) = 'ND' OR LOWER(TRIM(state)) = 'north dakota'
        THEN 'North Dakota'

    WHEN UPPER(TRIM(state)) = 'OH' OR LOWER(TRIM(state)) = 'ohio'
        THEN 'Ohio'

    WHEN UPPER(TRIM(state)) = 'OK' OR LOWER(TRIM(state)) = 'oklahoma'
        THEN 'Oklahoma'

    WHEN UPPER(TRIM(state)) = 'OR' OR LOWER(TRIM(state)) = 'oregon'
        THEN 'Oregon'

    WHEN UPPER(TRIM(state)) = 'PA' OR LOWER(TRIM(state)) = 'pennsylvania'
        THEN 'Pennsylvania'

    WHEN UPPER(TRIM(state)) = 'RI' OR LOWER(TRIM(state)) = 'rhode island'
        THEN 'Rhode Island'

    WHEN UPPER(TRIM(state)) = 'SC' OR LOWER(TRIM(state)) = 'south carolina'
        THEN 'South Carolina'

    WHEN UPPER(TRIM(state)) = 'SD' OR LOWER(TRIM(state)) = 'south dakota'
        THEN 'South Dakota'

    WHEN UPPER(TRIM(state)) = 'TN' OR LOWER(TRIM(state)) = 'tennessee'
        THEN 'Tennessee'

    WHEN UPPER(TRIM(state)) = 'TX' OR LOWER(TRIM(state)) = 'texas'
        THEN 'Texas'

    WHEN UPPER(TRIM(state)) = 'UT' OR LOWER(TRIM(state)) = 'utah'
        THEN 'Utah'

    WHEN UPPER(TRIM(state)) = 'VT' OR LOWER(TRIM(state)) = 'vermont'
        THEN 'Vermont'

    WHEN UPPER(TRIM(state)) = 'VA' OR LOWER(TRIM(state)) = 'virginia'
        THEN 'Virginia'

    WHEN UPPER(TRIM(state)) = 'WA' OR LOWER(TRIM(state)) = 'washington'
        THEN 'Washington'

    WHEN UPPER(TRIM(state)) = 'WV' OR LOWER(TRIM(state)) = 'west virginia'
        THEN 'West Virginia'

    WHEN UPPER(TRIM(state)) = 'WI' OR LOWER(TRIM(state)) = 'wisconsin'
        THEN 'Wisconsin'

    WHEN UPPER(TRIM(state)) = 'WY' OR LOWER(TRIM(state)) = 'wyoming'
        THEN 'Wyoming'

    WHEN UPPER(TRIM(state)) = 'DC'
        THEN 'District of Columbia'

    WHEN UPPER(TRIM(state)) = 'GU'
        THEN 'Guam'

    WHEN UPPER(TRIM(state)) = 'MP'
        THEN 'Northern Mariana Islands'

    WHEN UPPER(TRIM(state)) = 'VI'
        THEN 'U.S. Virgin Islands'

    WHEN UPPER(TRIM(state)) = 'AS'
        THEN 'American Samoa'

    WHEN UPPER(TRIM(state)) = 'MH'
        THEN 'Marshall Islands'

    WHEN UPPER(TRIM(state)) = 'FM'
        THEN 'Micronesia'

    WHEN UPPER(TRIM(state)) = 'PW'
        THEN 'Palau'

    ELSE TRIM(state)
END AS state_clean,city,
--city
CASE
    WHEN city IS NULL
         OR LOWER(TRIM(city)) IN ('', 'n/a', 'na', 'none', 'null')
    THEN NULL
    ELSE lower(TRIM(city ))
END AS city_clean,zip_code,
--zip_code
CASE
    WHEN zip_code IS NULL
         OR LOWER(TRIM(zip_code)) IN ('', 'n/a', 'na', 'none', 'null')
    THEN NULL
    ELSE LEFT(TRIM(zip_code), 5)
END AS zip_code_clean
FROM raw_patients;






















