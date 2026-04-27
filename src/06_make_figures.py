from pathlib import Path
import pandas as pd
import matplotlib.pyplot as plt

PROJECT_DIR = Path("/Users/rubensiok/data_scientist_porfolio")
TABLE_DIR = PROJECT_DIR / "outputs" / "tables"
FIGURE_DIR = PROJECT_DIR / "outputs" / "figures"

FIGURE_DIR.mkdir(parents=True, exist_ok=True)

def save_barh(df, x_col, y_col, title, xlabel, filename):
    plot_df = df.copy()
    plot_df = plot_df.sort_values(x_col, ascending=True)

    plt.figure(figsize=(10, 6))
    plt.barh(plot_df[y_col], plot_df[x_col])
    plt.title(title)
    plt.xlabel(xlabel)
    plt.tight_layout()
    plt.savefig(FIGURE_DIR / filename, dpi=300)
    plt.close()

role_summary = pd.read_csv(TABLE_DIR / "12_role_market_summary.csv")
skills = pd.read_csv(TABLE_DIR / "09_clean_technical_skills.csv")
salary_by_role = pd.read_csv(TABLE_DIR / "08_clean_salary_by_role.csv")
skill_salary = pd.read_csv(TABLE_DIR / "11_salary_by_technical_skill.csv")
skill_matrix = pd.read_csv(TABLE_DIR / "13_role_skill_matrix.csv")

save_barh(
    df=role_summary,
    x_col="n_jobs",
    y_col="role_category",
    title="Number of Data/AI Job Postings by Role Category",
    xlabel="Number of job postings",
    filename="01_jobs_by_role.png"
)

save_barh(
    df=salary_by_role,
    x_col="median_salary",
    y_col="role_category",
    title="Median Clean Annual Salary by Role Category",
    xlabel="Median annual salary",
    filename="02_median_salary_by_role.png"
)

save_barh(
    df=skills.head(15),
    x_col="pct_of_data_jobs",
    y_col="skill",
    title="Most Frequently Mentioned Technical Skills",
    xlabel="% of data-related job postings",
    filename="03_top_technical_skills.png"
)

save_barh(
    df=skill_salary.sort_values("median_salary", ascending=False).head(15),
    x_col="median_salary",
    y_col="skill",
    title="Median Clean Annual Salary by Technical Skill",
    xlabel="Median annual salary",
    filename="04_salary_by_skill.png"
)

pivot = (
    skill_matrix
    .pivot(index="skill", columns="role_category", values="pct_jobs_in_role")
    .fillna(0)
)

ordered_skills = (
    skills.sort_values("pct_of_data_jobs", ascending=False)
    .head(12)["skill"]
    .tolist()
)

pivot = pivot.loc[[s for s in ordered_skills if s in pivot.index]]

plt.figure(figsize=(10, 7))
plt.imshow(pivot.values, aspect="auto")
plt.xticks(range(len(pivot.columns)), pivot.columns, rotation=45, ha="right")
plt.yticks(range(len(pivot.index)), pivot.index)
plt.title("Technical Skill Demand by Role Category")
plt.colorbar(label="% of postings in role")
plt.tight_layout()
plt.savefig(FIGURE_DIR / "05_role_skill_heatmap.png", dpi=300)
plt.close()

print("Figures saved in:")
print(FIGURE_DIR)

for path in sorted(FIGURE_DIR.glob("*.png")):
    print("-", path.relative_to(PROJECT_DIR))
