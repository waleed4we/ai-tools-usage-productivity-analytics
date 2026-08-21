# 🤖 AI Tools Usage & Productivity Analytics

<p align="center">
  <img src="https://img.shields.io/badge/PostgreSQL-4169E1?style=for-the-badge&logo=postgresql&logoColor=white" alt="PostgreSQL"/>
  <img src="https://img.shields.io/badge/pgAdmin-336791?style=for-the-badge&logo=postgresql&logoColor=white" alt="pgAdmin"/>
  <img src="https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white" alt="Python"/>
  <img src="https://img.shields.io/badge/Pandas-150458?style=for-the-badge&logo=pandas&logoColor=white" alt="Pandas"/>
  <img src="https://img.shields.io/badge/NumPy-013243?style=for-the-badge&logo=numpy&logoColor=white" alt="NumPy"/>
  <img src="https://img.shields.io/badge/psycopg2--binary-336791?style=for-the-badge&logo=postgresql&logoColor=white" alt="psycopg2-binary"/>
  <img src="https://img.shields.io/badge/ChatGPT-412991?style=for-the-badge&logo=openai&logoColor=white" alt="ChatGPT"/>
</p>

<p align="center"><b>An end-to-end PostgreSQL analytics project exploring AI tool adoption, usage behavior, productivity, subscriptions, and revenue.</b></p>

---

## 📌 Overview

This project uses a **synthetically generated relational dataset** (users, AI tools, usage, subscriptions, payments) to answer practical business questions: who uses AI tools, which tools/categories dominate, how usage varies by profession and experience, which pricing models and plans perform best, and where the strongest monetization opportunities lie.

**Pipeline:** Data Generation → Database Design → Loading → Validation → SQL Analysis → Business Findings → Recommendations

---

## 🗃️ Database Architecture

Five interconnected tables model the relationships below:

```
ai_tools ──┬── usage_log ── users
           └── subscriptions ── payments
```

- One user → many usage records & subscriptions
- One AI tool → many usage records & subscriptions
- One subscription → many payments

| Table | Key Fields | Purpose |
|---|---|---|
| 🤖 `ai_tools` | Tool ID, Name, Category, Pricing Model | Tool/category adoption & pricing |
| 👤 `users` | User ID, Country, Profession, Experience, Signup Date | Segmentation, geography |
| 📈 `usage_log` | Usage ID, User/Tool ID, Sessions, Prompts, Tokens, Tasks | Engagement & productivity |
| 💳 `subscriptions` | Sub ID, User/Tool ID, Plan, Price, Dates, Status | Plan adoption, MRR |
| 💰 `payments` | Payment ID, Sub ID, Date, Amount, Status | Revenue |

---

## 📊 Dataset

Synthetic data covering **January 2025 – June 2026**, generated in Python (`generate_datasets.py`) using weighted distributions (country, profession, experience, profession-specific tool preferences) with ~1% controlled missing data for realism.

| Metric | Value | Metric | Value |
|---|---|---|---|
| 👤 Users | 10,000 | 🗂️ AI Categories | 10 |
| 🤖 AI Tools | 30 | 💵 Pricing Models | 3 |
| 📝 Usage Records | 477,087 | 🌍 Countries | 18 |
| 💳 Subscriptions | 4,736 | 💼 Professions | 12 |
| 💰 Payments | 31,214 | 🎓 Experience Levels | 4 |

---

## 🐘 PostgreSQL Analysis

Analysis leverages joins, CTEs, window functions (`DENSE_RANK`, `ROW_NUMBER`), subqueries, `CASE` logic, and aggregations across demographic, tool/category, pricing, usage, experience-level, revenue, and cross-category dimensions.

> Full SQL queries are kept in the project's `sql/` folder rather than in this README.

---

## 📈 Key Results

**Experience & Profession** — Intermediate (3,528) and Beginner (3,017) users make up 65% of the base; Students (1,634) and Software Developers (1,403) are the largest professional segments.

**Geography** — USA, India, and Pakistan account for 42% of users.

**Pricing Models**

| Model | Tools | Share |
|---|---|---|
| Freemium | 18 | 60% |
| Subscription | 9 | 30% |
| Free | 3 | 10% |

**Top Tools by Adoption**

| Tool | Unique Users | Usage Records |
|---|---|---|
| Claude | 9,075 | 77,898 |
| ChatGPT | 8,507 | 55,058 |
| NotebookLM | 7,644 | 47,775 |

**Highest-Intensity Categories** — Coding, Research, and Writing lead in sessions, prompts, and tokens consumed (each in the billions of tokens).

**Revenue by Category** — Research ($133.8K) and Writing ($132.9K) lead, followed by Coding ($115.6K) and Data Analysis ($111.1K).

**Subscription Plans** — Basic has the most subscribers (1,903) but Team generates the highest MRR ($38.3K) despite fewer subscribers (638), highlighting strong upsell potential.

---

## 🧠 Key Findings

1. **AI adoption is universal** — every user has at least one usage record across all experience levels; growth should focus on engagement, retention, and monetization rather than acquisition.
2. **Freemium dominates** (60% of tools), making it the primary acquisition-to-conversion funnel.
3. **Writing & Research** are the highest-value categories for product investment.
4. **Coding** shows disproportionately high usage intensity relative to its user count.
5. **Students** are the largest professional segment, signaling an education-focused opportunity.
6. **Tool preference is profession-specific** (e.g., Developers → GitHub Copilot, Students → Khanmigo, Analysts → ChatGPT, Researchers/Teachers → NotebookLM).
7. **Basic is the entry plan** across all professions, with Pro/Team/Enterprise as natural upgrades.
8. **Cross-category usage is extremely high** — 9,987 users engage with 2+ categories, creating strong cross-sell and bundling potential.

---

## 💡 Strategic Recommendations

- **Shift focus from adoption to engagement** — drive sessions, prompts, task completion, and paid conversion.
- **Optimize the Freemium funnel** with usage limits, premium features, and targeted upgrade prompts.
- **Build profession-specific experiences** for high-value segments (students, developers, analysts, marketers).
- **Target premium upgrades** toward high-usage users based on tokens, sessions, and task completion.
- **Protect high-value users** with stronger retention, support, and loyalty programs.

---

## ⚠️ Caveats

This is a **synthetic dataset** — findings reflect patterns within the data, not real-world AI market statistics. Metrics like "usage records" vs. "unique users" and revenue figures are scoped to specific query definitions rather than lifetime totals.

---

## 🛠️ Technologies

| Technology | Purpose |
|---|---|
| 🐘 PostgreSQL | Relational database & SQL analytics |
| 🖥️ pgAdmin | Database management & query execution |
| 🐍 Python | Synthetic dataset generation |
| 🐼 Pandas / 🔢 NumPy | Data generation & manipulation |
| 🔌 psycopg2-binary | PostgreSQL connectivity |

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

Then create a PostgreSQL database, load the CSVs in dependency order (`ai_tools → users → subscriptions → usage_log → payments`), and run `sql/project_analysis.sql` in pgAdmin or your preferred SQL client.

---

## 👨‍💻 Author

**Malik Waleed Hussain**
Data Analytics / Computer Science Student
