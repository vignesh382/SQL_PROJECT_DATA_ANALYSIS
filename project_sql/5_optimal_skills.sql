-- Query 5: Most optimal skills to learn (high demand + high salary)
-- Filters for remote jobs, minimum 10 job postings per skill
-- Ordered by average salary to find the best skills to prioritize


SELECT
    skills_job_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.skill_id) AS demand_count,
    ROUND(AVG(job_postings_fact.salary_year_avg),0) AS avg_salary
FROM
    job_postings_fact
INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND
    salary_year_avg IS NOT NULL
    AND 
    job_work_from_home = TRUE
GROUP BY
    Skills_job_dim.skill_id,skills_dim.skills
HAVING
    COUNT(skills_job_dim.skill_id) > 10
ORDER BY    
    avg_salary DESC
LIMIT 25;