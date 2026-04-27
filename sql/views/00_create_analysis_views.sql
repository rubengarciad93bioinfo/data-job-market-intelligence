CREATE OR REPLACE VIEW data_role_postings AS
SELECT
    *,
    CASE
        WHEN regexp_matches(lower(coalesce(title, '')), 'machine learning|ml engineer|ai engineer|artificial intelligence') THEN 'Machine Learning / AI'
        WHEN regexp_matches(lower(coalesce(title, '')), 'data engineer|analytics engineer|etl engineer') THEN 'Data Engineering'
        WHEN regexp_matches(lower(coalesce(title, '')), 'business intelligence|bi analyst|power bi|tableau') THEN 'Business Intelligence'
        WHEN regexp_matches(lower(coalesce(title, '')), 'data scientist|decision scientist') THEN 'Data Science'
        WHEN regexp_matches(lower(coalesce(title, '')), 'data analyst|analytics analyst|product analyst|marketing analyst|business analyst') THEN 'Data Analytics'
        ELSE 'Other'
    END AS role_category
FROM postings
WHERE regexp_matches(
    lower(coalesce(title, '')),
    'data scientist|data analyst|data engineer|machine learning|ml engineer|ai engineer|business intelligence|bi analyst|analytics analyst|analytics engineer|product analyst|marketing analyst|decision scientist|business analyst'
);

CREATE OR REPLACE VIEW data_job_skills AS
SELECT
    p.job_id,
    p.title,
    p.company_name,
    p.location,
    p.formatted_work_type,
    p.formatted_experience_level,
    p.normalized_salary,
    p.remote_allowed,
    p.role_category,
    js.skill_abr,
    s.skill_name
FROM data_role_postings AS p
LEFT JOIN job_skills AS js
    ON p.job_id = js.job_id
LEFT JOIN skills AS s
    ON js.skill_abr = s.skill_abr;
