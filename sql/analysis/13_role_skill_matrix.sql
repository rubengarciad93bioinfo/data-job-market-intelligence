WITH role_totals AS (
    SELECT
        role_category,
        COUNT(DISTINCT job_id) AS total_jobs
    FROM data_role_postings_clean
    GROUP BY role_category
),

skill_counts AS (
    SELECT
        role_category,
        skill,
        COUNT(DISTINCT job_id) AS n_jobs
    FROM data_job_text_skills
    GROUP BY role_category, skill
)

SELECT
    sc.role_category,
    sc.skill,
    sc.n_jobs,
    rt.total_jobs,
    ROUND(100.0 * sc.n_jobs / rt.total_jobs, 2) AS pct_jobs_in_role
FROM skill_counts AS sc
JOIN role_totals AS rt
    ON sc.role_category = rt.role_category
ORDER BY sc.role_category, pct_jobs_in_role DESC;
