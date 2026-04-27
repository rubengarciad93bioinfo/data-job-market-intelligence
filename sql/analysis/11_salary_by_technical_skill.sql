SELECT
    s.skill,
    COUNT(DISTINCT p.job_id) AS n_jobs_with_clean_salary,
    ROUND(MEDIAN(p.annual_salary_clean), 0) AS median_salary,
    ROUND(AVG(p.annual_salary_clean), 0) AS mean_salary
FROM data_job_text_skills AS s
JOIN data_role_postings_clean AS p
    ON s.job_id = p.job_id
WHERE p.annual_salary_clean IS NOT NULL
GROUP BY s.skill
HAVING COUNT(DISTINCT p.job_id) >= 20
ORDER BY median_salary DESC;
