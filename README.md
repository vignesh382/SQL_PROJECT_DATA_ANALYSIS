# 🔍 SQL Job Market Analysis — What Does It Take to Land a Data Analyst Role?

> *A SQL project exploring real-world job posting data to uncover what skills pay the most, what's in demand, and what's worth learning.*

📂 Queries: [project_sql folder](/project_sql/) | 📊 Dataset: [Luke Barousse's SQL Course](https://lukebarousse.com/sql)

---

## 🧠 Why I Built This

While learning SQL, I wanted to work on something actually relevant to my own career goals. So instead of a generic practice dataset, I analyzed **real job postings** to answer one core question:

**As someone trying to break into data analytics — what should I actually focus on?**

That question led to 5 focused SQL analyses below.

---

## 📁 Dataset Overview

The database has 4 tables:

| Table | Description |
|-------|-------------|
| `job_postings_fact` | Core job postings — titles, salaries, locations, dates |
| `company_dim` | Company names linked to job postings |
| `skills_dim` | Skill names and categories |
| `skills_job_dim` | Bridge table linking jobs to required skills |

---

## 🔎 The 5 Questions

### 1️⃣ What are the top 10 highest paying remote Data Analyst jobs?

Filtered for remote roles (`job_location = 'Anywhere'`) with a known salary.

```sql
SELECT	
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    name AS company_name,
    job_posted_date
FROM job_postings_fact
LEFT JOIN company_dim ON company_dim.company_id = job_postings_fact.company_id
WHERE
    job_title_short = 'Data Analyst' AND 
    job_location = 'Anywhere' AND 
    salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC
LIMIT 10;
```

**What I found:**
- Salaries range from **$184,000 to $650,000** — the ceiling is much higher than expected
- Top employers include Meta, AT&T, and SmartAsset
- Titles vary widely — from Data Analyst to Director of Analytics

---

### 2️⃣ What skills do those top paying jobs actually require?

Used a CTE to pull the top 10 jobs first, then joined with skill tables.

```sql
WITH top_paying_jobs AS (
    SELECT job_id, job_title, salary_year_avg, name AS company_name
    FROM job_postings_fact
    LEFT JOIN company_dim ON company_dim.company_id = job_postings_fact.company_id
    WHERE
        job_title_short = 'Data Analyst' AND 
        job_location = 'Anywhere' AND 
        salary_year_avg IS NOT NULL
    ORDER BY salary_year_avg DESC
    LIMIT 10
)
SELECT top_paying_jobs.*, skills_dim.skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY salary_year_avg DESC;
```

**What I found:**
- **SQL** appears in 8 out of 10 top paying jobs
- **Python** follows with 7 mentions
- **Tableau** rounds out the top 3 with 6 mentions

---

### 3️⃣ Which skills appear most in Data Analyst job postings?

Counted skill mentions across all Data Analyst postings.

```sql
SELECT 
    skills_dim.skills,
    COUNT(skills_job_dim.skill_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE job_title_short = 'Data Analyst'
GROUP BY skills
ORDER BY demand_count DESC
LIMIT 5;
```

| Skill    | Demand Count |
|----------|-------------|
| SQL      | 7,291       |
| Excel    | 4,611       |
| Python   | 4,330       |
| Tableau  | 3,745       |
| Power BI | 2,609       |

**What I found:** SQL and Excel are non-negotiable fundamentals. Python and visualization tools are where you separate yourself from the crowd.

---

### 4️⃣ Which skills are linked to the highest salaries?

Calculated average salary per skill for Data Analyst roles.

```sql
SELECT
    skills_dim.skills,
    ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS average_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
GROUP BY skills
ORDER BY average_salary DESC
LIMIT 25;
```

**What I found:**
- Big data tools like **PySpark** ($208K avg) and **Couchbase** ($160K) dominate
- Cloud platforms — **GCP, Databricks, Elasticsearch** — signal premium pay
- DevOps crossover skills like **Kubernetes** and **Airflow** are surprisingly lucrative

---

### 5️⃣ What are the most optimal skills — high demand AND high salary?

The final question: combining both demand and salary to find the smartest skills to learn.

```sql
SELECT
    skills_job_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.skill_id) AS demand_count,
    ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = TRUE
GROUP BY skills_job_dim.skill_id, skills_dim.skills
HAVING COUNT(skills_job_dim.skill_id) > 10
ORDER BY avg_salary DESC
LIMIT 25;
```

| Skill      | Demand Count | Avg Salary ($) |
|------------|-------------|----------------|
| Snowflake  | 37          | 112,948        |
| Azure      | 34          | 111,225        |
| AWS        | 32          | 108,317        |
| Python     | 236         | 101,397        |
| Tableau    | 230         | 99,288         |
| SQL        | 398         | 97,237         |

**What I found:** SQL, Python, and Tableau are the sweet spot — massive demand with strong salaries. Cloud tools offer higher pay but lower volume of openings.

---

## 🛠️ Tools Used

- **PostgreSQL** — database setup and querying
- **VS Code** — writing and running all SQL
- **Git & GitHub** — version control and project hosting

---

## 💡 What I Learned

Going through this project, I grew from writing basic SELECT queries to confidently using:
- Multi-table **JOINs** across 3-4 tables
- **CTEs** to break complex logic into readable steps
- **Subqueries** for filtering with nested logic
- **Aggregations** with GROUP BY, HAVING, AVG, COUNT, ROUND
- **UNION ALL** to combine results across tables

The biggest takeaway wasn't technical — it was realizing that **the right question matters more than a fancy query.**

---

## ✅ Conclusions

1. SQL is non-negotiable — it's the most demanded AND well-compensated foundational skill
2. Python + Tableau is the strongest combination for breaking into DA roles
3. Cloud skills (AWS, Azure, Snowflake) are worth learning for salary growth
4. Niche/specialized tools pay the most but have fewer openings
5. Remote DA roles have a massive salary ceiling — skills directly drive compensation