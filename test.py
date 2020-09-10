import pandas as pd

candidates_jobs_data = pd.read_csv("naukri_com-job_sample.csv")
job_titles = list(candidates_jobs_data["jobtitle"])
print(job_titles)
