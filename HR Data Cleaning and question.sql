
drop database projects;
Create database projects;
Use Projects;

select * from HR;

ALTER TABLE HR change column ï»¿id emp_id Varchar(50) null;

Select birthdate from HR;

Set sql_mode = 0;

UPDATE ignore HR
SET birthdate = CASE
 WHEN birthdate like '%/%' THEN date_format(str_to_date(birthdate, '%m/%d/%Y'),'%Y-%m-%d')
 when birthdate like '%-%' then	date_format(str_to_date(birthdate, '%m-%d-%Y'),'%Y-%m-%d')
 else null
end;

alter table hr
modify column birthdate Date;

describe hr;

select hire_date from HR;

UPDATE ignore HR
SET HIRE_DATE = CASE
 WHEN HIRE_DATE like '%/%' THEN date_format(str_to_date(HIRE_DATE, '%m/%d/%Y'),'%Y-%m-%d')
 when HIRE_DATE like '%-%' then	date_format(str_to_date(HIRE_DATE, '%m-%d-%Y'),'%Y-%m-%d')
 else null
end;

alter table hr
modify column hire_date date;

select termdate from hr;


Update hr
set termdate = date(str_to_date(termdate,'%Y-%m-%d %H:%i:%s UTC'))
where termdate is not null and termdate !=' ';

alter table hr
modify column termdate date;

alter table hr add column age int;

Update 	hr
set age = timestampdiff(year,birthdate, curdate());

select age from hr;

select
 min(age) as youngest,
 max(age) as oldest
from hr;

select count(*) from hr where age < 18;

-- Questions

-- What is the gender breakdown of employees in the company?
select gender, count(*) as count from hr
where age >= 18 and termdate = '0000-00-00'
group by gender;

-- What is the race/ethnicity breakdown of employees in the company?
Select race,count(*) as count from hr
where age>= 18 and termdate = '0000-00-00'
group by race
order by count desc;

-- What is the age distribution of employees in the company?
select 
Min(age) as Youngest,
max(age) as oldest
from hr
where age>=18 and termdate = '0000-00-00';

select 
case 	
when age>=18 and age <=24 then '18-24'
when age>=25 and age <=34 then '25-34'
when age>=35 and age <=44 then '35-44'
when age>=45 and age <=54 then '45-54'
when age>=55 and age <=64 then '55-64'
else '65+'
end as age_group, gender,
count(*) as count
from hr
where age>=18 and termdate = '0000-00-00'
group by age_group,gender
order by age_group,gender;

-- How many employees work at headquarters versus remote locations?
select location,count(*) as count
from hr
where age>=18 and termdate = '0000-00-00'
group by location;

-- What is the average length of employment for employees who have been terminated?
select 
round(avg(datediff(termdate, hire_date))/365,0) as avg_length_employement
from hr 
where termdate<= curdate() and termdate <> '0000-00-00' and age>=18;

-- How does the gender distribution vary across departments and job titles?
select department,gender, count(*) as count 
from hr
where age>=18 and termdate = '0000-00-00'
Group by department, gender
order by department;


-- What is the distribution of job titles across the company?
select jobtitle,count(*) as count
from hr
where age>=18 and termdate = '0000-00-00'
group by jobtitle
order by jobtitle desc;

-- Which department has the highest turnover rate?
select department,
 total_count,
 terminated_count,
 terminated_count/total_count as termination_rate
 from(
 select department,
 count(*) as total_count,
 sum(case when termdate<>'0000-00-00' and termdate<= curdate()then 1 else 0 end)as terminated_count
 from hr 
 where age>=18
 group by department) as subquery
order by termination_rate desc;

-- What is the distribution of employees across locations by state?
Select location_state, count(*) as count
from hr 
where age>=18 and termdate = '0000-00-00'
group by location_state
order by count desc;

-- How has the company's employee count changed over time based on hire and term dates?
Select 
year,
hires,
termination,
hires-termination as net_change,
round((hires-termination) /hires * 100,2) as percentage_change
from(
select year(hire_date) as year,
count(*) as hires,
sum(case when termdate<>'0000-00-00' and termdate<=curdate() then 1 else 0 end) as termination
from hr
where age>=18
group by year(hire_date) 
)as subquery
order by  year asc;


-- What is the tenure distribution for each department?
select department, round(avg(datediff(termdate,hire_date)/365),0) as avg_tenure
from hr
where termdate<= curdate() and  termdate <> '0000-00-00' and age>=18
group by department;


