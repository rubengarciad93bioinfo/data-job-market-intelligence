WITH dated_jobs AS (
    SELECT
        job_id,
        role_category,
        CAST(epoch_ms(CAST(listed_time AS BIGINT)) AS DATE) AS listed_date
    FROM data_role_postings_clean
    WHERE listed_time IS NOT NULL
)

SELECT
    MIN(listed_date) AS first_listed_date,
    MAX(listed_date) AS last_listed_date,
    COUNT(DISTINCT job_id) AS n_jobs_with_date,
    COUNT(DISTINCT date_trunc('month', listed_date)) AS n_months
FROM dated_jobs;
