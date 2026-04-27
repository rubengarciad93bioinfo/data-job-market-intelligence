SELECT
    role_category,
    COUNT(*) AS n_jobs,
    COUNT(annual_salary_clean) AS n_jobs_with_clean_salary,
    ROUND(100.0 * COUNT(annual_salary_clean) / COUNT(*), 2) AS pct_with_clean_salary,
    ROUND(MEDIAN(annual_salary_clean), 0) AS median_salary,
    ROUND(AVG(annual_salary_clean), 0) AS mean_salary,
    ROUND(quantile_cont(annual_salary_clean, 0.25), 0) AS p25_salary,
    ROUND(quantile_cont(annual_salary_clean, 0.75), 0) AS p75_salary
FROM data_role_postings_clean
GROUP BY role_category
ORDER BY median_salary DESC;
