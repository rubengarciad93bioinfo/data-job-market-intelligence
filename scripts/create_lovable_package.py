from pathlib import Path
import shutil

PROJECT_DIR = Path("/Users/rubensiok/data_scientist_porfolio")
PACKAGE_DIR = PROJECT_DIR / "lovable_package"

if PACKAGE_DIR.exists():
    shutil.rmtree(PACKAGE_DIR)

folders_to_copy = [
    "docs",
    "sql",
    "src",
    "outputs/tables",
    "outputs/figures",
]

for folder in folders_to_copy:
    src = PROJECT_DIR / folder
    dst = PACKAGE_DIR / folder
    if src.exists():
        shutil.copytree(src, dst)

for file_name in ["README.md", "requirements.txt"]:
    src = PROJECT_DIR / file_name
    if src.exists():
        shutil.copy2(src, PACKAGE_DIR / file_name)

print("Lovable package created at:")
print(PACKAGE_DIR)

print("\nPackage contents:")
for path in sorted(PACKAGE_DIR.rglob("*")):
    if path.is_file():
        print("-", path.relative_to(PACKAGE_DIR))
