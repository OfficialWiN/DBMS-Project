    /*
    job details
    1)select using job_id
  2)count of jobs avalilable in diff locations
3)count of titles in each location
 4)count of avalilabe jobs
5)given location , list jobs
6)given job title,list its location
 */
SELECT COUNT(JOB_ID) AS NUMBER_OF_JOBS,LOCATION  /*this query gives number of jobs at each location*/
FROM JOB_DETAILS
GROUP BY LOCATION


SELECT COUNT(LOCATION) AS NUMBER_OF_LOCATIONS,JOB_TITLE /*this query gives number of locations for each job_title*/
FROM JOB_DETAILS
GROUP BY JOB_TITLE

SELECT JOB_ID,JOB_DETAILS.JOB_TITLE,FILLED,LOCATION,JOB_DESCRIPTION
INTO Q
FROM JOB_DETAILS,JOB_ROLE
WHERE JOB_DETAILS.JOB_TITLE=JOB_ROLE.JOB_TITLE;
/*created a table Q which is inner join of JOB_DETAILS and JOB_ROLE*/


SELECT *FROM Q
WHERE LOCATION='Bengaluru';
/*Given a location show all the jobs ,that is job description,job title,job id,location,FILLED*/

SELECT*FROM Q
WHERE JOB_ID=1;
/*Given a JOB_ID show all the jobs ,that is jjob description,job title,job id,location,FILLED*/

SELECT*FROM Q
WHERE JOB_TITLE='PHP Developer';
/*Given a JOB title show all the jobs ,that is  job description,job title,job id,location,FILLED*/


WITH TABLENAME(JOB_ID,JOB_TITLE,FILLED,LOCATION,JOB_DESCRIPTION) AS(
  SELECT JOB_ID,JOB_ROLE.JOB_TITLE,FILLED,LOCATION,JOB_DESCRIPTION FROM JOB_DETAILS,JOB_ROLE
  WHERE JOB_DETAILS.JOB_TITLE=JOB_ROLE.JOB_TITLE
)
SELECT*from TABLENAME
WHERE JOB_ID=1;
/*Given a JOB_ID show all the jobs ,that is  job description,job title,job id,location,FILLED*/
/*the query above does the same thing but using with clause*/
WITH R(JOB_ID,JOB_TITLE,FILLED,LOCATION,JOB_DESCRIPTION) AS(
  SELECT JOB_ID,JOB_ROLE.JOB_TITLE,FILLED,LOCATION,JOB_DESCRIPTION FROM JOB_DETAILS,JOB_ROLE
  WHERE JOB_DETAILS.JOB_TITLE=JOB_ROLE.JOB_TITLE
)
SELECT*from R
WHERE LOCATION='Bengaluru';
/*Given a LOCATION show all the jobs ,that is job description,job title,job id,location,FILLED*/
/*the query above does the same thing but using with clause*/
WITH U(JOB_ID,JOB_TITLE,FILLED,LOCATION,JOB_DESCRIPTION) AS(
  SELECT JOB_ID,JOB_ROLE.JOB_TITLE,FILLED,LOCATION,JOB_DESCRIPTION FROM JOB_DETAILS,JOB_ROLE
  WHERE JOB_DETAILS.JOB_TITLE=JOB_ROLE.JOB_TITLE
)
SELECT*from U
WHERE JOB_TITLE='PHP Developer';
/*Given a JOB_TITLE show all the jobs ,that is job details that is job description,job title,job id,location,FILLED*/
/*the query above does the same thing but using with clause*/

SELECT COUNT(*)
FROM JOB_DETAILS
WHERE FILLED=0;
/*no of available jobs*/

/*job role
1)given title list description*/
SELECT JOB_DESCRIPTION,JOB_TITLE
FROM JOB_ROLE
WHERE JOB_TITLE='PHP Developer';

/*candidate 
1)select by candidate id 
2)count of status of candidates 
eg: ongoing -60
accepted -20
3)no_of candidates for one role
4)count of candidates per age group
5)no of candidates applying at a locations
for eg :
  bombay-35
  delhi - 100
   */


  SELECT * FROM CANDIDATE
  WHERE CANDIDATE_ID=1;
  /*Given candidate_ID selects the candidate profile*/

  SELECT CANDIDATE.ROLE AS jobid,JOB_TITLE,FILLED,LOCATION,JOB_DESCRIPTION,CANDIDATE_ID,NAME
  INTO C
  FROM Q,CANDIDATE
  WHERE Q.JOB_ID=CANDIDATE.ROLE;

  SELECT*FROM C
  /*Given a candidate_ID list the  entire job details hes interviewing for*/
  SELECT*
  FROM C
  WHERE CANDIDATE_ID=47;

  /*number of candidates for a particular job*/
  SELECT COUNT(CANDIDATE_ID) AS 'number_of_candidates',JOB_TITLE
  FROM C
  GROUP BY JOB_TITLE

  /*displays number of candidates in each status*/
  select count(STATUS) AS 'number of candidates',STATUS
  FROM CANDIDATE
  GROUP BY STATUS

  /*displays number of candidates applying for jobs in each location*/
  select count(CANDIDATE_ID) AS 'number of candidates',LOCATION
  FROM C
  GROUP BY LOCATION

  /*given a job title list details of all candidates interviewing*/
  SELECT*FROM C
  WHERE JOB_TITLE='Java Developers';

  /*given a jobid list details of all candidates interviewing*/
  SELECT*FROM C
  WHERE jobid=87;

  /*number of canidates in each age group*/
  select count(CANDIDATE_ID)
  from CANDIDATE
  WHERE AGE BETWEEN 20 and 25

  select count(CANDIDATE_ID)
  from CANDIDATE
  WHERE AGE BETWEEN 26 and 31
  /* use both queries and merge in python*/

  /*update query
  used to update candidates stautus.
  trigger used to allocate initial status to entry accepted
  once interview is allocated status is ongoing
  this query is for further updates on status

  UPDATE CANDIDATE 
  SET STATUS='accepted'
  WHERE CANDIDATE_ID=1;
   */

  /*SKILLS
  1)given candidate , list skills,level
2)count of candidates with a specific skill above a specific level
 3)list the candidates with a specific skill above a specific level
 */
drop table y
/*y is inner join of skills and skill name*/
select SKILLS.SKILL_ID,SKILL_NAME,CANDIDATE.CANDIDATE_ID,LEVEL,NAME,AGE,STATUS,EDUCATION,EXPERIENCE
into y
from SKILLS,SKILL_DETAILS,CANDIDATE
where SKILLS.SKILL_ID=SKILL_DETAILS.SKILL_ID and CANDIDATE.CANDIDATE_ID=CANDIDATE.CANDIDATE_ID;


/*given candidate id , list skill id,skill name ,level*/
select*from y
where candidate_id=1;

/*count of skills for each candidate*/
select count(SKILL_ID) AS number_of_skills,CANDIDATE_ID
from y
GROUP BY CANDIDATE_ID


/*list candidates with specific skill above level=5*/
select CANDIDATE_ID,NAME,AGE,EDUCATION
from y
where SKILL_NAME='algorithm-competitions' and LEVEL>5

/*list candidates with specific skillid,above level=5'*/
select CANDIDATE_ID,NAME,AGE,EDUCATION
from y
where SKILL_ID=71 and LEVEL>5


/*employee
1)employee name , age, job title,job description
 2)number of employees at a particular position
3)list of employees at a particular location
 */

/*given employee id display employee details*/
select*from EMPLOYEE
where EMPLOYEE_ID=1;

/*number of employees at a particular position*/
select EMPLOYEE_ID,EMPLOYEE_NAME,EMPLOYEE_AGE,JOB_DETAILS.JOB_ID,JOB_DETAILS.JOB_TITLE,JOB_DESCRIPTION
into z
from EMPLOYEE,JOB_DETAILS,JOB_ROLE
WHERE EMPLOYEE.EMPLOYEE_POSITION=JOB_DETAILS.JOB_ID and JOB_DETAILS.JOB_TITLE=JOB_ROLE.JOB_TITLE;

/*number of employees at a each position*/
SELECT COUNT(EMPLOYEE_ID) AS NUMBER_OF_EMPLOYEES,JOB_TITLE
FROM z
group by JOB_TITLE

/*list all employees at a particular position*/
SELECT EMPLOYEE_NAME,EMPLOYEE_AGE,EMPLOYEE_ID
from z
where JOB_TITLE='Business Development Manager'


/*INTERVIEWER:
1)given interviewer_id list its employee details
2)list all candidates an interviewer has interviewed
3)list count of different levels of questions asked by the interviewer
4)list different tags interviewer asked
5)among interviews he took ,how many have got selected
6)list the average score of candidates of all interviewers who have interviewed.*/

select INTERVIEWER_ID,INTERVIEWER.EMPLOYEE_ID,EMPLOYEE_NAME,EMPLOYEE_AGE,JOB_TITLE
into interviewer_employee
from INTERVIEWER,EMPLOYEE,JOB_DETAILS
where INTERVIEWER.EMPLOYEE_ID=EMPLOYEE.EMPLOYEE_ID and JOB_DETAILS.JOB_ID=EMPLOYEE.EMPLOYEE_POSITION

/*given interviewer id , list his employee details*/
select EMPLOYEE_ID,EMPLOYEE_NAME,EMPLOYEE_AGE,JOB_TITLE
from interviewer_employee
where INTERVIEWER_ID=2

/*2)list all candidates an interviewer has interviewed*/
select INTERVIEWER.INTERVIEWER_ID,INTERVIEW.CANDIDATE_ID,NAME,AGE,EXPERIENCE,STATUS
into interviewer_interview_candidates
from INTERVIEWER,INTERVIEW,CANDIDATE
where INTERVIEWER.INTERVIEWER_ID=INTERVIEW.INTERVIEWER_ID and INTERVIEW.CANDIDATE_ID=CANDIDATE.CANDIDATE_ID

select CANDIDATE_ID,NAME,AGE,EXPERIENCE,STATUS
from interviewer_interview_candidates
where INTERVIEWER_ID=33;

/*3)list count of different levels of questions asked by the interviewer*/
select INTERVIEWER.INTERVIEWER_ID,QUESTION_DIFFICULTY.QUESTION_ID,QUESTION_DIFFICULTY.DIFFICULTY
into l
from INTERVIEWER,INTERVIEW,MAP,QUESTION_DIFFICULTY
where INTERVIEWER.INTERVIEWER_ID=INTERVIEW.INTERVIEWER_ID and INTERVIEW.INTERVIEW_ID=MAP.INTERVIEW_ID and MAP.QUESTION_ID=QUESTION_DIFFICULTY.QUESTION_ID

select INTERVIEWER_ID,DIFFICULTY,count(DIFFICULTY) AS 'NUMBER OF QUESTIONS'
from l
group by DIFFICULTY,INTERVIEWER_ID

select INTERVIEWER_ID,DIFFICULTY,count(DIFFICULTY) AS 'NUMBER OF QUESTIONS'
INTO INTERVIEWER_QUESTION_DISTRIBUTION
from l
group by DIFFICULTY,INTERVIEWER_ID

SELECT*FROM INTERVIEWER_QUESTION_DISTRIBUTION
WHERE INTERVIEWER_ID=5 and DIFFICULTY='hard'

/*4)list different tags interviewer asked*/
select INTERVIEWER.INTERVIEWER_ID,QUESTION_TAGS.QUESTION_ID,QUESTION_TAGS.TAGS
INTO A
from INTERVIEWER,INTERVIEW,MAP,QUESTION_TAGS
where INTERVIEWER.INTERVIEWER_ID=INTERVIEW.INTERVIEWER_ID and INTERVIEW.INTERVIEW_ID=MAP.INTERVIEW_ID and MAP.QUESTION_ID=QUESTION_TAGS.QUESTION_ID

select*from A

SELECT QUESTION_ID,TAGS
from A
where INTERVIEWER_ID=15;

/*5)among interviews he took ,how many have got selected*/

SELECT INTERVIEWER.INTERVIEWER_ID,CANDIDATE.CANDIDATE_ID,CANDIDATE.NAME,CANDIDATE.AGE,CANDIDATE.EDUCATION,CANDIDATE.EXPERIENCE,STATUS
INTO B
fROM INTERVIEWER,INTERVIEW,CANDIDATE
WHERE INTERVIEWER.INTERVIEWER_ID=INTERVIEW.INTERVIEWER_ID and INTERVIEW.CANDIDATE_ID=CANDIDATE.CANDIDATE_ID

/*7)for each interviewer the number of interviews ongoing*/
SELECT COUNT(*) AS NUMBER_SELECTED,INTERVIEWER_ID
from B
where STATUS='ongoing'
group by STATUS,INTERVIEWER_ID

/*5)number of candidates each interviewer accepted*/
SELECT COUNT(*) AS NUMBER_SELECTED,INTERVIEWER_ID
from B
where STATUS='accepted'
group by STATUS,INTERVIEWER_ID

/*8)list the average score of all the candidates*/

select AVG(SCORE) as AVERAGE_SCORE,CANDIDATE_ID
INTO G
FROM INTERVIEW
GROUP BY CANDIDATE_ID

/*6) for each interviewer_ID find the average score of the candidate interviewed by this interviewer*/
SELECT AVERAGE_SCORE,G.CANDIDATE_ID,INTERVIEWER_ID
INTO J
FROM G,INTERVIEW
WHERE G.CANDIDATE_ID=INTERVIEW.CANDIDATE_ID;

SELECT*FROM J

/*9)given interviewer_ID , compute average score of the interviews taken by him*/
SELECT AVG(SCORE) as AVERAGE_SCORE,INTERVIEWER_ID
FROM INTERVIEW
GROUP BY INTERVIEWER_ID

/*QUESTION:
1)select query
2)no of question of diff difficulty
3)list questions without explanations*/
DROP TABLE D
SELECT QUESTION.QUESTION_ID,DIFFICULTY,TAGS,EXPLANATION,QUESTION_DESCRIPTION
INTO D
FROM QUESTION_EXPLANATION,QUESTION,QUESTION_TAGS,QUESTION_DIFFICULTY
WHERE QUESTION.QUESTION_ID=QUESTION_EXPLANATION.QUESTION_ID and QUESTION.QUESTION_ID=QUESTION_DIFFICULTY.QUESTION_ID and QUESTION_TAGS.QUESTION_ID=QUESTION.QUESTION_ID
and QUESTION_DIFFICULTY.QUESTION_ID=QUESTION.QUESTION_ID and QUESTION_DIFFICULTY.QUESTION_ID=QUESTION_EXPLANATION.QUESTION_ID and QUESTION_DIFFICULTY.QUESTION_ID=QUESTION_TAGS.QUESTION_ID
and QUESTION_EXPLANATION.QUESTION_ID=QUESTION_DIFFICULTY.QUESTION_ID and QUESTION_EXPLANATION.QUESTION_ID=QUESTION_TAGS.QUESTION_ID and QUESTION_EXPLANATION.QUESTION_ID=QUESTION.QUESTION_ID
and QUESTION_TAGS.QUESTION_ID=QUESTION.QUESTION_ID and QUESTION_TAGS.QUESTION_ID=QUESTION_EXPLANATION.QUESTION_ID and QUESTION_TAGS.QUESTION_ID=QUESTION_DIFFICULTY.QUESTION_ID;
SELECT*FROM D

/*1)given question_ID display question details*/
SELECT*from D
WHERE QUESTION_ID=1427
/*2)no of question of diff difficulty*/
SELECT COUNT(DIFFICULTY),DIFFICULTY
FROM D
GROUP BY DIFFICULTY

/*3)list questions without explanations*/
SELECT*
FROM D
WHERE EXPLANATION IS NULL;

/*INTERVIEW:
1)list all the interviews all of a specific candidates
2)list all interviews of a interviewer
3)count of number no of interviews where result was solved
4)no of candidates with avgscore>some given number
5)no_of interviews a question was asked in
6)no of interviewers that asked a each question
7)select all interviewers who asked a particular question
8)list all candidates who SOLVED a particular QUESTION
9)no_of candidates who solved a question*/

/* 1)list all the interviews all of a specific candidates */

SELECT*from INTERVIEW 
WHERE CANDIDATE_ID=1;


/* 2)list all interviews of a interviewer */
SELECT*FROM INTERVIEW
WHERE INTERVIEWER_ID=3;

/*3)count number of interviews where the result was solved*/

SELECT COUNT(*)
FROM INTERVIEW
WHERE RESULT='solved';

SELECT *from INTERVIEW
where RESULT='solved';

/*4)list all candidates with avg score>number also count such enteries*/
SElECT*
FROM G,CANDIDATE
WHERE G.CANDIDATE_ID=CANDIDATE.CANDIDATE_ID and G.AVERAGE_SCORE>5;

SElECT COUNT(*)
FROM G,CANDIDATE
WHERE G.CANDIDATE_ID=CANDIDATE.CANDIDATE_ID and G.AVERAGE_SCORE>5;

/*5)no_of interviews a question was asked in*/
SELECT COUNT(INTERVIEW_ID) AS NUMBER_OF_INTERVIEWS,QUESTION_ID
FROM MAP
GROUP BY QUESTION_ID
/*6)list the questions asked in a particular interview */
SELECT INTERVIEWER_ID,CANDIDATE_ID,RESULT,SCORE,QUESTION.QUESTION_ID,QUESTION.QUESTION_DESCRIPTION
FROM INTERVIEW,MAP,QUESTION
WHERE INTERVIEW.INTERVIEW_ID=MAP.INTERVIEW_ID and QUESTION.QUESTION_ID=MAP.QUESTION_ID and MAP.INTERVIEW_ID=1;

SELECT INTERVIEWER_ID,CANDIDATE_ID,RESULT,SCORE,QUESTION.QUESTION_ID,QUESTION.QUESTION_DESCRIPTION
FROM INTERVIEW,MAP,QUESTION
WHERE INTERVIEW.INTERVIEW_ID=MAP.INTERVIEW_ID and QUESTION.QUESTION_ID=MAP.QUESTION_ID

/* 10)count interviews with a particular question */
SELECT COUNT(INTERVIEW.INTERVIEW_ID) AS NUMBER_OF_INTERVIEWERS,MAP.QUESTION_ID
FROM INTERVIEW,MAP,QUESTION
WHERE INTERVIEW.INTERVIEW_ID=MAP.INTERVIEW_ID and QUESTION.QUESTION_ID=MAP.QUESTION_ID
GROUP BY MAP.QUESTION_ID;

/* 7)select all interviewers who asked a particular question */

SELECT INTERVIEW.INTERVIEWER_ID,EMPLOYEE.EMPLOYEE_ID,EMPLOYEE.EMPLOYEE_AGE,EMPLOYEE.EMPLOYEE_NAME
FROM INTERVIEW,MAP,QUESTION,EMPLOYEE,INTERVIEWER
WHERE INTERVIEW.INTERVIEW_ID=MAP.INTERVIEW_ID and INTERVIEW.INTERVIEWER_ID=INTERVIEWER.INTERVIEWER_ID and QUESTION.QUESTION_ID=MAP.QUESTION_ID and INTERVIEWER.EMPLOYEE_ID=EMPLOYEE.EMPLOYEE_ID and  MAP.QUESTION_ID=611;

SELECT INTERVIEW.INTERVIEWER_ID,EMPLOYEE.EMPLOYEE_ID,EMPLOYEE.EMPLOYEE_AGE,EMPLOYEE.EMPLOYEE_NAME,MAP.QUESTION_ID AS QUESTION_ASKED
FROM INTERVIEW,MAP,QUESTION,EMPLOYEE,INTERVIEWER
WHERE INTERVIEW.INTERVIEW_ID=MAP.INTERVIEW_ID and INTERVIEW.INTERVIEWER_ID=INTERVIEWER.INTERVIEWER_ID and QUESTION.QUESTION_ID=MAP.QUESTION_ID and INTERVIEWER.EMPLOYEE_ID=EMPLOYEE.EMPLOYEE_ID;

/* 8)list all candidates who SOLVED a particular QUESTION */
SELECT CANDIDATE.CANDIDATE_ID,NAME,AGE,EXPERIENCE,EDUCATION,MAP.QUESTION_ID,QUESTION_DESCRIPTION
FROM INTERVIEW,CANDIDATE,MAP,QUESTION
WHERE RESULT='solved' and CANDIDATE.CANDIDATE_ID=INTERVIEW.CANDIDATE_ID and MAP.QUESTION_ID=QUESTION.QUESTION_ID and INTERVIEW.INTERVIEW_ID=MAP.INTERVIEW_ID;

SELECT CANDIDATE.CANDIDATE_ID,NAME,AGE,EXPERIENCE,EDUCATION,MAP.QUESTION_ID,QUESTION_DESCRIPTION
FROM INTERVIEW,CANDIDATE,MAP,QUESTION
WHERE MAP.QUESTION_ID=1221 and RESULT='solved' and CANDIDATE.CANDIDATE_ID=INTERVIEW.CANDIDATE_ID and MAP.QUESTION_ID=QUESTION.QUESTION_ID and INTERVIEW.INTERVIEW_ID=MAP.INTERVIEW_ID;

/*9)no_of candidates who solved a question*/

SELECT MAP.QUESTION_ID,INTERVIEW.CANDIDATE_ID,INTERVIEW.INTERVIEW_ID,RESULT
INTO X
FROM INTERVIEW,MAP
WHERE INTERVIEW.INTERVIEW_ID=MAP.INTERVIEW_ID;

SELECT*FROM X
SELECT COUNT(CANDIDATE_ID) AS NUMBER_SOLVED,QUESTION_ID
FROM X
WHERE RESULT='solved'
GROUP BY QUESTION_ID;

/*
MAP:
1)all the questions asked in a specific interview and converse
2)all the interviews in which a specific questions was asked.
3)average difficulty of interview
 */

/*1)all the questions asked in a specific interview and converse
2)all the interviews in which a specific questions was asked.*/

SELECT MAP.INTERVIEW_ID,INTERVIEW.INTERVIEWER_ID,CANDIDATE_ID,QUESTION_ID,RESULT
FROM INTERVIEW,MAP
WHERE INTERVIEW.INTERVIEW_ID=MAP.INTERVIEW_ID;

SELECT MAP.INTERVIEW_ID,INTERVIEW.INTERVIEWER_ID,CANDIDATE_ID,QUESTION_ID,RESULT
FROM INTERVIEW,MAP
WHERE INTERVIEW.INTERVIEW_ID=MAP.INTERVIEW_ID and QUESTION_ID=1221;

SELECT MAP.INTERVIEW_ID,INTERVIEW.INTERVIEWER_ID,CANDIDATE_ID,MAP.QUESTION_ID,RESULT,QUESTION_DESCRIPTION
FROM INTERVIEW,MAP,QUESTION
WHERE INTERVIEW.INTERVIEW_ID=MAP.INTERVIEW_ID and QUESTION.QUESTION_ID=MAP.QUESTION_ID and INTERVIEW.INTERVIEW_ID=23;


/* 3) average difficulty of a interview */

SELECT INTERVIEW.INTERVIEW_ID,MAP.QUESTION_ID,QUESTION_DIFFICULTY.DIFFICULTY
INTO F
FROM INTERVIEW,MAP,QUESTION_DIFFICULTY
WHERE QUESTION_DIFFICULTY.QUESTION_ID=MAP.QUESTION_ID and MAP.INTERVIEW_ID=INTERVIEW.INTERVIEW_ID;

SELECT INTERVIEW_ID,QUESTION_ID,DIFFICULTY,
CASE 
WHEN DIFFICULTY='hard' then 9
WHEN DIFFICULTY='challenge' then 10
WHEN DIFFICULTY='medium' then 8
WHEN DIFFICULTY='easy' then 7
WHEN DIFFICULTY='beginer' then 6
END AS DIFFICULTY_SCORE
INTO N
FROM F


SELECT SUM(DIFFICULTY_SCORE)/COUNT(*) AS average_difficulty_of_interview,INTERVIEW_ID
INTO avg_difficulty_of_interview
FROM N
GROUP BY INTERVIEW_ID

SELECT* from avg_difficulty_of_interview
/*
COMPLEX QUERIES:
1) given a candidateID , list name,eucation,age and all the interviews and the avg difficulty of all those interviews and score in each of these interviews,id of interviewer,average score,result
2) given a job title , no_of_jobs of that title, list all locations where job exists, list number of candidates applying for that job,list the skills(top3) of the employees in that job.
3) given a interviewerID, get name,number of interviews conducted,avg difficulty of interviews,avg score of interviewed candidates,number of interviewed candidates who have been hired*/


/*1) given a candidateID , list name,eucation,age and all the interviews and the avg difficulty of all those interviews and score in each of these interviews,id of interviewer,average score,result*/
select CANDIDATE.CANDIDATE_ID,NAME,EDUCATION,AGE,avg_difficulty_of_interview.average_difficulty_of_interview,INTERVIEW.INTERVIEW_ID,SCORE,AVERAGE_SCORE,INTERVIEWER_ID
INTO COMPLEX1
from CANDIDATE,avg_difficulty_of_interview,INTERVIEW,G
WHERE CANDIDATE.CANDIDATE_ID=INTERVIEW.INTERVIEW_ID and INTERVIEW.INTERVIEW_ID=avg_difficulty_of_interview.INTERVIEW_ID and G.CANDIDATE_ID=CANDIDATE.CANDIDATE_ID;

SELECT* from COMPLEX1

SELECT*from COMPLEX1
where CANDIDATE_ID=10;


/*2) given a job title , no_of_jobs of that title, list all locations where job exists, list number of candidates applying for that job,list the skills(top3) of the employees in that job.*/


select JOB_DETAILS.JOB_ID,JOB_DETAILS.JOB_TITLE,JOB_DETAILS.LOCATION,JOB_DETAILS.FILLED,JOB_ROLE.JOB_DESCRIPTION,CANDIDATE_ID
INTO MEGA_JOBS
from JOB_DETAILS,JOB_ROLE,CANDIDATE
where JOB_DETAILS.JOB_TITLE=JOB_ROLE.JOB_TITLE and CANDIDATE.ROLE=JOB_DETAILS.JOB_ID;

select count(CANDIDATE_ID) as NUMBER_OF_APPLICANTS,JOB_TITLE
INTO T1
from MEGA_JOBS
GROUP BY JOB_TITLE;

select JOB_DETAILS.JOB_ID,JOB_DETAILS.JOB_TITLE,JOB_DETAILS.LOCATION,JOB_DETAILS.FILLED,JOB_ROLE.JOB_DESCRIPTION
INTO MEGA_JOBS1
from JOB_DETAILS,JOB_ROLE
where JOB_DETAILS.JOB_TITLE=JOB_ROLE.JOB_TITLE;

select count(JOB_ID) AS NUMBER_OF_OPENINGS,JOB_TITLE
INTO T2
FROM MEGA_JOBS1
GROUP BY JOB_TITLE


select NUMBER_OF_APPLICANTS,NUMBER_OF_OPENINGS,T1.JOB_TITLE
INTO COMPLEX2
FROM T1,T2
where T1.JOB_TITLE=T2.JOB_TITLE;

select*from COMPLEX2

/*3) given a interviewerID, get name,number of interviews conducted,avg difficulty of interviews,avg score of interviewed candidates,number of interviewed candidates who have been hired,*/

select INTERVIEWER_ID,COUNT(INTERVIEW_ID) AS NUMBER_OF_INTERVIEWS
INTO Q1
from INTERVIEW
GROUP BY INTERVIEWER_ID

SELECT AVG(SCORE) as AVERAGE_SCORE_OF_CANDIDATES_INTERVIEWED,INTERVIEWER_ID
INTO Q2
FROM INTERVIEW
GROUP BY INTERVIEWER_ID

select INTERVIEWER_ID,COUNT(CANDIDATE_ID) AS NUMBER_OF_CANDIDATES_INTERVIEWED
INTO Q3
from INTERVIEW
GROUP BY INTERVIEWER_ID

SELECT avg_difficulty_of_interview.average_difficulty_of_interview,INTERVIEW.INTERVIEW_ID,INTERVIEWER_ID
INTO Q4
FROM avg_difficulty_of_interview,INTERVIEW
WHERE avg_difficulty_of_interview.INTERVIEW_ID=INTERVIEW.INTERVIEW_ID;

select INTERVIEWER_ID,AVG(average_difficulty_of_interview) AS AVERAGE_DIFFICULTY_OF_INTERVIEWS_TAKEN
INTO Q5
from Q4
GROUP BY INTERVIEWER_ID

select Q1.INTERVIEWER_ID,Q1.NUMBER_OF_INTERVIEWS,Q2.AVERAGE_SCORE_OF_CANDIDATES_INTERVIEWED,Q3.NUMBER_OF_CANDIDATES_INTERVIEWED,Q5.AVERAGE_DIFFICULTY_OF_INTERVIEWS_TAKEN
INTO Q7
from Q1,Q2,Q3,Q5
where Q1.INTERVIEWER_ID=Q2.INTERVIEWER_ID and Q1.INTERVIEWER_ID=Q3.INTERVIEWER_ID and Q1.INTERVIEWER_ID=Q5.INTERVIEWER_ID
and Q2.INTERVIEWER_ID=Q3.INTERVIEWER_ID and Q2.INTERVIEWER_ID=Q5.INTERVIEWER_ID 
and Q3.INTERVIEWER_ID=Q5.INTERVIEWER_ID;

SELECT*
INTO COMPLEX3
FROM Q7
SELECT*from COMPLEX3
/*Given INTERVIEWER_ID list all INTERVIEWS TAKEN */
SELECT*from INTERVIEW
WHERE INTERVIEWER_ID=2;
