SELECT
    role_category,
    COUNT(*) AS n_jobs,
    SUM(CASE WHEN remote_allowed = 1 THEN 1 ELSE 0 END) AS n_remote_explicit,
    SUM(CASE WHEN remote_allowed = 0 THEN 1 ELSE 0 END) AS n_remote_zero,
    SUM(CASE WHEN remote_allowed IS NULL THEN 1 ELSE 0 END) AS n_remote_unknown,
    ROUND(100.0 * SUM(CASE WHEN remote_allowed = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS pct_explicit_remote,
    ROUND(100.0 * SUM(CASE WHEN remote_allowed IS NULL THEN 1 ELSE 0 END) / COUNT(*), 2) AS pct_unknown
FROM data_role_postings
GROUP BY role_category
ORDER BY pct_explicit_remote DESC;
