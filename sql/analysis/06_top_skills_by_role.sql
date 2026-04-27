WITH skill_counts AS (
    SELECT
        role_category,
        skill_name,
        COUNT(DISTINCT job_id) AS n_jobs
    FROM data_job_skills
    WHERE skill_name IS NOT NULL
    GROUP BY role_category, skill_name
),

ranked_skills AS (
    SELECT
        role_category,
        skill_name,
        n_jobs,
        ROW_NUMBER() OVER (
            PARTITION BY role_category
            ORDER BY n_jobs DESC
        ) AS skill_rank
    FROM skill_counts
)

SELECT
    role_category,
    skill_rank,
    skill_name,
    n_jobs
FROM ranked_skills
WHERE skill_rank <= 10
ORDER BY role_category, skill_rank;
