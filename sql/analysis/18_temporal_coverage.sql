WITH dated_jobs AS (
    SELECT
        job_id,
        role_category,
        CAST(epoch_ms(CAST(original_listed_time AS BIGINT)) AS DATE) AS original_listed_date
    FROM data_role_postings_clean
    WHERE original_listed_time IS NOT NULL
)

SELECT
    MIN(original_listed_date) AS first_original_listed_date,
    MAX(original_listed_date) AS last_original_listed_date,
    COUNT(DISTINCT job_id) AS n_jobs_with_original_listed_date,
    COUNT(DISTINCT original_listed_date) AS n_distinct_days,
    COUNT(DISTINCT date_trunc('week', original_listed_date)) AS n_distinct_weeks,
    COUNT(DISTINCT date_trunc('month', original_listed_date)) AS n_distinct_months
FROM dated_jobs;
