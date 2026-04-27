from pathlib import Path
import duckdb

PROJECT_DIR = Path("/Users/rubensiok/data_scientist_porfolio")
DB_PATH = PROJECT_DIR / "data" / "processed" / "job_market.duckdb"
SQL_DIR = PROJECT_DIR / "sql" / "diagnostics"
OUTPUT_DIR = PROJECT_DIR / "outputs" / "diagnostics"

def main() -> None:
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

    con = duckdb.connect(str(DB_PATH))

    sql_files = sorted(SQL_DIR.glob("*.sql"))

    for sql_file in sql_files:
        query_name = sql_file.stem
        query = sql_file.read_text()

        print("")
        print("=" * 100)
        print(query_name)
        print("=" * 100)

        df = con.execute(query).fetchdf()
        print(df.to_string(index=False))

        output_path = OUTPUT_DIR / f"{query_name}.csv"
        df.to_csv(output_path, index=False)
        print(f"\nSaved: {output_path.relative_to(PROJECT_DIR)}")

    con.close()

if __name__ == "__main__":
    main()
