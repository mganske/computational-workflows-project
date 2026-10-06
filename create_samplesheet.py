import pandas as pd
from pathlib import Path

fastq_dir = Path("data")
# discover/list the files, e.g. via glob
fastq_files = sorted(fastq_dir.glob("*.fastq.gz"))

# build rows matching the schema's expected columns
data = {"sample": [], "fastq_1": [], "fastq_2": []}

sample = None
fastq_1 = None
fastq_2 = None

for file in fastq_files:
    sample = str(file.name).split("_")[0]
    if sample not in data["sample"]:
        data["sample"].append(sample)
    if str(file.name).split("_")[2].startswith("1"):
        fastq_1 = str(file)
        data["fastq_1"].append(fastq_1)
    elif str(file.name).split("_")[2].startswith("2"):
        fastq_2 = str(file)
        data["fastq_2"].append(fastq_2)

new_df = pd.DataFrame.from_dict(data)
new_df.to_csv("assets/samplesheet.csv", index=False)