-- Initial SQL exploration

-- Count rows
SELECT COUNT(*) AS n_rows
FROM jobs;

-- Preview rows
SELECT *
FROM jobs
LIMIT 10;

-- Most frequent job titles
SELECT
    title,
    COUNT(*) AS n_jobs
FROM jobs
GROUP BY title
ORDER BY n_jobs DESC
LIMIT 20;
