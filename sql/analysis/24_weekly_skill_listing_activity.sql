WITH top_skills AS (
    SELECT
        skill,
        COUNT(DISTINCT job_id) AS n_jobs
    FROM data_job_text_skills
    GROUP BY skill
    ORDER BY n_jobs DESC
    LIMIT 8
),

dated_jobs AS (
    SELECT
        job_id,
        date_trunc(
            'week',
            CAST(epoch_ms(CAST(original_listed_time AS BIGINT)) AS DATE)
        ) AS original_listed_week
    FROM data_role_postings_clean
    WHERE original_listed_time IS NOT NULL
)

SELECT
    dj.original_listed_week,
    s.skill,
    COUNT(DISTINCT dj.job_id) AS n_jobs
FROM dated_jobs AS dj
JOIN data_job_text_skills AS s
    ON dj.job_id = s.job_id
JOIN top_skills AS ts
    ON s.skill = ts.skill
GROUP BY dj.original_listed_week, s.skill
ORDER BY dj.original_listed_week, n_jobs DESC;
