from pathlib import Path
import duckdb

PROJECT_DIR = Path("/Users/rubensiok/data_scientist_porfolio")
RAW_DIR = PROJECT_DIR / "data" / "raw" / "linkedin_job_postings"
DB_PATH = PROJECT_DIR / "data" / "processed" / "job_market.duckdb"
VIEWS_SQL_PATH = PROJECT_DIR / "sql" / "views" / "00_create_analysis_views.sql"

TABLES = {
    "postings": "postings.csv",
    "skills": "mappings/skills.csv",
    "industries": "mappings/industries.csv",
    "benefits": "jobs/benefits.csv",
    "salaries": "jobs/salaries.csv",
    "job_industries": "jobs/job_industries.csv",
    "job_skills": "jobs/job_skills.csv",
    "companies": "companies/companies.csv",
    "company_industries": "companies/company_industries.csv",
    "company_specialities": "companies/company_specialities.csv",
    "employee_counts": "companies/employee_counts.csv",
}

def find_file(relative_path: str) -> Path:
    matches = list(RAW_DIR.rglob(Path(relative_path).name))
    matches = [m for m in matches if str(m).endswith(relative_path)]

    if not matches:
        raise FileNotFoundError(f"Could not find {relative_path}")

    return matches[0]

def main() -> None:
    DB_PATH.parent.mkdir(parents=True, exist_ok=True)

    con = duckdb.connect(str(DB_PATH))

    for table_name, relative_path in TABLES.items():
        csv_path = find_file(relative_path)
        safe_path = str(csv_path).replace("'", "''")

        print(f"Loading table: {table_name}")
        print(f"Source file: {csv_path.relative_to(PROJECT_DIR)}")

        con.execute(f"DROP TABLE IF EXISTS {table_name}")
        con.execute(
            f"""
            CREATE TABLE {table_name} AS
            SELECT *
            FROM read_csv_auto('{safe_path}', header=True)
            """
        )

    print("Creating analytical views from SQL file...")
    views_sql = VIEWS_SQL_PATH.read_text()
    con.execute(views_sql)

    print("")
    print("Database created successfully:")
    print(DB_PATH)

    print("")
    print("Available tables and views:")
    print(con.execute("SHOW TABLES").fetchdf())

    print("")
    print("Total LinkedIn postings:")
    print(con.execute("SELECT COUNT(*) AS n_postings FROM postings").fetchdf())

    print("")
    print("Detected data/analytics postings:")
    print(con.execute("SELECT COUNT(*) AS n_data_postings FROM data_role_postings").fetchdf())

    con.close()

if __name__ == "__main__":
    main()
