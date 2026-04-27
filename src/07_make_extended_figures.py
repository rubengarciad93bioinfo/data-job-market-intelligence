from pathlib import Path
import pandas as pd
import matplotlib.pyplot as plt

PROJECT_DIR = Path("/Users/rubensiok/data_scientist_porfolio")
TABLE_DIR = PROJECT_DIR / "outputs" / "tables"
FIGURE_DIR = PROJECT_DIR / "outputs" / "figures"

FIGURE_DIR.mkdir(parents=True, exist_ok=True)

# 1. Seniority stacked bars by role
seniority_path = TABLE_DIR / "16_seniority_split_by_role.csv"

if seniority_path.exists():
    seniority = pd.read_csv(seniority_path)

    seniority_pivot = (
        seniority
        .pivot(index="role_category", columns="seniority_level", values="pct_jobs_in_role")
        .fillna(0)
    )

    desired_order = [
        "Junior / Entry",
        "Mid-Senior / Unspecified",
        "Senior / Lead",
        "Unspecified",
    ]

    existing_cols = [c for c in desired_order if c in seniority_pivot.columns]
    seniority_pivot = seniority_pivot[existing_cols]

    seniority_pivot.plot(kind="barh", stacked=True, figsize=(11, 6))

    plt.title("Inferred Seniority Mix by Role Category")
    plt.xlabel("% of postings within role")
    plt.ylabel("")
    plt.legend(title="Seniority level", bbox_to_anchor=(1.02, 1), loc="upper left")
    plt.tight_layout()
    plt.savefig(FIGURE_DIR / "06_seniority_stacked_by_role.png", dpi=300)
    plt.close()

# 2. Monthly role trend as line chart
role_trend_path = TABLE_DIR / "19_monthly_role_trend.csv"

if role_trend_path.exists():
    role_trend = pd.read_csv(role_trend_path)
    role_trend["listed_month"] = pd.to_datetime(role_trend["listed_month"])

    role_pivot = (
        role_trend
        .pivot(index="listed_month", columns="role_category", values="n_jobs")
        .fillna(0)
        .sort_index()
    )

    plt.figure(figsize=(12, 6))

    for column in role_pivot.columns:
        plt.plot(role_pivot.index, role_pivot[column], marker="o", label=column)

    plt.title("Monthly Trend of Data/AI Job Postings by Role Category")
    plt.xlabel("Listed month")
    plt.ylabel("Number of postings")
    plt.legend(title="Role category", bbox_to_anchor=(1.02, 1), loc="upper left")
    plt.xticks(rotation=45)
    plt.tight_layout()
    plt.savefig(FIGURE_DIR / "07_monthly_role_trend.png", dpi=300)
    plt.close()

# 3. Monthly top skill trend as line chart
skill_trend_path = TABLE_DIR / "20_monthly_skill_trend.csv"

if skill_trend_path.exists():
    skill_trend = pd.read_csv(skill_trend_path)
    skill_trend["listed_month"] = pd.to_datetime(skill_trend["listed_month"])

    top_skills = (
        skill_trend
        .groupby("skill", as_index=False)["n_jobs"]
        .sum()
        .sort_values("n_jobs", ascending=False)
        .head(6)["skill"]
        .tolist()
    )

    skill_trend = skill_trend[skill_trend["skill"].isin(top_skills)]

    skill_pivot = (
        skill_trend
        .pivot(index="listed_month", columns="skill", values="n_jobs")
        .fillna(0)
        .sort_index()
    )

    plt.figure(figsize=(12, 6))

    for column in skill_pivot.columns:
        plt.plot(skill_pivot.index, skill_pivot[column], marker="o", label=column)

    plt.title("Monthly Trend of Top Technical Skills")
    plt.xlabel("Listed month")
    plt.ylabel("Number of postings mentioning skill")
    plt.legend(title="Skill", bbox_to_anchor=(1.02, 1), loc="upper left")
    plt.xticks(rotation=45)
    plt.tight_layout()
    plt.savefig(FIGURE_DIR / "08_monthly_skill_trend.png", dpi=300)
    plt.close()

# 4. Top skill-pair stacks
skill_pairs_path = TABLE_DIR / "15_skill_pair_stacks_by_role.csv"

if skill_pairs_path.exists():
    pairs = pd.read_csv(skill_pairs_path)

    top_pairs = (
        pairs
        .sort_values(["role_category", "pair_rank"])
        .groupby("role_category")
        .head(5)
        .copy()
    )

    top_pairs["label"] = top_pairs["role_category"] + " | " + top_pairs["skill_pair"]

    plot_df = top_pairs.sort_values("pct_jobs_in_role", ascending=True)

    plt.figure(figsize=(12, 8))
    plt.barh(plot_df["label"], plot_df["pct_jobs_in_role"])
    plt.title("Top Co-occurring Technical Skill Pairs by Role")
    plt.xlabel("% of postings within role")
    plt.ylabel("")
    plt.tight_layout()
    plt.savefig(FIGURE_DIR / "09_skill_pair_stacks_by_role.png", dpi=300)
    plt.close()

print("Extended figures created:")
for path in sorted(FIGURE_DIR.glob("0*.png")):
    print("-", path.relative_to(PROJECT_DIR))
