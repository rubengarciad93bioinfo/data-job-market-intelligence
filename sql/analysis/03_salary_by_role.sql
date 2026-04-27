SELECT
    role_category,
    COUNT(*) AS n_jobs_with_salary,
    ROUND(median(normalized_salary), 0) AS median_salary,
    ROUND(avg(normalized_salary), 0) AS mean_salary,
    ROUND(min(normalized_salary), 0) AS min_salary,
    ROUND(max(normalized_salary), 0) AS max_salary
FROM data_role_postings
WHERE normalized_salary IS NOT NULL
GROUP BY role_category
ORDER BY median_salary DESC;
