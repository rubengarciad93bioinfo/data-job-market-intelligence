SELECT
    role_category,
    pay_period,
    COUNT(*) AS n_jobs,
    COUNT(normalized_salary) AS n_with_salary,
    ROUND(MIN(normalized_salary), 2) AS min_salary,
    ROUND(quantile_cont(normalized_salary, 0.01), 2) AS p01_salary,
    ROUND(quantile_cont(normalized_salary, 0.05), 2) AS p05_salary,
    ROUND(quantile_cont(normalized_salary, 0.25), 2) AS p25_salary,
    ROUND(MEDIAN(normalized_salary), 2) AS median_salary,
    ROUND(quantile_cont(normalized_salary, 0.75), 2) AS p75_salary,
    ROUND(quantile_cont(normalized_salary, 0.95), 2) AS p95_salary,
    ROUND(quantile_cont(normalized_salary, 0.99), 2) AS p99_salary,
    ROUND(MAX(normalized_salary), 2) AS max_salary
FROM data_role_postings
WHERE normalized_salary IS NOT NULL
GROUP BY role_category, pay_period
ORDER BY role_category, pay_period;
