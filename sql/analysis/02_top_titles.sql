SELECT
    title,
    COUNT(*) AS n_jobs
FROM data_role_postings
GROUP BY title
ORDER BY n_jobs DESC
LIMIT 30;
