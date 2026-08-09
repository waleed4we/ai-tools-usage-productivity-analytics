# AI TOOLS USAGE & PRODUCTIVITY ANALYTICS

## PostgreSQL Data Analytics Portfolio Project

### Prepared by
# Malik Waleed Hussain

**GitHub:** `github.com/waleed4we`

**Technology Stack**  
PostgreSQL • SQL • Python • Pandas • NumPy

**Project Type**  
Data Analytics / SQL Portfolio Project

**Dataset Type**  
Synthetic AI Usage & Productivity Dataset

**Analysis Period**  
January 2025 – June 2026

---

# TABLE OF CONTENTS

### 01 — Project Introduction
1. Executive Summary
2. Project Objectives

### 02 — Dataset & Database
3. Dataset Generation & Methodology
4. Database Architecture
5. Table & Schema Documentation
6. Data Loading & Analytical Workflow
7. Analytical Methodology

### 03 — SQL Business Analysis
8. Data Exploration & Sanity Checks
9. Demographic Analysis
10. Tool & Pricing Analysis
11. Usage Behavior
12. Advanced Analytics
13. Business & Revenue Analysis
14. Key Business Questions

### 04 — Business Findings
15. Cross-Analysis: Key Findings
16. Business Insights & Strategic Recommendations
17. Data & Analytical Caveats

### 05 — Project Conclusion
18. Final Project Story
19. Conclusion

---

# 01 — PROJECT INTRODUCTION

## 1. Executive Summary

**AI Tools Usage & Productivity Analytics** is a PostgreSQL-based data analytics project designed to analyze AI adoption, usage behavior, productivity, subscriptions and revenue.

The project contains:

- **10,000 users**
- **30 AI tools**
- **477,087 usage records**
- **4,736 subscriptions**
- **31,214 payments**

The analysis explores user demographics, AI tool adoption, pricing models, usage intensity, professional preferences, productivity, subscription behavior and revenue.

The overall objective is to move beyond simple SQL querying and answer practical business questions:

> **Who uses AI? Which tools are being used? How intensely are they used? Which users and categories create the most value? And what should a business do with these findings?**

The analysis indicates that AI adoption is already extremely broad within this dataset. Consequently, the strongest business opportunities are not simply acquiring new users, but increasing **engagement, productivity, monetization, cross-category usage and retention**.

---

## 2. Project Objectives

The project aims to determine:

- Who uses AI and how frequently?
- Which AI tools and categories are most popular?
- How does usage differ across professions?
- How does AI usage vary by experience level?
- Which pricing models have the strongest reach?
- Which categories generate the most revenue?
- Which users demonstrate high productivity?
- Which subscription plans are most popular?
- Where are the strongest monetization opportunities?
- What strategic recommendations can be derived from the data?

---

# 02 — DATASET & DATABASE

## 3. Dataset Generation & Methodology

### Dataset Overview

The dataset used in this project is **synthetically generated** rather than collected from a real-world external database.

A dedicated Python script named **`main.py`** was used to generate all five CSV datasets required for the project.

The generator was designed specifically for SQL analytics and portfolio use, creating realistic relationships between users, AI tools, usage activity, subscriptions and payments.

The dataset covers the period:
**January 1, 2025 → June 30, 2026**

---

### AI-Assisted Dataset Generation

The dataset-generation process was developed with the assistance of AI to create a structured Python data-generation script.

The purpose was not to create completely random data, but to generate a **controlled synthetic business environment** containing relationships that could later be investigated through SQL.

The Python script generated:

1. AI tools
2. Users
3. AI usage activity
4. Subscriptions
5. Payments

These datasets were then exported as CSV files and imported into PostgreSQL.

---

### Python Libraries Used

The generator uses several Python libraries:

**NumPy**  : Used for numerical operations, probabilistic sampling and weighted distributions.

**Pandas** : Used to construct and manipulate DataFrames and export the generated datasets as CSV files.

**Python `random`**  : Used for randomized behavioral and transactional values.

**`datetime` / `timedelta`**  : Used to generate realistic dates and time periods.

**`os`**  : Used for output-directory and file handling.

---

### Reproducibility

A fixed random seed of **42** was used for Python's random generator and NumPy.
This makes the dataset generation reproducible when the same configuration is executed again.

---

### Generated CSV Files

| CSV File | Purpose |
|---|---|
| `ai_tools.csv` | AI tools, categories and pricing models |
| `users.csv` | User demographics and experience |
| `usage.csv` | AI usage and productivity activity |
| `subscriptions.csv` | Subscription plans, pricing and status |
| `payments.csv` | Payment transactions |

The five files form the raw data layer of the project.

---

### Realistic Data Modeling

The generator was designed to introduce meaningful relationships rather than independent random values.

Examples include:

- Weighted country distribution
- Weighted profession distribution
- Weighted experience-level distribution
- Profession-specific AI category preferences
- Different user activity profiles
- Category-specific usage intensity
- Prompt and token relationships
- Activity-based subscription probability
- Multiple subscriptions for higher-activity users

This makes the dataset suitable for realistic analytical questions involving adoption, engagement, productivity and monetization.

---

### Controlled Data Quality

A small amount of controlled missing data was intentionally introduced to simulate realistic data-quality conditions.

Approximately **1% of country values** were allowed to be NULL while critical fields remained populated.

This provided an opportunity to consider missing values and data-quality handling during SQL analysis.

---

### Dataset Generation Flow

```text
AI-Assisted Python Script → main.py → 5 CSV Datasets 
		→ PostgreSQL Import → Relational Database → SQL Analytics
```

The Python script is treated as the **data-generation layer** of the project; the analytical report focuses on the resulting data and the PostgreSQL analysis rather than reproducing the complete Python source code.

---

# 4. Database Architecture

The project contains five relational tables:

```text
                    ┌─────────────────┐
                    │    ai_tools     │
                    │─────────────────│
                    │ PK: tool_id     │
                    └────────┬────────┘
                             │
                 ┌───────────┴───────────┐
                 │                       │
                 ▼                       ▼
        ┌────────────────┐      ┌─────────────────┐
        │   usage_log    │      │  subscriptions  │
        │────────────────│      │─────────────────│
        │ PK: usage_id   │      │ PK: sub_id      │
        │ FK: user_id    │      │ FK: user_id     │
        │ FK: tool_id    │      │ FK: tool_id     │
        └───────┬────────┘      └────────┬────────┘
                │                        │
                │                        ▼
                │                ┌────────────────┐
                │                │    payments    │
                │                │────────────────│
                │                │ PK: payment_id │
                │                │ FK: sub_id     │
                │                └────────────────┘
                │
                ▼
        ┌────────────────┐
        │     users      │
        │────────────────│
        │ PK: user_id    │
        └────────────────┘
```

### Relationship Logic

- One user can have many usage records.
- One AI tool can appear across many usage records.
- One user can have multiple subscriptions.
- One AI tool can have multiple subscriptions.
- One subscription can generate multiple payments.

This relational structure allows the project to connect:

**User → AI Tool → Usage → Subscription → Payment → Revenue**

---

# 5. Table & Schema Documentation

## 5.1 `ai_tools`

### Purpose
Stores information about available AI tools.

| Column | Data Type | Key / Constraint |
|---|---|---|
| `tool_id` | INTEGER | **Primary Key** |
| `tool_name` | VARCHAR(100) | NOT NULL |
| `category` | VARCHAR(50) | NOT NULL + CHECK |
| `pricing_model` | VARCHAR(30) | NOT NULL + CHECK |

### Constraints

- `tool_id` uniquely identifies every AI tool.
- `tool_name` cannot be NULL.
- `category` must belong to the predefined AI categories.
- `pricing_model` must belong to the supported pricing models.

---

## 5.2 `users`

### Purpose
Stores demographic and experience information for users.

| Column | Data Type | Key / Constraint |
|---|---|---|
| `user_id` | INTEGER | **Primary Key** |
| `country` | VARCHAR(50) | Nullable |
| `profession` | VARCHAR(100) | NOT NULL |
| `experience_level` | VARCHAR(20) | CHECK |
| `created_at` | TIMESTAMP | NOT NULL |

### Constraints

- `user_id` is the unique identifier.
- `profession` cannot be NULL.
- `experience_level` is restricted to the supported experience levels.
- `country` is nullable to accommodate controlled missing-data scenarios.

---

## 5.3 `usage_log`

### Purpose
Stores user interaction with AI tools and productivity activity.

| Column | Data Type | Key / Constraint |
|---|---|---|
| `usage_id` | BIGINT | **Primary Key** |
| `user_id` | INTEGER | **FK → users** |
| `tool_id` | INTEGER | **FK → ai_tools** |
| `usage_date` | DATE | NOT NULL |
| `sessions` | INTEGER | NOT NULL + CHECK ≥ 0 |
| `prompts` | INTEGER | NOT NULL + CHECK ≥ 0 |
| `minutes_used` | INTEGER | NOT NULL + CHECK ≥ 0 |
| `tokens_used` | BIGINT | NOT NULL + CHECK ≥ 0 |
| `tasks_completed` | INTEGER | NOT NULL + CHECK ≥ 0 |

### Constraints

- `usage_id` is the primary key.
- `user_id` references `users`.
- `tool_id` references `ai_tools`.
- Usage metrics cannot contain negative values.
- Foreign keys use restrictive delete behavior.

---

## 5.4 `subscriptions`

### Purpose
Stores subscription plans, prices, dates and status.

| Column | Data Type | Key / Constraint |
|---|---|---|
| `subscription_id` | BIGINT | **Primary Key** |
| `user_id` | INTEGER | **FK → users** |
| `tool_id` | INTEGER | **FK → ai_tools** |
| `plan` | VARCHAR(20) | CHECK |
| `monthly_price` | NUMERIC(10,2) | CHECK ≥ 0 |
| `start_date` | DATE | NOT NULL |
| `end_date` | DATE | Nullable |
| `status` | VARCHAR(20) | CHECK |

### Constraints

- `subscription_id` is the primary key.
- `user_id` references `users`.
- `tool_id` references `ai_tools`.
- Plan values are restricted to supported plans.
- `monthly_price` cannot be negative.
- Status is restricted to `Active` or `Cancelled`.
- Subscription dates must remain logically valid.
- Status and end-date values must remain consistent.

---

## 5.5 `payments`

### Purpose
Stores payment transactions associated with subscriptions.

| Column | Data Type | Key / Constraint |
|---|---|---|
| `payment_id` | BIGINT | **Primary Key** |
| `subscription_id` | BIGINT | **FK → subscriptions** |
| `payment_date` | DATE | NOT NULL |
| `amount` | NUMERIC(10,2) | CHECK ≥ 0 |
| `payment_status` | VARCHAR(20) | CHECK |

### Constraints

- `payment_id` is the primary key.
- `subscription_id` references `subscriptions`.
- Payment amount cannot be negative.
- Payment status is restricted to `Success`, `Failed` or `Refunded`.

---

## 5.6 Indexing Strategy

Indexes were added to frequently filtered and joined columns including:

- `usage_log.user_id`
- `usage_log.tool_id`
- `usage_log.usage_date`
- `subscriptions.user_id`
- `subscriptions.tool_id`
- `subscriptions.start_date, end_date`
- `payments.subscription_id`
- `payments.payment_date`

The purpose is to support efficient joins, date filtering and analytical queries.

---

# 6. Data Loading & Analytical Workflow

The complete workflow is:

```text
Python Data Generation → Five CSV Files → PostgreSQL Import 
→ Schema + Constraints → Data Validation → Exploratory SQL → 
Business Questions → Results → Insights → Recommendations 
→ Final Business Story
```

The data was loaded according to table dependencies so that referenced records existed before dependent transactional data was inserted.

---

# 7. Analytical Methodology

The project uses practical PostgreSQL techniques including:

- Aggregations
- `GROUP BY`
- `HAVING`
- `INNER JOIN`
- `LEFT JOIN`
- `CASE`
- Subqueries
- CTEs
- Window Functions
- `DENSE_RANK()`
- `ROW_NUMBER()`
- `COUNT(DISTINCT ...)`
- Percentage calculations
- Conditional filtering
- Revenue analysis
- Subscription analysis
- User segmentation

The goal is not simply to retrieve data but to convert SQL results into meaningful business conclusions.

---

# 03 — SQL BUSINESS ANALYSIS

# 8. DATA EXPLORATION & SANITY CHECKS

## Q1.1 — Row Counts Across Every Table

### SQL Query

```sql
SELECT 'Ai Tools' AS table_name, COUNT(*) AS total_records FROM ai_tools
UNION ALL
SELECT 'Users', COUNT(*) FROM users
UNION ALL
SELECT 'Subscriptions', COUNT(*) FROM subscriptions
UNION ALL
SELECT 'Usage Log', COUNT(*) FROM usage_log
UNION ALL
SELECT 'Payments', COUNT(*) FROM payments;
```

### Result

| Table | Records |
|---|---:|
| AI Tools | 30 |
| Users | 10,000 |
| Subscriptions | 4,736 |
| Usage Log | 477,087 |
| Payments | 31,214 |

### Insight & Business Implication

The usage layer is the largest dataset, providing sufficient activity for behavioral, productivity and engagement analysis.

---

## Q1.2 — Users Overview

### SQL Query

```sql
SELECT
    COUNT(user_id) AS no_of_users,
    COUNT(DISTINCT country) AS total_countries,
    COUNT(DISTINCT profession) AS total_professions,
    COUNT(DISTINCT experience_level) AS total_experience_levels
FROM users;
```

### Result

**10,000 users | 18 countries | 12 professions | 4 experience levels**

### Insight & Business Implication

The dataset provides strong demographic segmentation for comparing AI behavior across geography, profession and experience.

---

## Q1.3 — AI Tools Overview

### SQL Query

```sql
SELECT
    COUNT(tool_id) AS total_tools,
    COUNT(DISTINCT category) AS total_categories,
    COUNT(DISTINCT pricing_model) AS pricing_models
FROM ai_tools;
```

### Result

**30 tools | 10 categories | 3 pricing models**

### Insight & Business Implication

The dataset covers a diverse AI ecosystem, allowing analysis across use cases and monetization models.

---

# 9. DEMOGRAPHIC ANALYSIS

## Q2.1 — Users by Experience Level

### SQL Query

```sql
SELECT experience_level, COUNT(*) AS number_of_users
FROM users
GROUP BY experience_level
ORDER BY number_of_users DESC;
```

### Result

| Experience Level | Users |
|---|---:|
| Intermediate | 3,528 |
| Beginner | 3,017 |
| Advanced | 2,479 |
| Expert | 976 |

### Insight & Business Implication

**65.45%** of users are Beginner or Intermediate, making onboarding, education and guided workflows important product opportunities.

---

## Q2.2 — Users by Profession

### SQL Query

```sql
SELECT profession, COUNT(*) AS number_of_users
FROM users
GROUP BY profession
ORDER BY number_of_users DESC;
```

### Result

Top segments:

| Profession | Users |
|---|---:|
| Student | 1,634 |
| Software Developer | 1,403 |
| Data Analyst | 1,001 |
| Marketing Specialist | 787 |
| Customer Support Specialist | 710 |

### Insight & Business Implication

Students and technical professionals form the largest segments, making education, coding and analytical workflows strong target areas.

---

## Q2.3 — Users by Country

### SQL Query

```sql
SELECT country, COUNT(*) AS number_of_users
FROM users
GROUP BY country
ORDER BY number_of_users DESC;
```

### Result

| Country | Users |
|---|---:|
| USA | 1,747 |
| India | 1,467 |
| Pakistan | 1,002 |
| United Kingdom | 801 |
| Canada | 704 |

### Insight & Business Implication

USA, India and Pakistan account for **42.16%** of users, making them important markets for targeted acquisition and localization.

---

## Q2.4 — Number of AI Tools per Category

### SQL Query

```sql
SELECT category, COUNT(*) AS number_of_tools
FROM ai_tools
GROUP BY category
ORDER BY number_of_tools DESC;
```

### Result

| Category | Tools |
|---|---:|
| Image Generation | 4 |
| Writing | 4 |
| Coding | 4 |
| Data Analysis | 3 |
| Research | 3 |

### Insight & Business Implication

Image Generation, Writing and Coding have the largest tool representation, indicating strong diversity and competition in these categories.

---

## Q2.5 — Pricing Model Distribution

### SQL Query

```sql
SELECT
    pricing_model,
    COUNT(*) AS number_of_tools,
    ROUND((COUNT(*)::NUMERIC / SUM(COUNT(*)) OVER()) * 100, 2) AS percentage
FROM ai_tools
GROUP BY pricing_model
ORDER BY percentage DESC;
```

### Result

| Pricing Model | Tools | Share |
|---|---:|---:|
| Freemium | 18 | 60% |
| Subscription | 9 | 30% |
| Free | 3 | 10% |

### Insight & Business Implication

Freemium dominates the tool ecosystem, making free access plus paid conversion the strongest observed monetization structure.

---

## Q2.6 — User Distribution by Country with Percentage

### SQL Query

```sql
SELECT
    country,
    COUNT(*) AS users_count,
    ROUND((COUNT(*)::NUMERIC / SUM(COUNT(*)) OVER()) * 100, 2) AS users_percentage
FROM users
GROUP BY country
ORDER BY users_percentage DESC;
```

### Result

**USA — 17.47% | India — 14.67% | Pakistan — 10.02%**

### Insight & Business Implication

User concentration across a few markets supports region-specific marketing and localization strategies.

---

## Q2.7 — User Distribution by Experience Level

### SQL Query

```sql
SELECT
    experience_level,
    COUNT(*) AS number_of_users,
    ROUND((COUNT(*)::NUMERIC / SUM(COUNT(*)) OVER()) * 100, 2) AS percentage
FROM users
GROUP BY experience_level
ORDER BY percentage DESC;
```

### Result

**Intermediate 35.28% | Beginner 30.17% | Advanced 24.79% | Expert 9.76%**

### Insight & Business Implication

The user base is concentrated below expert level, reinforcing the need for accessible onboarding and skill-building features.

---

## Q2.8 — Signups per Year

### SQL Query

```sql
SELECT
    EXTRACT(YEAR FROM created_at) AS signup_year,
    COUNT(*) AS total_signups
FROM users
GROUP BY EXTRACT(YEAR FROM created_at)
ORDER BY signup_year ASC;
```

### Result

| Year | Signups |
|---|---:|
| 2025 | 8,340 |
| 2026 | 1,660 |

### Insight & Business Implication

**83.4%** of users joined in 2025, making that cohort particularly relevant for retention and lifetime-value analysis.

---

## Q2.9 — Top 5 Countries by User Count

### SQL Query

```sql
SELECT
    COALESCE(country, 'Unknown') AS country_name,
    COUNT(*) AS total_users
FROM users
GROUP BY COALESCE(country, 'Unknown')
ORDER BY total_users DESC
LIMIT 5;
```

### Result

**USA, India, Pakistan, United Kingdom and Canada**

### Insight & Business Implication

These five countries represent the strongest geographic concentrations and should receive priority in regional growth analysis.

---

# 10. TOOL & PRICING ANALYSIS

## Q3.1 — All Free-Tier AI Tools

### SQL Query

```sql
SELECT *
FROM ai_tools
WHERE pricing_model = 'Free';
```

### Result

- Google Antigravity — Coding
- NotebookLM — Research
- NotebookLM — Education

### Insight & Business Implication

Free-tier tools span technical, research and educational use cases, providing accessible entry points for different user needs.

---

## Q3.2 — Freemium Coding or Research Tools

### SQL Query

```sql
SELECT tool_name, category, pricing_model
FROM ai_tools
WHERE pricing_model = 'Freemium'
  AND category IN ('Coding', 'Research');
```

### Result

- ChatGPT — Coding
- Claude — Coding
- Perplexity — Research
- Claude — Research

### Insight & Business Implication

General-purpose tools such as ChatGPT and Claude span multiple use cases, creating strong opportunities for cross-category adoption.

---

# 11. USAGE BEHAVIOR

## Q4.1 — Unique Users and Usage Records per Tool

### SQL Query

```sql
SELECT
    ait.tool_name,
    COUNT(DISTINCT ul.user_id) AS unique_users,
    COUNT(ul.usage_id) AS usage_records
FROM ai_tools ait
JOIN usage_log ul ON ait.tool_id = ul.tool_id
GROUP BY ait.tool_name
ORDER BY unique_users DESC;
```

### Result

| Tool | Unique Users | Usage Records |
|---|---:|---:|
| Claude | 9,075 | 77,898 |
| ChatGPT | 8,507 | 55,058 |
| NotebookLM | 7,644 | 47,775 |
| Jasper | 6,775 | 28,374 |
| Perplexity | 6,618 | 23,653 |

### Insight & Business Implication

Claude has the broadest reach and highest usage-record volume in this analysis, making it an important benchmark for adoption and engagement.

---

## Q4.2 — Usage Metrics per AI Category

### SQL Query

```sql
SELECT
    ai_tools.category,
    SUM(usage_log.sessions) AS total_sessions,
    SUM(usage_log.prompts) AS total_prompts,
    SUM(usage_log.tokens_used) AS total_tokens
FROM ai_tools
JOIN usage_log ON ai_tools.tool_id = usage_log.tool_id
GROUP BY ai_tools.category
ORDER BY total_tokens DESC;
```

### Result

| Category | Sessions | Prompts | Tokens |
|---|---:|---:|---:|
| Coding | 297,074 | 2,782,034 | 3.085B |
| Research | 311,409 | 2,777,996 | 3.046B |
| Writing | 314,657 | 2,681,577 | 2.942B |

### Insight & Business Implication

Coding, Research and Writing generate the heaviest AI workloads, making them strong candidates for product investment.

---

## Q4.3 — Registered Users Who Never Used AI

### SQL Query

```sql
SELECT users.user_id, users.country, users.profession
FROM users
LEFT JOIN usage_log
    ON users.user_id = usage_log.user_id
WHERE usage_log.user_id IS NULL;
```

### Result

**No rows returned.**

### Insight & Business Implication

Every registered user has AI activity, so the main challenge is not initial adoption but deeper engagement, retention and monetization.

---

## Q4.4 — Unique Users and Usage Records per Category

### SQL Query

```sql
SELECT
    ai_tools.category,
    COUNT(DISTINCT usage_log.user_id) AS unique_users,
    COUNT(usage_log.usage_id) AS total_usage_records,
    DENSE_RANK() OVER (
        ORDER BY COUNT(DISTINCT usage_log.user_id) DESC
    ) AS ranking
FROM ai_tools
JOIN usage_log ON ai_tools.tool_id = usage_log.tool_id
GROUP BY ai_tools.category
ORDER BY ranking;
```

### Result

| Rank | Category | Unique Users |
|---|---|---:|
| 1 | Writing | 8,873 |
| 2 | Research | 8,463 |
| 3 | Productivity | 7,646 |
| 4 | Education | 5,025 |
| 5 | Coding | 4,971 |

### Insight & Business Implication

Writing and Research have the broadest reach, while Coding shows strong usage intensity despite fewer unique users.

---

# 12. ADVANCED ANALYTICS

## Q5.1 — Most Common Experience Level Within Each Profession

### SQL Query

```sql
WITH experience_counts AS (
    SELECT
        profession,
        experience_level,
        COUNT(*) AS number_of_users,
        DENSE_RANK() OVER (
            PARTITION BY profession
            ORDER BY COUNT(*) DESC
        ) AS ranking
    FROM users
    GROUP BY profession, experience_level
)
SELECT profession, experience_level, number_of_users
FROM experience_counts
WHERE ranking = 1
ORDER BY number_of_users DESC;
```

### Result

Intermediate is the most common experience level for every profession except Researcher, where **Beginner and Intermediate tie at 154 users**.

### Insight & Business Implication

Professional users are not automatically advanced AI users. Experience-based personalization should complement profession-based segmentation.

---

## Q5.2 — AI Adoption Rate per Experience Level

### SQL Query

```sql
SELECT
    u.experience_level,
    COUNT(DISTINCT u.user_id) AS total_users,
    COUNT(DISTINCT ul.user_id) AS unique_ai_users,
    ROUND(
        COUNT(DISTINCT ul.user_id) * 100.0
        / COUNT(DISTINCT u.user_id), 2
    ) AS ai_adoption_percentage
FROM users u
LEFT JOIN usage_log ul
    ON u.user_id = ul.user_id
GROUP BY u.experience_level
ORDER BY ai_adoption_percentage DESC;
```

### Result

**Beginner — 100% | Intermediate — 100% | Advanced — 100% | Expert — 100%**

### Insight & Business Implication

Experience level does not differentiate adoption in this dataset. Future analysis should focus more on usage intensity, productivity and monetization.

---

## Q5.3 — Users Above Average Token Consumption

### SQL Query

```sql
WITH user_tokens AS (
    SELECT
        users.user_id,
        users.profession,
        SUM(usage_log.tokens_used) AS total_tokens_used
    FROM users
    JOIN usage_log
        ON users.user_id = usage_log.user_id
    GROUP BY users.user_id, users.profession
)
SELECT *
FROM user_tokens
WHERE total_tokens_used >
      (SELECT AVG(total_tokens_used) FROM user_tokens)
ORDER BY total_tokens_used DESC;
```

### Result

**2,421 users** exceed average token consumption.

Top observed users include Data Scientists and Software Developers, with individual consumption above **26M tokens**.

### Insight & Business Implication

Technical and analytical users appear prominently among high-intensity consumers, making them strong candidates for higher usage limits and premium offerings.

---

## Q5.4 — Most-Used AI Tool per Profession

### SQL Query

```sql
WITH ranking_cte AS (
    SELECT
        usage_log.tool_id,
        ai_tools.tool_name,
        users.profession,
        SUM(usage_log.prompts) AS prompts_used,
        DENSE_RANK() OVER (
            PARTITION BY users.profession
            ORDER BY SUM(usage_log.prompts) DESC
        ) AS ranking
    FROM usage_log
    JOIN ai_tools
        ON ai_tools.tool_id = usage_log.tool_id
    JOIN users
        ON users.user_id = usage_log.user_id
    GROUP BY usage_log.tool_id, ai_tools.tool_name, users.profession
)
SELECT tool_id, tool_name, profession, prompts_used
FROM ranking_cte
WHERE ranking = 1
ORDER BY prompts_used DESC;
```

### Result

| Profession | Dominant Tool | Prompts |
|---|---|---:|
| Software Developer | GitHub Copilot | 431,052 |
| Student | Khanmigo | 338,374 |
| Customer Support Specialist | Zendesk AI | 332,554 |
| Data Analyst | ChatGPT | 293,144 |
| Teacher | NotebookLM | 213,251 |
| Marketing Specialist | Canva Magic Studio | 192,923 |
| Data Scientist | ChatGPT | 167,860 |
| Researcher | NotebookLM | 145,208 |
| Business Analyst | ChatGPT | 138,452 |
| Designer | ChatGPT Images | 98,948 |
| Content Creator | ChatGPT | 90,653 |
| Entrepreneur | Jasper | 66,337 |

### Insight & Business Implication

AI preferences are strongly profession-specific. Role-based AI positioning and workflows are therefore more meaningful than a generic strategy.

---

## Q5.5 — Full Per-Tool Summary

### SQL Query

```sql
WITH tool_usage AS (
    SELECT
        tool_id,
        COUNT(DISTINCT user_id) AS unique_users,
        SUM(tasks_completed) AS total_tasks
    FROM usage_log
    GROUP BY tool_id
),
tool_revenue AS (
    SELECT
        s.tool_id,
        SUM(p.amount) AS total_revenue
    FROM subscriptions s
    JOIN payments p
        ON s.subscription_id = p.subscription_id
    WHERE s.status = 'Active'
    GROUP BY s.tool_id
)
SELECT
    t.tool_name,
    t.category,
    COALESCE(u.unique_users, 0) AS unique_users,
    COALESCE(u.total_tasks, 0) AS total_tasks,
    COALESCE(r.total_revenue, 0) AS total_revenue
FROM ai_tools t
LEFT JOIN tool_usage u
    ON t.tool_id = u.tool_id
LEFT JOIN tool_revenue r
    ON t.tool_id = r.tool_id;
```

### Result

Highest observed values include:

- **Research — NotebookLM:** 6,756 unique users
- **Education — NotebookLM:** 186,208 tasks
- **Education — Khanmigo:** $44,610.79 active-subscription revenue

### Insight & Business Implication

Tool performance differs by KPI. Adoption, productivity and revenue do not necessarily identify the same leader, so evaluation should use multiple KPIs.

---

## Q5.6 — Most Purchased Plan by Profession

### SQL Query

```sql
WITH profession_and_plan_cte AS (
    SELECT
        users.profession,
        subscriptions.plan,
        COUNT(subscriptions.subscription_id) AS total_purchases,
        DENSE_RANK() OVER (
            PARTITION BY users.profession
            ORDER BY COUNT(subscriptions.subscription_id) DESC
        ) AS ranking
    FROM users
    JOIN subscriptions
        ON users.user_id = subscriptions.user_id
    GROUP BY users.profession, subscriptions.plan
)
SELECT profession, plan, total_purchases
FROM profession_and_plan_cte
WHERE ranking = 1;
```

### Result

**Basic is the most purchased plan for all 12 professions.**

### Insight & Business Implication

Basic is the strongest entry point across professions, making it the natural base for upgrades into Pro, Team and Enterprise.

---

# 13. BUSINESS & REVENUE ANALYSIS

## Q6.1 — Active Subscriptions Created in 2025

### SQL Query

```sql
SELECT subscription_id, user_id, plan, monthly_price, start_date
FROM subscriptions
WHERE EXTRACT(YEAR FROM start_date) = 2025
  AND status = 'Active'
ORDER BY start_date;
```

### Result

**2,031 active subscriptions** were created in 2025.

### Insight & Business Implication

The 2025 cohort represents a substantial active subscription population and should be prioritized for retention, upgrades and lifetime-value analysis.

---

## Q6.2 — Revenue from Successful Payments by Category

### SQL Query

```sql
SELECT
    ai_tools.category,
    SUM(payments.amount) AS total_revenue
FROM ai_tools
JOIN subscriptions
    ON ai_tools.tool_id = subscriptions.tool_id
JOIN payments
    ON subscriptions.subscription_id = payments.subscription_id
WHERE payments.payment_status = 'Success'
GROUP BY ai_tools.category
ORDER BY total_revenue DESC;
```

### Result

| Category | Revenue |
|---|---:|
| Research | $133,760.15 |
| Writing | $132,876.27 |
| Coding | $115,556.51 |
| Data Analysis | $111,120.19 |
| Education | $89,595.91 |

### Insight & Business Implication

Research and Writing lead revenue while also demonstrating strong reach, making them attractive categories for product and monetization investment.

---

## Q6.3 — Users Completing More Than 500 Tasks

### SQL Query

```sql
WITH user_activity_cte AS (
    SELECT
        users.user_id,
        users.profession,
        SUM(usage_log.tasks_completed) AS total_tasks_completed
    FROM users
    JOIN usage_log
        ON users.user_id = usage_log.user_id
    GROUP BY users.user_id, users.profession
)
SELECT *
FROM user_activity_cte
WHERE total_tasks_completed > 500
ORDER BY total_tasks_completed DESC;
```

### Result

**2,437 users** completed more than 500 tasks.

### Insight & Business Implication

Nearly one-quarter of users are highly active, making them strong candidates for power-user features and premium upgrades.

---

## Q6.4 — Active Freemium-Tool Subscribers

### SQL Query

```sql
SELECT DISTINCT users.user_id, users.country
FROM users
JOIN subscriptions
    ON users.user_id = subscriptions.user_id
JOIN ai_tools
    ON ai_tools.tool_id = subscriptions.tool_id
WHERE ai_tools.pricing_model = 'Freemium'
  AND subscriptions.status = 'Active';
```

### Result

**2,257 users** are on active Freemium-tool subscriptions.

### Insight & Business Implication

Freemium has a substantial active subscription base, reinforcing its importance as an acquisition and monetization pathway.

---

## Q6.5 — Payment Value Tiers

### SQL Query

```sql
SELECT
    CASE
        WHEN amount > 50 THEN 'High Value'
        WHEN amount BETWEEN 20 AND 50 THEN 'Medium Value'
        WHEN amount < 20 THEN 'Low Value'
    END AS payment_category,
    COUNT(*) AS number_of_transactions,
    SUM(amount) AS total_revenue
FROM payments
GROUP BY payment_category;
```

### Result

| Tier | Transactions | Revenue |
|---|---:|---:|
| High Value | 5,648 | $464,553.52 |
| Medium Value | 10,154 | $253,748.46 |
| Low Value | 15,412 | $129,060.81 |

### Insight & Business Implication

High-value transactions represent only **18.1%** of transactions but generate the largest revenue contribution, making premium retention and upselling strategically important.

---

## Q6.6 — 2025 Users with More Than 50 Sessions

### SQL Query

```sql
WITH conditional_cte AS (
    SELECT
        users.user_id,
        users.profession,
        users.country,
        SUM(usage_log.sessions) AS total_sessions
    FROM users
    JOIN usage_log
        ON users.user_id = usage_log.user_id
    WHERE EXTRACT(YEAR FROM users.created_at) = 2025
    GROUP BY users.user_id, users.profession, users.country
)
SELECT *
FROM conditional_cte
WHERE total_sessions > 50;
```

### Result

**5,359 users** meet the condition.

### Insight & Business Implication

A large portion of the 2025 cohort demonstrates meaningful engagement, making this cohort valuable for retention and lifecycle analysis.

---

## Q6.7 — Monthly Recurring Revenue by Plan

### SQL Query

```sql
SELECT
    subscriptions.plan,
    COUNT(*) AS number_of_subscribers,
    SUM(monthly_price) AS monthly_revenue
FROM subscriptions
WHERE subscriptions.status = 'Active'
GROUP BY subscriptions.plan
ORDER BY monthly_revenue DESC;
```

### Result

| Plan | Subscribers | MRR |
|---|---:|---:|
| Team | 638 | $38,273.62 |
| Pro | 1,487 | $37,160.13 |
| Enterprise | 206 | $30,897.94 |
| Basic | 1,903 | $19,010.97 |

### Insight & Business Implication

Basic has the largest subscriber base, but higher-tier plans generate substantially more revenue per subscriber. Upselling is therefore a major monetization opportunity.

---

## Q6.8 — Active Subscriptions

### SQL Query

```sql
SELECT COUNT(*) AS active_subscriptions
FROM subscriptions
WHERE status = 'Active';
```

### Result

**4,234 active subscriptions**

### Insight & Business Implication

The active subscription base represents the core recurring-revenue population and should be central to retention and expansion analysis.

---

## Q6.9 — Cancelled Subscriptions

### SQL Query

```sql
SELECT COUNT(*) AS cancelled_subscriptions
FROM subscriptions
WHERE status = 'Cancelled';
```

### Result

**502 cancelled subscriptions**

### Insight & Business Implication

Cancellations represent approximately **10.6%** of subscriptions. Churn should be investigated by plan, tool, profession, country and subscription duration.

---

## Q6.10 — Users with More Than 2 Tool Categories Used

### SQL Query

```sql
WITH category_breadth_cte AS (
    SELECT
        users.user_id,
        users.profession,
        COUNT(DISTINCT ai_tools.category) AS cat_count
    FROM users
    JOIN usage_log
        ON users.user_id = usage_log.user_id
    JOIN ai_tools
        ON ai_tools.tool_id = usage_log.tool_id
    GROUP BY users.user_id, users.profession
)
SELECT *
FROM category_breadth_cte
WHERE cat_count >= 2;
```

### Result

**9,987 users** used at least 2 AI categories.

### Insight & Business Implication

Almost the entire user base demonstrates multi-category behavior, creating strong opportunities for cross-selling, bundles and personalized recommendations.

---

# 14. KEY BUSINESS QUESTIONS

## Q7.1 — Most Popular AI Tool

### SQL Query

```sql
SELECT
    ai_tools.tool_name,
    COUNT(DISTINCT usage_log.user_id) AS total_unique_users
FROM ai_tools
JOIN usage_log
    ON ai_tools.tool_id = usage_log.tool_id
GROUP BY ai_tools.tool_id, ai_tools.tool_name
ORDER BY total_unique_users DESC
LIMIT 1;
```

### Result

**NotebookLM — 6,756 unique users**

### Insight & Business Implication

NotebookLM has the highest unique-user reach in this specific query, making it a strong adoption benchmark.

---

## Q7.2 — Least Used AI Tool

### SQL Query

```sql
WITH ranking_cte AS (
    SELECT
        ai_tools.tool_name,
        COUNT(DISTINCT usage_log.user_id) AS total_unique_users,
        ROW_NUMBER() OVER (
            ORDER BY COUNT(DISTINCT usage_log.user_id)
        ) AS ranking_in_least_used
    FROM ai_tools
    JOIN usage_log
        ON ai_tools.tool_id = usage_log.tool_id
    GROUP BY ai_tools.tool_id, ai_tools.tool_name
)
SELECT tool_name, total_unique_users
FROM ranking_cte
WHERE ranking_in_least_used = 1;
```

### Result

**Intercom Fin — 694 unique users**

### Insight & Business Implication

Specialized tools have narrower reach than broad-use products, suggesting targeted B2B positioning may be more effective than mass-market acquisition.

---

## Q7.3 — Profession That Uses AI the Most

### SQL Query

```sql
SELECT
    users.profession,
    COUNT(DISTINCT usage_log.user_id) AS unique_users
FROM users
JOIN usage_log
    ON users.user_id = usage_log.user_id
GROUP BY users.profession
ORDER BY unique_users DESC
LIMIT 1;
```

### Result

**Student — 1,634 unique users**

### Insight & Business Implication

Students represent the largest AI-using profession segment, making education and student productivity important target opportunities.

---

## Q7.4 — Profession That Uses AI the Least

### SQL Query

```sql
SELECT
    users.profession,
    COUNT(usage_log.user_id) AS number_of_users
FROM users
JOIN usage_log
    ON users.user_id = usage_log.user_id
GROUP BY users.profession
ORDER BY number_of_users
LIMIT 1;
```

### Result

**Researcher — 22,782 usage records**

### Insight & Business Implication

This query measures **usage records rather than unique users**. Therefore, the result represents the profession with the lowest usage-record volume, not necessarily the fewest AI users.

---

## Q7.5 — Most Commonly Used Pricing Model

### SQL Query

```sql
SELECT
    ai_tools.pricing_model,
    COUNT(DISTINCT usage_log.user_id) AS number_of_users
FROM ai_tools
JOIN usage_log
    ON ai_tools.tool_id = usage_log.tool_id
GROUP BY pricing_model
ORDER BY number_of_users DESC
LIMIT 1;
```

### Result

**Freemium — 9,983 unique users**

### Insight & Business Implication

Freemium has the strongest user reach, supporting its role as the dominant acquisition and conversion model.

---

## Q7.6 — Least Used Pricing Model

### SQL Query

```sql
SELECT
    ai_tools.pricing_model,
    COUNT(DISTINCT usage_log.user_id) AS number_of_users
FROM ai_tools
JOIN usage_log
    ON ai_tools.tool_id = usage_log.tool_id
GROUP BY pricing_model
ORDER BY number_of_users
LIMIT 1;
```

### Result

**Free — 8,126 unique users**

### Insight & Business Implication

Free tools have the lowest reach among the pricing models in this query, while Freemium combines broader reach with a stronger monetization pathway.

---

# 04 — BUSINESS FINDINGS

# 15. CROSS-ANALYSIS: KEY FINDINGS

## 1. AI Adoption Is Universal

Every registered user has at least one AI usage record, and all four experience levels show 100% adoption.

**Business Meaning:** The priority should shift from basic adoption toward engagement depth, retention and monetization.

---

## 2. Freemium Dominates

Freemium represents **60% of tools** and reaches **9,983 users** in the pricing-model usage analysis.

**Business Meaning:** Freemium is the strongest acquisition model in this dataset and should be optimized for conversion.

---

## 3. Writing & Research Are High-Value Categories

Writing has the broadest category reach, while Research leads successful-payment revenue.

**Business Meaning:** Both categories combine strong reach with strong commercial potential.

---

## 4. Coding Is Highly Intensive

Coding generates approximately **3.085B tokens** and **2.782M prompts**.

**Business Meaning:** Coding users may generate high value through usage intensity even when their unique-user count is lower than broad-use categories.

---

## 5. Students Are a Major AI Segment

Students are both the largest profession group and the profession with the highest unique AI-user count.

**Business Meaning:** Education and student productivity are strategically important segments.

---

## 6. AI Preferences Depend on Profession

Different professions demonstrate different dominant tools.

**Business Meaning:** Role-specific workflows and marketing can outperform a generic one-size-fits-all strategy.

---

## 7. Basic Is the Main Entry Plan

Basic is the most purchased plan across all 12 professions and has the largest active subscriber base.

**Business Meaning:** Basic is the strongest acquisition layer, while Pro, Team and Enterprise represent upgrade opportunities.

---

## 8. Premium Plans Generate Stronger Revenue

Team produces the highest MRR despite having far fewer subscribers than Basic.

**Business Meaning:** Moving suitable users toward higher-value plans is a major monetization opportunity.

---

## 9. High-Value Transactions Drive Revenue

High-value payments represent only **18.1% of transactions** but generate **$464.55K** in revenue.

**Business Meaning:** Premium customers deserve disproportionate attention in retention and expansion strategies.

---

## 10. Cross-Category Usage Is Extremely High

**9,987 users** use at least two AI categories.

**Business Meaning:** Cross-selling and category bundles are strong opportunities because most users already demonstrate multi-use behavior.

---

# 16. BUSINESS INSIGHTS & STRATEGIC RECOMMENDATIONS

## Insight 1 — Shift From Adoption to Engagement

AI adoption is already universal within the dataset.

**Recommendation:** Focus future growth efforts on increasing sessions, prompts, task completion, retention and paid conversion rather than simply acquiring first-time users.

---

## Insight 2 — Optimize the Freemium Funnel

Freemium dominates both tool supply and user reach.

**Recommendation:** Improve free-to-paid conversion using usage limits, premium features, upgrade prompts and personalized offers.

---

## Insight 3 — Prioritize Research, Writing & Coding

These categories demonstrate strong combinations of reach, activity and revenue.

**Recommendation:** Prioritize product investment and feature development around these high-value AI workflows.

---

## Insight 4 — Build Profession-Specific Experiences

Different professions rely on different tools.

**Recommendation:** Create role-based templates, workflows, recommendations and marketing campaigns for students, developers, analysts, marketers, teachers and other major segments.

---

## Insight 5 — Convert Basic Users to Higher Plans

Basic has the largest subscriber base, while Team and Enterprise deliver stronger revenue per subscriber.

**Recommendation:** Build clear upgrade paths based on usage intensity, team requirements and advanced feature needs.

---

## Insight 6 — Protect High-Value Users

A small share of transactions produces a disproportionate share of revenue.

**Recommendation:** Prioritize retention, premium support, account management and loyalty strategies for high-value customers.

---

## Insight 7 — Target Power Users

**2,437 users** completed more than 500 tasks.

**Recommendation:** Offer power-user features, higher limits and premium plans to users with consistently high activity.

---

## Insight 8 — Expand Cross-Selling

Almost the entire user base uses multiple AI categories.

**Recommendation:** Introduce personalized recommendations, bundles and cross-category product offers.

---

# 17. DATA & ANALYTICAL CAVEATS

## Synthetic Dataset

The dataset is synthetic. Therefore, findings describe patterns **within this project dataset** and should not be presented as real-world AI market statistics.

## Universal Adoption

The 100% adoption result applies only to registered users within this dataset.

## Q7.4 Metric Definition

The query labeled "Profession that uses AI the least" counts usage records rather than distinct users.

Therefore, its result should be interpreted as the profession with the lowest **usage-record volume**.

## Tool-Level Revenue

The per-tool revenue query uses payments joined to **active subscriptions**, so its result should be interpreted according to that query definition rather than as lifetime revenue.

---

# 05 — PROJECT CONCLUSION

# 18. FINAL PROJECT STORY

## From AI Adoption to AI Business Value

The project started with a fundamental business question:

> **How are users adopting AI tools, and what does their usage reveal about productivity and business value?**

Using PostgreSQL, the analysis examined a synthetic dataset containing **10,000 users, 30 AI tools, 477,087 usage records, 4,736 subscriptions and 31,214 payments**.

The first stage established the shape of the dataset. Users span 18 countries, 12 professions and four experience levels, while the AI ecosystem covers 10 categories and three pricing models.

The demographic analysis showed that the user base is primarily Beginner-to-Intermediate, with Students, Software Developers and Data Analysts forming the largest professional segments. The USA, India and Pakistan are the strongest geographic markets.

The analysis then moved from:

> **Who uses AI?**

to:

> **How is AI being used?**

Writing and Research have the broadest category reach, while Coding, Research and Writing generate some of the highest usage intensity.

Different professions also demonstrate distinct tool preferences. Developers favor GitHub Copilot, students favor Khanmigo, customer-support professionals favor Zendesk AI, while analysts and data scientists heavily use ChatGPT.

The most important adoption finding is that every registered user has recorded AI activity.

This means the core business challenge in this dataset is not simply getting users to try AI.

It is getting them to:

> **derive more value from it.**

The monetization analysis reinforces this point.

Freemium is the dominant pricing model, while Basic is the most purchased plan across all professions.

However, Team and Enterprise generate substantially stronger revenue per subscriber, showing a clear opportunity for premium-plan expansion.

Payment analysis adds another layer: high-value transactions represent a minority of total transactions but contribute the largest revenue share.

The project therefore moves from a simple usage question to a broader business conclusion:

> **AI adoption alone does not define business success. The real value comes from engagement depth, productivity, premium conversion, cross-category usage and retention of high-value users.**

From a strategic perspective, the strongest path forward is to:

**Optimize the Freemium funnel → Build profession-specific experiences → Identify power users → Encourage premium upgrades → Expand cross-selling → Retain high-value customers**

In short:

> **The dataset shows a mature AI adoption environment where the next opportunity is not simply more users — it is more value per user.**

---

# 19. CONCLUSION

This project demonstrates how PostgreSQL can transform relational data into business-oriented analysis.

The workflow progressed through:

**Database Design → Data Generation → Data Validation → SQL Analysis → Business Questions → Results → Insights → Strategic Recommendations → Business Story**

The project applies practical SQL techniques including:

- Aggregations
- GROUP BY / HAVING
- JOINs
- CASE statements
- Subqueries
- CTEs
- Window Functions
- Ranking
- Conditional filtering
- Revenue analysis
- Subscription analysis
- User segmentation

More importantly, the project demonstrates the complete analytical mindset expected from a Data Analyst:

> **Ask the right question → query the data → interpret the result → identify the business meaning → recommend an action.**

This makes **AI Tools Usage & Productivity Analytics** a complete PostgreSQL analytics portfolio project rather than simply a collection of SQL queries.

---

# PROJECT AT A GLANCE

**Project:** AI Tools Usage & Productivity Analytics  
**Author:** Malik Waleed Hussain  
**GitHub:** `waleed4we`  
**Database:** PostgreSQL  
**Data Generation:** Python  
**Libraries:** Pandas, NumPy, Random, Datetime, OS  
**Tables:** 5  
**Users:** 10,000  
**AI Tools:** 30  
**Usage Records:** 477,087  
**Subscriptions:** 4,736  
**Payments:** 31,214  
**Analysis Period:** January 2025 – June 2026  
**Business Questions:** 40

---

## FINAL PROJECT MESSAGE

> **From raw AI usage data to actionable business intelligence — this project demonstrates the complete journey of a Data Analyst.**