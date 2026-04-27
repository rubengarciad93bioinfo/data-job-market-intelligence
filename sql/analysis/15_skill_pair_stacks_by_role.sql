WITH skill_pairs AS (
    SELECT
        a.role_category,
        a.job_id,
        a.skill AS skill_1,
        b.skill AS skill_2,
        a.skill || ' + ' || b.skill AS skill_pair
    FROM data_job_text_skills AS a
    JOIN data_job_text_skills AS b
        ON a.job_id = b.job_id
       AND a.skill < b.skill
),

role_totals AS (
    SELECT
        role_category,
        COUNT(DISTINCT job_id) AS total_jobs
    FROM data_role_postings_clean
    GROUP BY role_category
),

pair_counts AS (
    SELECT
        sp.role_category,
        sp.skill_pair,
        COUNT(DISTINCT sp.job_id) AS n_jobs
    FROM skill_pairs AS sp
    GROUP BY sp.role_category, sp.skill_pair
),

ranked_pairs AS (
    SELECT
        pc.role_category,
        pc.skill_pair,
        pc.n_jobs,
        rt.total_jobs,
        ROUND(100.0 * pc.n_jobs / rt.total_jobs, 2) AS pct_jobs_in_role,
        ROW_NUMBER() OVER (
            PARTITION BY pc.role_category
            ORDER BY pc.n_jobs DESC
        ) AS pair_rank
    FROM pair_counts AS pc
    JOIN role_totals AS rt
        ON pc.role_category = rt.role_category
)

SELECT
    role_category,
    pair_rank,
    skill_pair,
    n_jobs,
    total_jobs,
    pct_jobs_in_role
FROM ranked_pairs
WHERE pair_rank <= 15
ORDER BY role_category, pair_rank;
