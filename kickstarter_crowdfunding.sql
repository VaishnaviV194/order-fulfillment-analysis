-- CROWDFUNDING PROJECT 

USE crowdfunding_project;

-- CONVERSION OF EPOCH TIME TO STANDARD DATE FORMAT
ALTER TABLE projects
ADD created_at_date DATETIME,
ADD launched_at_date DATETIME,
ADD deadline_at DATETIME;

UPDATE projects
SET created_at_date=from_unixtime(created_at),
launched_at_date=from_unixtime(launched_at),
deadline_at=from_unixtime(deadline);
 
-- 1. TOTAL NUMBER OF PROJECTS BASED ON OUTCOME
SELECT state,Count(*) AS Total_projects
FROM crowdfunding_project.projects
GROUP BY state
ORDER BY Total_projects DESC;


-- 2. TOTAL NUMBER OF PROJECTS BASED ON LOCATION
SELECT country, COUNT(*) AS Total_projects
FROM crowdfunding_project.projects
GROUP BY country
ORDER BY Total_projects DESC;


-- 3. TOTAL NUMBER OF PROJECTS BASED ON CATEGORY
SELECT c.name, COUNT(p.ProjectID) AS Total_projects
FROM crowdfunding_project.projects p
JOIN crowdfunding_project.category c ON p.category_id = c.id
GROUP BY c.name
ORDER BY Total_projects DESC;


-- 4. TOTAL NUMBER OF PROJECTS BY YEAR,QUARTER AND MONTH
SELECT year(created_at_date) AS year,
quarter(created_at_date) AS quarter,
monthname(created_at_date) AS month,
COUNT(ProjectID) AS Total_projects
FROM crowdfunding_project.projects
GROUP BY year(created_at_date),
quarter(created_at_date), 
monthname(created_at_date)
ORDER BY year(created_at_date) DESC, 
quarter(created_at_date), 
monthname(created_at_date);


-- 5. SUCCESSFUL PROJECTS BY AMOUNT RAISED
SELECT name AS Project_name,state,(goal * static_usd_rate) AS Amount_Raised
FROM crowdfunding_project.projects
WHERE state = 'successful' order by Amount_Raised DESC;
    

-- 6. SUCCESSFUL PROJECTS BY BACKERS
SELECT name AS Project_name,state,backers_count
FROM crowdfunding_project.projects
WHERE state = 'successful' ORDER BY backers_count DESC;
    

-- 7. AVERAGE NUMBER OF DAYS FOR SUCCESSFUL PROJECT
SELECT state as project,avg(datediff(deadline_at,created_at_date)) AS Avg_project_duration_days
FROM crowdfunding_project.projects
WHERE state = 'successful' ORDER BY Avg_project_duration_days DESC;


-- 8. TOP SUCCESSFUL PROJECTS BASED ON NUMBER OF BACKERS
SELECT name AS Project_name,state,backers_count 
FROM crowdfunding_project.projects 
WHERE state='successful'
ORDER BY backers_count DESC
LIMIT 10;


-- 9. TOP SUCCESSFUL PROJECTS BASED ON AMOUNT RAISED
SELECT name AS Project_name,state,(goal*static_usd_rate) AS Amount_raised
FROM crowdfunding_project.projects
WHERE state='successful'
ORDER BY Amount_raised DESC
LIMIT 10;


-- 10. PERCENTAGE OF SUCCESSFUL PROJECTS OVERALL
SELECT (COUNT(CASE WHEN state = 'successful' THEN 1 END) * 100.0 / COUNT(*)) AS Success_percentage
FROM crowdfunding_project.projects;


-- 11. PERCENTAGE OF SUCCESSFUL PROJECTS BY CATEGORY
SELECT c.name AS Category_name,
COUNT(p.ProjectID) AS Total_projects,
COUNT(CASE WHEN p.state = 'successful' THEN 1 END) AS Successful_projects,
(COUNT(CASE WHEN p.state = 'successful' THEN 1 END) * 100.0 / COUNT(p.ProjectID)) AS Success_percentage
FROM 
crowdfunding_project.projects p
JOIN crowdfunding_project.category c 
ON p.category_id = c.id
GROUP BY c.name
ORDER BY Success_percentage DESC;


-- 12. PERCENTAGE OF SUCCESSFUL PROJECTS BY GOAL RANGE
SELECT 
CASE 
WHEN (goal * static_usd_rate)<5000 THEN 'less than 5000'
WHEN (goal * static_usd_rate) BETWEEN 5000 AND 20000 THEN '5000 to 20000'
WHEN (goal * static_usd_rate) BETWEEN 20000 AND 50000 THEN '20000 to 50000'
WHEN (goal * static_usd_rate) BETWEEN 50000 AND 100000 THEN '50000 to 100000'
ELSE 'greater than 100000'
END AS goal_range,
COUNT(ProjectID) AS Total_projects,
COUNT(CASE WHEN state = 'successful' THEN 1 END) AS Successful_projects,
(COUNT(CASE WHEN state = 'successful' THEN 1 END) * 100.0 / COUNT(ProjectID)) AS Success_percentage
FROM crowdfunding_project.projects
GROUP BY goal_range
ORDER BY Success_percentage DESC;





