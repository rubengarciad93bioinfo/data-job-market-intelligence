SELECT
    skill,
    COUNT(DISTINCT job_id) AS n_jobs,
    ROUND(
        100.0 * COUNT(DISTINCT job_id) / (SELECT COUNT(*) FROM data_role_postings_clean),
        2
    ) AS pct_of_data_jobs
FROM data_job_text_skills
GROUP BY skill
ORDER BY n_jobs DESC;
