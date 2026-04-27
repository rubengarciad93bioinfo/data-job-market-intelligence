WITH dated_jobs AS (
    SELECT
        job_id,
        role_category,
        date_trunc(
            'month',
            CAST(epoch_ms(CAST(listed_time AS BIGINT)) AS DATE)
        ) AS listed_month
    FROM data_role_postings_clean
    WHERE listed_time IS NOT NULL
)

SELECT
    listed_month,
    role_category,
    COUNT(DISTINCT job_id) AS n_jobs
FROM dated_jobs
GROUP BY listed_month, role_category
ORDER BY listed_month, role_category;
