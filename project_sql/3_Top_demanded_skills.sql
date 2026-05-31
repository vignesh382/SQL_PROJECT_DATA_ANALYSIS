-- Query 3: Top 5 most in-demand skills for Data Analyst roles
-- Counts how many job postings mention each skill


SELECT 
    skills_dim.skills,
    COUNT(skills_job_dim.skill_id) AS Demand_count
FROM
    job_postings_fact
INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
GROUP BY
    skills
ORDER BY
    Demand_count DESC
LIMIT 5