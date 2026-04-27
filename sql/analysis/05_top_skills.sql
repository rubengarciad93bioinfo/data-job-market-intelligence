SELECT
    skill_name,
    COUNT(DISTINCT job_id) AS n_jobs
FROM data_job_skills
WHERE skill_name IS NOT NULL
GROUP BY skill_name
ORDER BY n_jobs DESC
LIMIT 30;
