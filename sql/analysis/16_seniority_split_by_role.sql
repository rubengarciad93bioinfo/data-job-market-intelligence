WITH labeled_jobs AS (
    SELECT
        job_id,
        role_category,
        title,
        formatted_experience_level,
        annual_salary_clean,
        remote_status,

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
)

SELECT
    role_category,
    seniority_level,
    COUNT(*) AS n_jobs,
    ROUND(
        100.0 * COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY role_category),
        2
    ) AS pct_jobs_in_role,
    COUNT(annual_salary_clean) AS n_jobs_with_clean_salary,
    ROUND(MEDIAN(annual_salary_clean), 0) AS median_salary,
    SUM(CASE WHEN remote_status = 'Explicit remote allowed' THEN 1 ELSE 0 END) AS n_remote_explicit,
    ROUND(
        100.0 * SUM(CASE WHEN remote_status = 'Explicit remote allowed' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS pct_remote_explicit
FROM labeled_jobs
GROUP BY role_category, seniority_level
ORDER BY role_category, n_jobs DESC;
