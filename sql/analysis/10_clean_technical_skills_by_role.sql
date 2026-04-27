WITH role_totals AS (
    SELECT
        role_category,
        COUNT(DISTINCT job_id) AS total_jobs
    FROM data_role_postings_clean
    GROUP BY role_category
)

SELECT
    s.role_category,
    s.skill,
    COUNT(DISTINCT s.job_id) AS n_jobs,
    rt.total_jobs,
    ROUND(100.0 * COUNT(DISTINCT s.job_id) / rt.total_jobs, 2) AS pct_jobs_in_role
FROM data_job_text_skills AS s
JOIN role_totals AS rt
    ON s.role_category = rt.role_category
GROUP BY s.role_category, s.skill, rt.total_jobs
ORDER BY s.role_category, pct_jobs_in_role DESC;
