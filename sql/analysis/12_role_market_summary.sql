WITH salary_summary AS (
    SELECT
        role_category,
        COUNT(annual_salary_clean) AS n_jobs_with_salary,
        ROUND(MEDIAN(annual_salary_clean), 0) AS median_salary
    FROM data_role_postings_clean
    GROUP BY role_category
),

remote_summary AS (
    SELECT
        role_category,
        SUM(CASE WHEN remote_status = 'Explicit remote allowed' THEN 1 ELSE 0 END) AS n_remote_explicit,
        ROUND(
            100.0 * SUM(CASE WHEN remote_status = 'Explicit remote allowed' THEN 1 ELSE 0 END) / COUNT(*),
            2
        ) AS pct_remote_explicit
    FROM data_role_postings_clean
    GROUP BY role_category
),

role_totals AS (
    SELECT
        role_category,
        COUNT(*) AS n_jobs,
        ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct_market_share
    FROM data_role_postings_clean
    GROUP BY role_category
)

SELECT
    rt.role_category,
    rt.n_jobs,
    rt.pct_market_share,
    ss.n_jobs_with_salary,
    ROUND(100.0 * ss.n_jobs_with_salary / rt.n_jobs, 2) AS pct_with_clean_salary,
    ss.median_salary,
    rs.n_remote_explicit,
    rs.pct_remote_explicit
FROM role_totals AS rt
LEFT JOIN salary_summary AS ss
    ON rt.role_category = ss.role_category
LEFT JOIN remote_summary AS rs
    ON rt.role_category = rs.role_category
ORDER BY rt.n_jobs DESC;
