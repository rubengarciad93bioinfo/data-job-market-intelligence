SELECT
    salary_quality_flag,
    COUNT(*) AS n_jobs,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct_jobs
FROM data_role_postings_clean
GROUP BY salary_quality_flag
ORDER BY n_jobs DESC;
