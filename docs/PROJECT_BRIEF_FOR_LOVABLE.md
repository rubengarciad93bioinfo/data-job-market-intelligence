# Data & AI Job Market Intelligence Dashboard

## Project goal

Build a professional portfolio case study showing how SQL, Python and data analysis can be used to understand the Data / AI job market.

The project analyses LinkedIn job postings and focuses on:

- Role categories: Data Analytics, Data Science, Data Engineering, Machine Learning / AI, Business Intelligence.
- Technical skill demand: SQL, Python, R, Excel, Power BI, Tableau, AWS, Azure, GCP, Spark / Databricks, Airflow, Docker / Kubernetes, Git.
- Salary patterns using cleaned annual salary information.
- Explicit remote-work availability.
- Role-specific skill specialization.

## Important data note

The original Kaggle dataset is not included in the web app because it is large. The web app should use the processed aggregate outputs in `outputs/tables/` and figures in `outputs/figures/`.

## Main findings

1. Data Analytics represents the largest share of detected data-related postings: 50.75%.
2. Data Engineering represents 20.91%, Data Science 12.18%, Machine Learning / AI 9.03%, and Business Intelligence 7.14%.
3. Among postings with usable cleaned salary information, Machine Learning / AI has the highest median salary, followed by Data Science and Data Engineering.
4. SQL is the most frequently detected technical skill, appearing in 51.90% of data-related postings.
5. Python appears in 42.91% of data-related postings.
6. Business Intelligence roles are especially associated with SQL, Power BI and Tableau.
7. Data Science roles are associated with Python, machine learning, statistics and R.
8. Data Engineering roles are associated with SQL, Python, cloud platforms and Spark / Databricks.
9. `remote_allowed` should be interpreted as "explicit remote allowed", not as a complete remote vs non-remote variable, because missing values mean "not specified".
10. Salary analysis uses a cleaned annual salary variable that removes or corrects implausible values.

## Recommended web pages

### 1. Home
A clean landing page explaining the project and its value.

### 2. Executive Summary
Show the main findings with cards:
- Number of analysed data-related postings.
- Largest role category.
- Most common technical skill.
- Highest median salary role.
- Share of postings explicitly allowing remote work.

### 3. Role Market Overview
Use `outputs/tables/12_role_market_summary.csv`.
Show role categories by:
- number of postings,
- market share,
- median salary,
- salary availability,
- explicit remote share.

### 4. Skills Demand
Use `outputs/tables/09_clean_technical_skills.csv`.
Show a ranking of technical skills by frequency.

### 5. Role × Skill Matrix
Use `outputs/tables/13_role_skill_matrix.csv`.
Show how skill demand differs across roles.

### 6. Salary Insights
Use `outputs/tables/08_clean_salary_by_role.csv` and `outputs/tables/11_salary_by_technical_skill.csv`.
Make clear that salary statistics only include postings with cleaned usable salary information.

### 7. Methodology
Explain:
- Raw Kaggle data was loaded into DuckDB.
- SQL views were created to classify data-related roles.
- Technical skills were extracted from job title, description and skills text using regex-based matching.
- Salary data was cleaned to remove or correct implausible values.
- Remote work was interpreted cautiously because missing values mean "not specified".

### 8. GitHub / Technical Details
Link to the GitHub repository and highlight:
- SQL queries in `/sql`.
- Python scripts in `/src`.
- Aggregated outputs in `/outputs/tables`.
- Figures in `/outputs/figures`.

## Design style

Professional, clean and recruiter-friendly. Avoid looking like a Kaggle notebook. It should feel like a market intelligence product.

Use:
- clean dashboard cards,
- simple charts,
- role filters,
- skill filters,
- concise explanations,
- visible caveats about data quality.

