-- 1.	Write SQL command to create a database named hremployeeDB and a table named HR_Employee with
 -- columns for EmployeeID, Department, JobRole, Attrition, Gender, Age, MaritalStatus, Education, 
 -- EducationField, BusinessTravel, JobInvolvement, JobLevel, JobSatisfaction, Hourlyrate, Income, Salaryhike, 
--  OverTime, Workex, YearsSinceLastPromotion, EmpSatisfaction, TrainingTimesLastYear, WorkLifeBalance,
-- Performance_Rating, and set EmployeeID as the primary key.

-- Dataset description:

-- •	EmployeeID: Row ID
-- •	Department: Sales, Research & Development, Human Resources, 
-- •	JobRole: Sales Executive, Research Scientist, Laboratory Technician, Manufacturing Director, Manager, Sales Representative, Healthcare Representative, Human Resources, Research Director, 
-- •	Attrition: Process of reducing company's strength. YES→ the employee has 
    -- left the company OR terminated, and No→ Still working.
-- •	Gender: Gender of employee
-- •	MaritalStatus: Married, Divorced, Single
-- •	EducationField: Human Resources, Life Sciences, Marketing, Medical, Technical Degree, Other.
-- •	BusinessTravel: Non-Travel, Travel_Frequently, Travel_Rarely
-- •	JobInvolvement: High, Low, Medium, Very High
-- •	JobLevel: 1, 2, 3, 4, 5
-- •	JobSatisfaction: High, Low, Medium, Very High
-- •	Hourlyrate:  30 - 100
-- •	Income: It ranges from 1009 to 19999
-- •	Salaryhike:  11 - 25
-- •	OverTime: Yes, No.
-- •	Workex: 0 - 40
-- •	YearsSinceLastPromotion: 0 - 15
-- •	EmpSatisfaction: High, Low, Medium, Very High
-- •	TrainingTimesLastYear:  0 - 6
-- •	WorkLifeBalance: Good, Better, Best, Bad
-- •	Performance_Rating: Excellent, Outstanding

CREATE DATABASE hremployeeDB;

USE hremployeeDB;
drop table  HR_Employee;
CREATE TABLE HR_Employee (
    EmployeeID INT PRIMARY KEY,
    Department VARCHAR(100),
    JobRole VARCHAR(100),
    Attrition VARCHAR(10),
    Gender VARCHAR(10),
    Age INT,
    MaritalStatus VARCHAR(20),
    Education VARCHAR(100),
    EducationField VARCHAR(100),
    BusinessTravel VARCHAR(100),
    JobInvolvement VARCHAR(100),
    JobLevel INT,
    JobSatisfaction VARCHAR(100),
    Hourlyrate INT,
    Income INT,
    Salaryhike INT,
    OverTime VARCHAR(50),
    Workex INT,
    YearsSinceLastPromotion INT,
    EmpSatisfaction VARCHAR(100),
    TrainingTimesLastYear INT,
    WorkLifeBalance VARCHAR(100),
    Performance_Rating VARCHAR(100)
);
-- 2.Return the shape of the table
desc hr_employee;
select * from hr_employee;
-- 3.Show the count of Employee & percentage Workforce in each Department.
select count(*) as 'empcount' ,count(*)/(SELECT COUNT(*) FROM HR_Employee)*100 as 'Percentage of Workforce',
department from hr_employee group by department;
-- 4.	Which gender have higher strength as workforce in each department?

 select count(*),gender,department from hr_employee group by department,gender ; 
 
-- 5.	Show the workforce in each Job Role
SELECT JobRole, COUNT(*) as 'work force' FROM HR_Employee GROUP BY JobRole;
-- 6.	Show Distribution of Employee's Age Group.
SELECT CASE 
         WHEN Age BETWEEN 18 AND 25 THEN '18-25' 
         WHEN Age BETWEEN 26 AND 35 THEN '26-35'
         WHEN Age BETWEEN 36 AND 45 THEN '36-45'
         WHEN Age BETWEEN 46 AND 55 THEN '46-55'
         WHEN Age > 55 THEN 'Above 55'
       END as 'Age Group', 
       COUNT(*) as 'Count of Employees' 
FROM HR_Employee 
GROUP BY CASE 
           WHEN Age BETWEEN 18 AND 25 THEN '18-25' 
           WHEN Age BETWEEN 26 AND 35 THEN '26-35'
           WHEN Age BETWEEN 36 AND 45 THEN '36-45'
           WHEN Age BETWEEN 46 AND 55 THEN '46-55'
           WHEN Age > 55 THEN 'Above 55'
         END ;
         
--  7.	Compare all marital status of employee and find the most frequent marital status.
SELECT MaritalStatus, COUNT(*) as 'Count of Employees' FROM HR_Employee
 GROUP BY MaritalStatus 
 ORDER BY COUNT(*) DESC LIMIT 1;
 
 -- 8.	What is Job satisfaction level of employee?
SELECT JobSatisfaction, COUNT(*) as 'Count of Employees',joblevel FROM HR_Employee 
GROUP BY JobSatisfaction,joblevel;

-- 9.	How frequently employee is going on Business Trip.
select BusinessTravel,count(*) from HR_Employee GROUP BY BusinessTravel 
having businesstravel = 'travel_frequently' ;

-- 10.	Show the Department with Highest Attrition Rate (Percentage)
select department ,count(*)/ (SELECT COUNT(*) FROM HR_Employee)*100 as 'percentage'
 from hr_employee group by department order by percentage desc limit 1 ;

-- 11.	Show the Job Role with Highest Attrition Rate (Percentage)
select jobrole ,count(*)/ (SELECT COUNT(*) FROM HR_Employee)*100 as 'percentage'
 from hr_employee group by jobrole order by percentage desc limit 1 ;

-- 12.	Show Distribution of Employee's Promotion, Find the maximum chances of employee getting promoted.
select case
when yearsincelastpromotion <= 2 then 1 ;


-- 13.	Find the Attrition Rate for Marital Status.
 
 select maritalstatus,count(*)/ (SELECT COUNT(*) FROM HR_Employee)*100 as 'attrition Rate'
 from hr_employee group by maritalstatus;
 
--  14.	Find the Attrition Count & Percentage for Different Education Levels
 select count(*)/ (SELECT COUNT(*) FROM HR_Employee)*100 as 'percentage of different education levels',
 count(*) as 'attrition count',education
 from hr_employee group by education  ;
 
 
 -- 15.	Find the Attrition & Percentage Attrition for Business Travel.
  select count(*)/ (SELECT COUNT(*) FROM HR_Employee)*100 as 'percentage ',
 attrition ,BusinessTravel
 from hr_employee group by BusinessTravel,attrition  ;
 
 -- 16.	Find the Attrition & Percentage Attrition for Various JobInvolvement

 select count(*)/ (SELECT COUNT(*) FROM HR_Employee)*100 as 'percentage',
 attrition ,JobInvolvement
 from hr_employee group by JobInvolvement,attrition  ;
 
 -- 17.	Show Attrition Rate for Different JobSatisfaction.
 select count(*)/ (SELECT COUNT(*) FROM HR_Employee)*100 as 'percentage',
 JobSatisfaction
 from hr_employee group by JobSatisfaction  ;
 
 -- 18.	Find key reasons for Attrition in Company.
 select count(*), attrition ,jobrole,department,jobsatisfaction from hr_employee
 group by jobrole,department ,attrition,JobSatisfaction 
  having attrition='yes' and  JobSatisfaction = 'Low' order by count(*) desc limit 1;
  
 select count(*), attrition ,jobrole,department,empsatisfaction from hr_employee
 group by jobrole,department ,attrition,empSatisfaction 
  having attrition='yes' and  empSatisfaction = 'Low' order by count(*) desc limit 1;
-- empsatisfaction 
-- jobsatisfaction 
-- worklife balance
select count(*), attrition,empsatisfaction, JobSatisfaction,WorkLifeBalance from hr_employee
 group by empsatisfaction, JobSatisfaction,WorkLifeBalance ,attrition 
  having attrition='yes' and  empSatisfaction = 'Low'  
  and WorkLifeBalance= 'bad' and JobSatisfaction = 'low'
  order  by count(*) desc;
  select count(*), attrition , YearsSinceLastPromotion from hr_employee
 group by attrition,YearsSinceLastPromotion
  having attrition='yes';
 --- order by count(*) desc limit 1;
  
  
  
 -- 19.	Return all employee where WorkEx greater than 10, provided that they travel frequently, 
     -- WorkLifeBalance as Good  and JobSatisfaction is Very High.
     
     select * from hr_employee
     where WorkEx > 10 and BusinessTravel ='Travel_frequently' and  
  WorkLifeBalance= 'Good' and JobSatisfaction = 'High';
     -- 20.Write query to display who has better WorkLifeBalance , Married, Single or Divorced
        -- provided that Performace_Rating is Outstanding. 
        select count(*),WorkLifeBalance,Performance_Rating,maritalstatus from hr_employee 
        where Performance_Rating ='outstanding' 
        and WorkLifeBalance ='better' 
        group by maritalstatus;



-- select * from HR_Employee ;
-- select count(*) from HR_Employee ;