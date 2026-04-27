from pathlib import Path
import pandas as pd

PROJECT_DIR = Path("/Users/rubensiok/data_scientist_porfolio")
OUTPUT_DIR = PROJECT_DIR / "outputs" / "tables"

files_to_review = [
    "01_role_categories.csv",
    "03_salary_by_role.csv",
    "04_remote_by_role.csv",
    "05_top_skills.csv",
    "06_top_skills_by_role.csv",
]

for file_name in files_to_review:
    path = OUTPUT_DIR / file_name

    print("\n" + "=" * 100)
    print(file_name)
    print("=" * 100)

    if not path.exists():
        print(f"Missing file: {path}")
        continue

    df = pd.read_csv(path)
    print(df.to_string(index=False))
