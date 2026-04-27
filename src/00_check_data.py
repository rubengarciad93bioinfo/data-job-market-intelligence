from pathlib import Path
import pandas as pd
import duckdb

PROJECT_DIR = Path("/Users/rubensiok/data_scientist_porfolio")
RAW_DIR = PROJECT_DIR / "data" / "raw"

print("Raw data folder:", RAW_DIR)

csv_files = list(RAW_DIR.rglob("*.csv"))

print(f"\nFound {len(csv_files)} CSV files:")
for f in csv_files:
    print("-", f.relative_to(PROJECT_DIR))

if csv_files:
    first_csv = csv_files[0]
    print(f"\nReading first CSV: {first_csv.name}")

    df = pd.read_csv(first_csv, low_memory=False)
    print("\nShape:", df.shape)
    print("\nColumns:")
    print(df.columns.tolist())

    print("\nFirst rows:")
    print(df.head())

    con = duckdb.connect()
    con.register("data", df)

    print("\nSQL test:")
    result = con.sql("""
        SELECT *
        FROM data
        LIMIT 5
    """).df()

    print(result)
else:
    print("\nNo CSV files found yet. Download the Kaggle datasets first.")
