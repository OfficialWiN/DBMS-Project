import random

import pandas as pd
import pyodbc

connection = pyodbc.connect("DSN=DBMS;UID=SA;PWD=Mssqlani123")
mycursor = connection.cursor()

NUM_CANDIDATES = int(1e6)
NUM_EMPLOYEES = int(8 * 1e3)
NUM_INTERVIEWERS = int(1e3)
NUM_JOBS = int(1e4)


def clean_list(s):
    return [i.lower().strip() for i in list(map(str, s))]


def maketables():
    candidates_jobs_data = pd.read_csv("naukri_com-job_sample.csv")
    skills_data = pd.read_csv("user-languages.csv")
    questions_data = pd.read_csv("questions.csv")

    job_titles = clean_list(candidates_jobs_data["jobtitle"])
    job_locations = clean_list(candidates_jobs_data["joblocation_address"])
    job_descriptions = clean_list(candidates_jobs_data["jobdescription"])
    job_desc_map = dict((i, 0) for i in job_titles)
    candidate_name = clean_list(open("candidate_names.txt").readlines())
    candidateage = list(range(20, 30))
    employeeage = list(range(25, 65))
    question_description = clean_list(questions_data["link"])
    question_difficulty = clean_list(questions_data["level"])
    question_tags = clean_list(questions_data["Tags"])
    question_editorial = clean_list(questions_data["Editorial"])
    skill_name = []
    ctr = 0
    for i in range(1, len(skills_data.columns)):
        if skills_data.columns[i] not in skill_name:
            ctr += 1
            skill_name.append(skills_data.columns[i])
    education = clean_list(candidates_jobs_data["education"])
    experience = clean_list(candidates_jobs_data["experience"])

    args_candidate = []
    args_employee = []
    args_interviewer = []
    args_jobdetails = []
    args_jobrole = []
    args_question = []
    args_questiontags = []
    args_skills = []
    sql_candidate = "INSERT INTO CANDIDATE(CANDIDATE_NAME,CANDIDATE_EXPERIENCE,CANDIDATE_AGE,CANDIDATE_EDUCATION,CANDIDATE_ROLE) VALUES (?,?,?,?,?)"
    sql_employee = "INSERT INTO EMPLOYEE(EMPLOYEE_NAME,EMPLOYEE_AGE,EMPLOYEE_POSITION) VALUES (?,?,?)"
    sql_interviewer = "INSERT INTO INTERVIEWER(EMPLOYEE_ID) VALUES (?)"
    sql_jobdetails = (
        "INSERT INTO JOB_DETAILS(JOB_TITLE,JOB_LOCATION,FILLED) VALUES (?,?,?)"
    )
    sql_jobrole = "INSERT INTO JOB_ROLE(JOB_TITLE,JOB_DESCRIPTION) VALUES (?,?)"
    sql_question = "INSERT INTO QUESTION(QUESTION_DESCRIPTION, QUESTION_EXPLANATION, QUESTION_DIFFICULTY) VALUES (?, ?, ?)"
    sql_questiontags = "INSERT INTO QUESTION_TAGS(QUESTION_ID,TAGS) VALUES (?,?)"
    sql_skills = (
        "INSERT INTO SKILLS(CANDIDATE_ID,SKILL_NAME,SKILL_LEVEL) VALUES (?,?,?)"
    )

    interviewer_id = []

    for i in range(NUM_CANDIDATES):
        if random.choice(education) == "nan":
            ede = None
        else:
            ede = random.choice(education).strip()
        args_candidate.append(
            (
                candidate_name[i].strip(),
                random.choice(experience).strip()[:100],
                random.choice(candidateage),
                ede,
                random.randint(76, 123),
            )
        )
    print("Loaded candidate args")

    for i in range(1, NUM_EMPLOYEES):
        args_employee.append(
            (candidate_name[i + NUM_CANDIDATES].strip(), random.choice(employeeage), i,)
        )
    print("Loaded employee args")

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
                curinterviewer_id = random.randint(1, NUM_EMPLOYEES)
                if curinterviewer_id not in interviewer_id:
                    break
            args_interviewer.append((curinterviewer_id,))
            interviewer_id.append(curinterviewer_id)
    print("Loaded job details, job description and interviewer args")

    for i in range(1, NUM_CANDIDATES):
        w = []
        while len(w) < 3:
            skill = random.randint(1, 1409)
            if skill not in w:
                w.append(skill)
        for j in range(3):
            args_skills.append((i, skill_name[w[j]], random.randint(0, 10)))
    print("Loaded skills args")

    for i in range(1, len(question_description) + 1):
        str1 = ""
        for j in question_tags[i - 1]:
            if j == "[" or j == "]":
                pass
            elif j != ",":
                str1 += j
            else:
                str1 += " "
        str1 = str1.split()
        if question_editorial[i - 1] == "nan":
            ed = None
        else:
            ed = question_editorial[i - 1]
        args_question.append(
            (question_description[i - 1], ed, question_difficulty[i - 1])
        )
        for k in str1:
            args_questiontags.append((i, k))
    print("Loaded question args")

    for job in range(NUM_EMPLOYEES):
        args_jobdetails[job] = (
            args_jobdetails[job][0],
            args_jobdetails[job][1],
            "True",
        )
    print("Finished loading args")

    mycursor.executemany(sql_jobdetails, args_jobdetails)
    mycursor.executemany(sql_jobrole, args_jobrole)
    mycursor.executemany(sql_candidate, args_candidate)
    mycursor.executemany(sql_skills, args_skills)
    mycursor.executemany(sql_employee, args_employee)
    mycursor.executemany(sql_question, args_question)
    mycursor.executemany(sql_interviewer, args_interviewer)
    mycursor.executemany(sql_questiontags, args_questiontags)
    connection.commit()


def makeinterviewtable():
    result = ["SOLVED", "UNSOLVED", "PARTIALLY SOLVED", None]
    interviewerID = list(mycursor.execute("SELECT INTERVIEWER_ID FROM INTERVIEWER"))
    candidates = list(
        mycursor.execute("SELECT CANDIDATE_ID,CANDIDATE_STATUS FROM CANDIDATE")
    )
    q = list(mycursor.execute("SELECT QUESTION_ID FROM QUESTION"))
    interview_candidates = list(range(NUM_CANDIDATES))
    for i in random.sample(interview_candidates, int(7 * 1e5)):
        if candidates[i][1].lower() == "entry recieved":
            curinterviewer = random.choice(interviewerID)
            candidate_ID = candidates[i][0]
            res = random.choice(result)
            if not res:
                score = None
            elif res.lower() == "solved":
                score = 10
            elif res.lower() == "unsolved":
                score = 0
            elif res.lower() == "partially solved":
                score = random.randint(2, 8)
            question_current = []
            for _ in range(random.randint(1, 3)):
                to_insert = random.choice(q)
                if to_insert not in question_current:
                    question_current.append(to_insert)
            sql1 = "INSERT INTO INTERVIEW(CANDIDATE_ID,INTERVIEWER_ID,INTERVIEW_RESULT,INTERVIEW_SCORE) OUTPUT INSERTED.INTERVIEW_ID VALUES (?,?,?,?)"
            mycursor.execute(
                "UPDATE CANDIDATE SET CANDIDATE_STATUS='ONGOING' WHERE CANDIDATE_ID=?",
                candidate_ID,
            )
            interviewid = mycursor.execute(
                sql1, (candidate_ID, curinterviewer[0], res, score)
            ).fetchone()[0]
            sql2 = "INSERT INTO MAP(INTERVIEW_ID,QUESTION_ID) VALUES (?,?)"
            for qid in question_current:
                mycursor.execute(sql2, (interviewid, qid[0]))
    connection.commit()


maketables()
makeinterviewtable()
