SELECT
    role_category,
    COUNT(*) AS n_jobs,
    SUM(CASE WHEN remote_allowed = 1 THEN 1 ELSE 0 END) AS n_remote,
    ROUND(
        100.0 * SUM(CASE WHEN remote_allowed = 1 THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS pct_remote
FROM data_role_postings
GROUP BY role_category
ORDER BY pct_remote DESC;
