SELECT
    role_category,
    COUNT(*) AS n_jobs,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct_jobs
FROM data_role_postings
GROUP BY role_category
ORDER BY n_jobs DESC;
