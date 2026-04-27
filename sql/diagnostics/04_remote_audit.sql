SELECT
    role_category,
    remote_allowed,
    formatted_work_type,
    COUNT(*) AS n_jobs
FROM data_role_postings
GROUP BY role_category, remote_allowed, formatted_work_type
ORDER BY role_category, remote_allowed, n_jobs DESC;
