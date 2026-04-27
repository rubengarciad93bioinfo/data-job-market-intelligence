CREATE OR REPLACE VIEW data_role_postings_clean AS
SELECT
    *,

    CASE
        WHEN remote_allowed = 1 THEN 'Explicit remote allowed'
        ELSE 'Not specified'
    END AS remote_status,

    CASE
        WHEN normalized_salary IS NULL THEN NULL

        WHEN pay_period = 'YEARLY'
             AND normalized_salary BETWEEN 15 AND 300
             AND normalized_salary * 2080 BETWEEN 30000 AND 350000
            THEN normalized_salary * 2080

        WHEN normalized_salary BETWEEN 30000 AND 350000
            THEN normalized_salary

        ELSE NULL
    END AS annual_salary_clean,

    CASE
        WHEN normalized_salary IS NULL THEN 'no_salary'

        WHEN pay_period = 'YEARLY'
             AND normalized_salary BETWEEN 15 AND 300
             AND normalized_salary * 2080 BETWEEN 30000 AND 350000
            THEN 'annualized_from_likely_hourly_mislabeled_as_yearly'

        WHEN normalized_salary BETWEEN 30000 AND 350000
            THEN 'valid'

        WHEN normalized_salary < 30000
            THEN 'too_low_or_mislabeled'

        WHEN normalized_salary > 350000
            THEN 'too_high_or_outlier'

        ELSE 'review'
    END AS salary_quality_flag

FROM data_role_postings;


CREATE OR REPLACE VIEW data_job_text_skills AS
WITH job_text AS (
    SELECT
        job_id,
        role_category,
        lower(
            coalesce(title, '') || ' ' ||
            coalesce(description, '') || ' ' ||
            coalesce(skills_desc, '')
        ) AS text_blob
    FROM data_role_postings_clean
),

skill_patterns AS (
    SELECT *
    FROM (
        VALUES
            ('SQL', '(^|[^a-z0-9])sql([^a-z0-9]|$)|postgres|postgresql|mysql|sqlite|sql server|snowflake|bigquery|redshift'),
            ('Python', '(^|[^a-z0-9])python([^a-z0-9]|$)|pandas|numpy|scikit-learn|sklearn'),
            ('R', '(^|[^a-z0-9])r([^a-z0-9]|$)|r programming|rstudio|tidyverse|ggplot|shiny'),
            ('Excel', '(^|[^a-z0-9])excel([^a-z0-9]|$)|spreadsheet|spreadsheets|microsoft excel'),
            ('Tableau', '(^|[^a-z0-9])tableau([^a-z0-9]|$)'),
            ('Power BI', 'power bi|powerbi'),
            ('Machine Learning', 'machine learning|deep learning|predictive model|classification model|regression model'),
            ('Statistics / Experimentation', 'statistics|statistical|hypothesis testing|experiment|a/b test|ab test'),
            ('AWS', '(^|[^a-z0-9])aws([^a-z0-9]|$)|amazon web services'),
            ('Azure', '(^|[^a-z0-9])azure([^a-z0-9]|$)'),
            ('GCP', '(^|[^a-z0-9])gcp([^a-z0-9]|$)|google cloud'),
            ('Spark / Databricks', '(^|[^a-z0-9])spark([^a-z0-9]|$)|pyspark|databricks'),
            ('Airflow', '(^|[^a-z0-9])airflow([^a-z0-9]|$)'),
            ('Docker / Kubernetes', '(^|[^a-z0-9])docker([^a-z0-9]|$)|kubernetes'),
            ('Git', '(^|[^a-z0-9])git([^a-z0-9]|$)|github|gitlab|bitbucket')
    ) AS patterns(skill, regex_pattern)
)

SELECT
    jt.job_id,
    jt.role_category,
    sp.skill
FROM job_text AS jt
CROSS JOIN skill_patterns AS sp
WHERE regexp_matches(jt.text_blob, sp.regex_pattern);
