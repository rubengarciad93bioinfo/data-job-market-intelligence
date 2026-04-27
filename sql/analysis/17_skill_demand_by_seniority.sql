WITH labeled_jobs AS (
    SELECT
        job_id,
        role_category,

        CASE
            WHEN regexp_matches(
                lower(coalesce(title, '')),
                'intern|internship|junior|entry[- ]level|new grad|graduate|trainee|apprentice|(^|[^a-z])jr([^a-z]|$)'
            )
            OR lower(coalesce(formatted_experience_level, '')) IN ('internship', 'entry level')
                THEN 'Junior / Entry'

            WHEN regexp_matches(
                lower(coalesce(title, '')),
                'senior|principal|staff|lead|manager|director|head|vice president|(^|[^a-z])vp([^a-z]|$)|(^|[^a-z])sr[.]?([^a-z]|$)'
            )
                THEN 'Senior / Lead'

            WHEN lower(coalesce(formatted_experience_level, '')) = 'mid-senior level'
                THEN 'Mid-Senior / Unspecified'

            ELSE 'Unspecified'
        END AS seniority_level
    FROM data_role_postings_clean
),

seniority_totals AS (
    SELECT
        role_category,
        seniority_level,
        COUNT(DISTINCT job_id) AS total_jobs
    FROM labeled_jobs
    GROUP BY role_category, seniority_level
),

skill_counts AS (
    SELECT
        lj.role_category,
        lj.seniority_level,
        s.skill,
        COUNT(DISTINCT lj.job_id) AS n_jobs
    FROM labeled_jobs AS lj
    JOIN data_job_text_skills AS s
        ON lj.job_id = s.job_id
    GROUP BY lj.role_category, lj.seniority_level, s.skill
),

ranked AS (
    SELECT
        sc.role_category,
        sc.seniority_level,
        sc.skill,
        sc.n_jobs,
        st.total_jobs,
        ROUND(100.0 * sc.n_jobs / st.total_jobs, 2) AS pct_jobs_in_group,
        ROW_NUMBER() OVER (
            PARTITION BY sc.role_category, sc.seniority_level
            ORDER BY sc.n_jobs DESC
        ) AS skill_rank
    FROM skill_counts AS sc
    JOIN seniority_totals AS st
        ON sc.role_category = st.role_category
       AND sc.seniority_level = st.seniority_level
)

SELECT
    role_category,
    seniority_level,
    skill_rank,
    skill,
    n_jobs,
    total_jobs,
    pct_jobs_in_group
FROM ranked
WHERE skill_rank <= 10
ORDER BY role_category, seniority_level, skill_rank;
