<div align="center">

# 🤖 AI Tools Usage & Productivity Analytics

### *Turning raw AI usage data into real useful business insights*

<img src="https://img.shields.io/badge/PostgreSQL-4169E1?style=for-the-badge&logo=postgresql&logoColor=white" alt="PostgreSQL"/>
<img src="https://img.shields.io/badge/pgAdmin-336791?style=for-the-badge&logo=postgresql&logoColor=white" alt="pgAdmin"/>
<img src="https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white" alt="Python"/>
<img src="https://img.shields.io/badge/Pandas-150458?style=for-the-badge&logo=pandas&logoColor=white" alt="Pandas"/>
<img src="https://img.shields.io/badge/NumPy-013243?style=for-the-badge&logo=numpy&logoColor=white" alt="NumPy"/>
<img src="https://img.shields.io/badge/psycopg2--binary-336791?style=for-the-badge&logo=postgresql&logoColor=white" alt="psycopg2-binary"/>
<img src="https://img.shields.io/badge/ChatGPT-412991?style=for-the-badge&logo=openai&logoColor=white" alt="ChatGPT"/>

<br/>
<br/>

<img src="https://img.shields.io/badge/Users-10%2C000-blueviolet?style=flat-square"/>
<img src="https://img.shields.io/badge/AI%20Tools-30-blue?style=flat-square"/>
<img src="https://img.shields.io/badge/Usage%20Records-477%2C087-success?style=flat-square"/>
<img src="https://img.shields.io/badge/Subscriptions-4%2C736-orange?style=flat-square"/>
<img src="https://img.shields.io/badge/Payments-31%2C214-red?style=flat-square"/>

</div>
<br>
An End-To-End **PostgreSQL analytics project** exploring AI tools adoption, usage behavior, productivity, subscriptions, and revenue — built on a synthetically generated relational dataset of users, AI tools, usage activity, subscriptions, and payments.
<br/>

**Pipeline :**  Data Generation → Database Design → Loading → Validation → SQL Analysis → Business Findings → Recommendations


## 📌 Overview

This project answers practical business questions: **who** uses AI tools, **which** tools and categories dominate, **how** usage varies by profession and experience level, **which** pricing models and plans perform best, and **where** the strongest monetization opportunities lie.

---

## 🗃️ Database Architecture

<div align="center">

```
                    ┌─────────────┐
                    │  ai_tools   │
                    └──────┬──────┘
                ┌───────────┴───────────┐
                ▼                       ▼
        ┌──────────────┐        ┌─────────────────┐
        │  usage_log   │        │  subscriptions   │
        └──────┬───────┘        └────────┬─────────┘
               ▼                         ▼
        ┌──────────────┐        ┌─────────────────┐
        │    users     │        │    payments      │
        └──────────────┘        └─────────────────┘
```

</div>

- One user → many usage records & subscriptions
- One AI tool → many usage records & subscriptions
- One subscription → many payments

<div align="center">

| Table | Key Fields | Purpose |
|:---:|:---|:---|
| 🤖 `ai_tools` | Tool ID · Name · Category · Pricing Model | Tool/category adoption & pricing |
| 👤 `users` | User ID · Country · Profession · Experience · Signup Date | Segmentation, geography |
| 📈 `usage_log` | Usage ID · User/Tool ID · Sessions · Prompts · Tokens · Tasks | Engagement & productivity |
| 💳 `subscriptions` | Sub ID · User/Tool ID · Plan · Price · Dates · Status | Plan adoption, MRR |
| 💰 `payments` | Payment ID · Sub ID · Date · Amount · Status | Revenue |

</div>

---

## 📊 Dataset

Synthetic data spanning **January 2025 – June 2026**, generated in Python (`generate_datasets.py`) using weighted distributions across country, profession, experience, and profession-specific tool preferences — with ~1% controlled missing data for realism.

<div align="center">

| 👤 Users | 🤖 AI Tools | 📝 Usage Records | 💳 Subscriptions | 💰 Payments |
|:---:|:---:|:---:|:---:|:---:|
| **10,000** | **30** | **477,087** | **4,736** | **31,214** |

| 🌍 Countries | 💼 Professions | 🎓 Experience Levels | 🗂️ AI Categories | 💵 Pricing Models |
|:---:|:---:|:---:|:---:|:---:|
| **18** | **12** | **4** | **10** | **3** |

</div>

---

## 🐘 PostgreSQL Analysis

<details>
<summary><b>Click to see the SQL techniques used</b></summary>
<br>

- Aggregations & `GROUP BY` / `HAVING`
- `INNER JOIN` / `LEFT JOIN`
- `CASE` expressions & conditional filtering
- Subqueries & CTEs
- Window functions — `DENSE_RANK()`, `ROW_NUMBER()`
- `COUNT(DISTINCT ...)` & percentage calculations
- Revenue, subscription, and user-segmentation analysis

</details>

> [!TIP]
> Full SQL queries live in the project's [`sql/`](./sql) folder rather than in this README, to keep things skimmable.

---

## 📈 Key Results

**🎓 Experience & 💼 Profession**
Intermediate (3,528) and Beginner (3,017) users make up **65%** of the base. Students (1,634) and Software Developers (1,403) are the largest professional segments.

**🌍 Geography**
USA, India, and Pakistan together account for **42%** of all users.

<table align="center">
<tr>
<td valign="top">

**Pricing Models**

| Model | Tools | Share |
|:---|:---:|:---:|
| Freemium | 18 | 60% |
| Subscription | 9 | 30% |
| Free | 3 | 10% |

</td>
<td valign="top">

**Top Tools by Adoption**

| Tool | Users | Records |
|:---|:---:|:---:|
| Claude | 9,075 | 77,898 |
| ChatGPT | 8,507 | 55,058 |
| NotebookLM | 7,644 | 47,775 |

</td>
</tr>
</table>

**🔥 Highest-Intensity Categories** — Coding, Research, and Writing lead in sessions, prompts, and tokens, each consuming **billions of tokens**.

**💰 Revenue by Category** — Research ($133.8K) and Writing ($132.9K) lead, followed by Coding ($115.6K) and Data Analysis ($111.1K).

**💳 Subscription Plans** — Basic has the most subscribers (1,903), but **Team generates the highest MRR** ($38.3K) with far fewer subscribers (638) — a clear upsell signal.

---

## 🧠 Key Findings

| # | Finding | Business Meaning |
|:---:|:---|:---|
| 1 | **AI adoption is universal** — every user has ≥1 usage record | Focus shifts from acquisition to engagement & monetization |
| 2 | **Freemium dominates** (60% of tools) | Primary acquisition-to-conversion funnel |
| 3 | **Writing & Research** are top-value categories | Strong candidates for product investment |
| 4 | **Coding** shows disproportionately high intensity | High value per user despite lower reach |
| 5 | **Students** are the largest segment | Education-focused product opportunity |
| 6 | **Tool preference is profession-specific** | Role-based workflows beat one-size-fits-all |
| 7 | **Basic is the universal entry plan** | Pro/Team/Enterprise are natural upgrade paths |
| 8 | **Cross-category usage is high** — 9,987 users use 2+ categories | Strong cross-sell & bundling potential |

---

## 💡 Strategic Recommendations

- 🚀 **Shift focus from adoption to engagement** — drive sessions, prompts, task completion, and paid conversion
- 💰 **Optimize the Freemium funnel** with usage limits, premium features, and targeted upgrade prompts
- 🎯 **Build profession-specific experiences** for high-value segments
- 💳 **Target premium upgrades** toward high-usage users
- ⭐ **Protect high-value users** with stronger retention, support, and loyalty programs

---

## ⚠️ Caveats

> [!WARNING]
> This is a **synthetic dataset** — findings reflect patterns within the data, not real-world AI market statistics. Metrics like "usage records" vs. "unique users," and revenue figures, are scoped to specific query definitions rather than lifetime totals.

---

## 🛠️ Technologies

<div align="center">

| Technology | Purpose |
|:---:|:---|
| 🐘 PostgreSQL | Relational database & SQL analytics |
| 🖥️ pgAdmin | Database management & query execution |
| 🐍 Python | Synthetic dataset generation |
| 🐼 Pandas / 🔢 NumPy | Data generation & manipulation |
| 🔌 psycopg2-binary | PostgreSQL connectivity |

</div>

---

## 📁 Project Structure

```
AI-Tools-Usage-Analytics/
├── README.md
├── documentation/
│   ├── PROJECT_DOCUMENTATION.pdf
│   └── raw_detailed_description.md
├── python/
│   ├── generate_datasets.py
│   └── export_query_results.py
├── sql/
│   └── project_analysis.sql
└── data/
    ├── ai_tools.csv
    ├── users.csv
    ├── usage_log.csv
    ├── subscriptions.csv
    └── payments.csv
```

---

## ⚙️ How to Run

```bash
# 1. Clone the repository
git clone https://github.com/waleed4we/AI-Tools-Usage-Analytics.git
cd AI-Tools-Usage-Analytics

# 2. Install dependencies
pip install pandas numpy psycopg2-binary

# 3. Generate the dataset
python python/generate_datasets.py
```

Then create a PostgreSQL database, load the CSVs in dependency order
(`ai_tools → users → subscriptions → usage_log → payments`), and run
[`sql/project_analysis.sql`](./sql/project_analysis.sql) in pgAdmin or your preferred SQL client.

---

<div align="center">

## 👨‍💻 Author

**Malik Waleed Hussain**
*Data Analytics / Computer Science Student*

</div>
