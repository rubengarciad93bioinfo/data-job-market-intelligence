from pathlib import Path
import duckdb

PROJECT_DIR = Path("/Users/rubensiok/data_scientist_porfolio")
DB_PATH = PROJECT_DIR / "data" / "processed" / "job_market.duckdb"
VIEWS_DIR = PROJECT_DIR / "sql" / "views"

def main() -> None:
    con = duckdb.connect(str(DB_PATH))

    sql_files = sorted(VIEWS_DIR.glob("*.sql"))

    for sql_file in sql_files:
        print(f"Applying view file: {sql_file.relative_to(PROJECT_DIR)}")
        con.execute(sql_file.read_text())

    print("")
    print("Views available:")
    print(con.execute("SHOW TABLES").fetchdf())

    con.close()

if __name__ == "__main__":
    main()
