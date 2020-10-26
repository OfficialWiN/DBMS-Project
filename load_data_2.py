import random

import pandas as pd
import pyodbc

connection1 = pyodbc.connect("DSN=DBMS_Sqlsrv;UID=SA;PWD=Mssqlani123")
mycursor1 = connection1.cursor()

connection2 = pyodbc.connect("DSN=DBMS_Mysql;UID=anirudh")
mycursor2 = connection2.cursor()


NUM_INTERVIEWERS = int(1e3)
NUM_JOBS = int(1e4)


def clean_list(s):
    return [i.lower().strip() for i in list(map(str, s))]


def maketables():
    candidates_jobs_data = pd.read_csv("naukri_com-job_sample.csv")
    candidate_name = clean_list(open("candidate_names.txt").readlines())
    job_titles = clean_list(candidates_jobs_data["jobtitle"])
    job_locations = clean_list(candidates_jobs_data["joblocation_address"])
    job_descriptions = clean_list(candidates_jobs_data["jobdescription"])
    job_desc_map = dict((i, 0) for i in job_titles)

    args_interviewer = []
    args_jobdetails = []
    args_jobrole = []
    sql_interviewer = "INSERT INTO INTERVIEWER(EMPLOYEE_NAME) VALUES (?)"
    sql_jobdetails = (
        "INSERT INTO JOB_DETAILS(JOB_TITLE,JOB_LOCATION,FILLED) VALUES (?,?,?)"
    )
    sql_jobrole = "INSERT INTO JOB_ROLE(JOB_TITLE,JOB_DESCRIPTION) VALUES (?,?)"

    interviewer_id = []

    for i in range(1, NUM_JOBS):
        if len(job_titles[i]) < 100:
            for location in job_locations[i].split(","):
                args_jobdetails.append((job_titles[i], location.strip(), 0))
            if job_desc_map[job_titles[i]] == 0:
                args_jobrole.append(
                    (job_titles[i], job_descriptions[i][41 : 41 + 8000])
                )
                job_desc_map[job_titles[i]] = 1
        if len(interviewer_id) < NUM_INTERVIEWERS:
            while 1:
                curinterviewer_id = random.choice(candidate_name)
                if curinterviewer_id not in interviewer_id:
                    break
            args_interviewer.append((curinterviewer_id,))
            interviewer_id.append(curinterviewer_id)
    print("Loaded job details, job description and interviewer args")

    mycursor1.executemany(sql_jobdetails, args_jobdetails)
    mycursor1.executemany(sql_jobrole, args_jobrole)
    mycursor2.executemany(sql_interviewer, args_interviewer)
    connection.commit()

maketables()
