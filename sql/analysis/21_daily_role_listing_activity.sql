WITH dated_jobs AS (
    SELECT
        job_id,
        role_category,
        CAST(epoch_ms(CAST(original_listed_time AS BIGINT)) AS DATE) AS original_listed_date
    FROM data_role_postings_clean
    WHERE original_listed_time IS NOT NULL
)

SELECT
    original_listed_date,
    role_category,
    COUNT(DISTINCT job_id) AS n_jobs
FROM dated_jobs
GROUP BY original_listed_date, role_category
ORDER BY original_listed_date, role_category;
