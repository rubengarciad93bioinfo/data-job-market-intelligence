WITH role_totals AS (
    SELECT
        role_category,
        COUNT(DISTINCT job_id) AS total_jobs
    FROM data_role_postings_clean
    GROUP BY role_category
),

global_total AS (
    SELECT COUNT(DISTINCT job_id) AS total_jobs
    FROM data_role_postings_clean
),

role_skill_counts AS (
    SELECT
        role_category,
        skill,
        COUNT(DISTINCT job_id) AS role_skill_jobs
    FROM data_job_text_skills
    GROUP BY role_category, skill
),

global_skill_counts AS (
    SELECT
        skill,
        COUNT(DISTINCT job_id) AS global_skill_jobs
    FROM data_job_text_skills
    GROUP BY skill
),

scored AS (
    SELECT
        rsc.role_category,
        rsc.skill,
        rsc.role_skill_jobs,
        rt.total_jobs AS role_total_jobs,
        gsc.global_skill_jobs,
        gt.total_jobs AS global_total_jobs,
        1.0 * rsc.role_skill_jobs / rt.total_jobs AS role_skill_rate,
        1.0 * gsc.global_skill_jobs / gt.total_jobs AS global_skill_rate
    FROM role_skill_counts AS rsc
    JOIN role_totals AS rt
        ON rsc.role_category = rt.role_category
    JOIN global_skill_counts AS gsc
        ON rsc.skill = gsc.skill
    CROSS JOIN global_total AS gt
)

SELECT
    role_category,
    skill,
    role_skill_jobs,
    role_total_jobs,
    ROUND(100.0 * role_skill_rate, 2) AS pct_in_role,
    ROUND(100.0 * global_skill_rate, 2) AS pct_globally,
    ROUND(role_skill_rate / NULLIF(global_skill_rate, 0), 2) AS specialization_index
FROM scored
WHERE role_skill_jobs >= 10
ORDER BY role_category, specialization_index DESC;
