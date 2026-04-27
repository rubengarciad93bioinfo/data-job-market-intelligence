WITH job_text AS (
    SELECT
        job_id,
        role_category,
        lower(
            coalesce(title, '') || ' ' ||
            coalesce(description, '') || ' ' ||
            coalesce(skills_desc, '')
        ) AS text_blob
    FROM data_role_postings
),

skill_flags AS (
    SELECT
        job_id,
        role_category,

        regexp_matches(text_blob, '(^|[^a-z0-9])sql([^a-z0-9]|$)|postgres|mysql|sqlite|sql server') AS has_sql,
        regexp_matches(text_blob, 'python|pandas|numpy|scikit-learn|sklearn') AS has_python,
        regexp_matches(text_blob, '(^|[^a-z0-9])r([^a-z0-9]|$)|r programming|tidyverse|ggplot') AS has_r,
        regexp_matches(text_blob, 'tableau') AS has_tableau,
        regexp_matches(text_blob, 'power bi|powerbi') AS has_power_bi,
        regexp_matches(text_blob, 'excel|spreadsheet') AS has_excel,
        regexp_matches(text_blob, 'machine learning|deep learning|predictive model|classification|regression') AS has_ml,
        regexp_matches(text_blob, 'statistics|statistical|hypothesis|experiment|a/b test|ab test') AS has_statistics,
        regexp_matches(text_blob, 'aws|amazon web services') AS has_aws,
        regexp_matches(text_blob, 'azure') AS has_azure,
        regexp_matches(text_blob, 'gcp|google cloud') AS has_gcp,
        regexp_matches(text_blob, 'spark|pyspark|databricks') AS has_spark,
        regexp_matches(text_blob, 'airflow') AS has_airflow,
        regexp_matches(text_blob, 'docker|kubernetes') AS has_docker_kubernetes,
        regexp_matches(text_blob, 'git|github|gitlab') AS has_git
    FROM job_text
),

skill_long AS (
    SELECT role_category, job_id, 'SQL' AS skill FROM skill_flags WHERE has_sql
    UNION ALL SELECT role_category, job_id, 'Python' FROM skill_flags WHERE has_python
    UNION ALL SELECT role_category, job_id, 'R' FROM skill_flags WHERE has_r
    UNION ALL SELECT role_category, job_id, 'Tableau' FROM skill_flags WHERE has_tableau
    UNION ALL SELECT role_category, job_id, 'Power BI' FROM skill_flags WHERE has_power_bi
    UNION ALL SELECT role_category, job_id, 'Excel' FROM skill_flags WHERE has_excel
    UNION ALL SELECT role_category, job_id, 'Machine Learning' FROM skill_flags WHERE has_ml
    UNION ALL SELECT role_category, job_id, 'Statistics / Experimentation' FROM skill_flags WHERE has_statistics
    UNION ALL SELECT role_category, job_id, 'AWS' FROM skill_flags WHERE has_aws
    UNION ALL SELECT role_category, job_id, 'Azure' FROM skill_flags WHERE has_azure
    UNION ALL SELECT role_category, job_id, 'GCP' FROM skill_flags WHERE has_gcp
    UNION ALL SELECT role_category, job_id, 'Spark / Databricks' FROM skill_flags WHERE has_spark
    UNION ALL SELECT role_category, job_id, 'Airflow' FROM skill_flags WHERE has_airflow
    UNION ALL SELECT role_category, job_id, 'Docker / Kubernetes' FROM skill_flags WHERE has_docker_kubernetes
    UNION ALL SELECT role_category, job_id, 'Git' FROM skill_flags WHERE has_git
),

role_totals AS (
    SELECT
        role_category,
        COUNT(DISTINCT job_id) AS total_jobs
    FROM data_role_postings
    GROUP BY role_category
)

SELECT
    sl.role_category,
    sl.skill,
    COUNT(DISTINCT sl.job_id) AS n_jobs,
    rt.total_jobs,
    ROUND(100.0 * COUNT(DISTINCT sl.job_id) / rt.total_jobs, 2) AS pct_jobs_in_role
FROM skill_long AS sl
JOIN role_totals AS rt
    ON sl.role_category = rt.role_category
GROUP BY sl.role_category, sl.skill, rt.total_jobs
ORDER BY sl.role_category, pct_jobs_in_role DESC;
