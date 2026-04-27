SELECT
    job_id,
    role_category,
    title,
    company_name,
    location,
    pay_period,
    min_salary,
    med_salary,
    max_salary,
    normalized_salary,
    currency,
    formatted_work_type,
    formatted_experience_level,
    job_posting_url
FROM data_role_postings
WHERE normalized_salary IS NOT NULL
  AND normalized_salary > 350000
ORDER BY normalized_salary DESC
LIMIT 100;
