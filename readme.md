
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

<p align="center">
  <b>PostgreSQL Data Analytics  Project</b>
</p>

<p align="center">
  An end-to-end analytics project exploring AI tool adoption, usage behavior,
  productivity, subscriptions, and revenue.
</p>

---

## 📌 Project Overview

**AI Tools Usage & Productivity Analytics** is a PostgreSQL-based data analytics portfolio project designed to explore how users interact with AI tools and how that usage translates into productivity, subscriptions, and revenue.

The project uses a **synthetically generated relational dataset** containing users, AI tools, usage activity, subscriptions, and payment transactions.

The analysis moves beyond basic SQL querying and focuses on answering practical business questions such as:

- Who uses AI tools?
- Which AI tools and categories are most popular?
- How frequently are AI tools being used?
- How does usage differ across professions and experience levels?
- Which pricing models have the strongest reach?
- Which categories generate the most revenue?
- Which users demonstrate high productivity?
- Which subscription plans are most popular?
- Where are the strongest monetization opportunities?
- What strategic actions can be derived from the data?


**Data Generation → Database Design → Data Loading → Validation → SQL Analysis → Business Findings → Strategic Recommendations**

---

## 🎯 Project Objectives

The main objectives of this project are to:

- Analyze AI adoption across different user segments.
- Understand AI usage patterns and behavioral trends.
- Compare AI tool categories and individual tools.
- Analyze AI usage across professions.
- Analyze AI usage across experience levels.
- Examine geographic user distribution.
- Analyze AI pricing models.

---

# 🗃️ Database & Data Architecture

The project uses a relational PostgreSQL database consisting of **five interconnected tables**.

### Database Relationship

```text
                         ┌─────────────────┐
                         │    ai_tools     │
                         │─────────────────│
                         │ PK: tool_id     │
                         └────────┬────────┘
                                  │
                     ┌────────────┴────────────┐
                     │                         │
                     ▼                         ▼
            ┌────────────────┐       ┌─────────────────┐
            │   usage_log    │       │  subscriptions  │
            │────────────────│       │─────────────────│
            │ PK: usage_id   │       │ PK: sub_id      │
            │ FK: user_id    │       │ FK: user_id     │
            │ FK: tool_id    │       │ FK: tool_id     │
            └───────┬────────┘       └────────┬────────┘
                    │                         │
                    │                         ▼
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

The database models the following relationships:

- One user can have many usage records.
- One AI tool can appear across many usage records.
- One user can have multiple subscriptions.
- One AI tool can have multiple subscriptions.
- One subscription can generate multiple payments.

---

# 📊 Dataset

The dataset is **synthetically generated** specifically for this portfolio project.
It represents AI usage and productivity activity between:
**January 2025 – June 2026**

### Dataset Statistics

| Metric               | Value       |
| -------------------- | ----------- |
| 👤 Users             | **10,000**  |
| 🤖 AI Tools          | **30**      |
| 📝 Usage Records     | **477,087** |
| 💳 Subscriptions     | **4,736**   |
| 💰 Payments          | **31,214**  |
| 🌍 Countries         | **18**      |
| 💼 Professions       | **12**      |
| 🎓 Experience Levels | **4**       |
| 🗂️ AI Categories    | **10**      |
| 💵 Pricing Models    | **3**       |

---

## 📁 Dataset Files

The raw datasets are generated as CSV files:

| File                | Description                                    |
| ------------------- | ---------------------------------------------- |
| `ai_tools.csv`      | AI tools, categories, and pricing models       |
| `users.csv`         | User demographics and experience information   |
| `usage.csv`         | AI usage and productivity activity             |
| `subscriptions.csv` | Subscription plans, pricing, dates, and status |
| `payments.csv`      | Payment transactions                           |

---

# ## 🧱 Database Tables

| Table              | Description                                                     | Main Information                                                                                      | Purpose                                                                                                                       |
| ------------------ | --------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| 🤖 `ai_tools`      | Stores information about the AI tools available in the dataset. | Tool ID, Tool Name, AI Category, Pricing Model                                                        | Tool adoption, AI categories, pricing models, tool popularity, tool-level usage, tool-level revenue                           |
| 👤 `users`         | Stores demographic and experience information about users.      | User ID, Country, Profession, Experience Level, Account Creation Date                                 | Geographic distribution, professional segments, experience levels, signup trends, user segmentation                           |
| 📈 `usage_log`     | Stores AI interaction and productivity activity.                | Usage ID, User ID, Tool ID, Usage Date, Sessions, Prompts, Minutes Used, Tokens Used, Tasks Completed | AI engagement, usage intensity, prompt activity, token consumption, productivity, user behavior, tool popularity              |
| 💳 `subscriptions` | Stores subscription information.                                | Subscription ID, User ID, Tool ID, Plan, Monthly Price, Start Date, End Date, Subscription Status     | Subscription adoption, plan popularity, active subscriptions, cancellations, monthly recurring revenue, upgrade opportunities |
| 💰 `payments`      | Stores payment transactions linked to subscriptions.            | Payment ID, Subscription ID, Payment Date, Amount, Payment Status                                     | Successful payments, revenue, payment value tiers, revenue by category, transaction behavior                                  |

---

# 🐍 Python Data Generation

The dataset was generated using Python through a dedicated script:

```
generate_datasets.py
```

The Python generation layer was designed to create realistic relationships between users, tools, usage, subscriptions, and payments instead of generating completely independent random values.

### Python Libraries

The data-generation process uses:

- **Python `random`** — randomized behavioral and transactional values.
- **NumPy** — numerical operations, probabilistic sampling, and weighted distributions.
- **Pandas** — DataFrame creation, manipulation, and CSV export.
- **datetime / timedelta** — realistic date and time generation.
- **os** — file and directory handling.

### Controlled Data Generation

The generator includes relationships such as:

- Weighted country distribution
- Weighted profession distribution
- Weighted experience levels
- Profession-specific AI category preferences
- Different user activity profiles

A small amount of controlled missing data was also introduced to simulate realistic data-quality conditions.
Approximately **1% of country values** may be NULL while critical fields remain populated.

---

# 🐘 PostgreSQL Analysis

PostgreSQL is the primary analytical database used in this project.
The SQL analysis focuses on transforming raw relational data into business-oriented insights.

### Analytical Techniques Used

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

> SQL queries are intentionally not included in this README. The complete SQL analysis is available separately inside the project's SQL folder.

---

# 🔍 Analytical Areas

The project covers several major analytical areas.
## 👥 Demographic Analysis

Analyzes users based on:
- Country
- Profession
- Experience level
- Signup year

Key segments include:
- Students
- Software Developers
- Data Analysts
- Marketing Specialists
- Customer Support Specialists

---

## 🤖 AI Tool & Category Analysis

Explores:

- Tool popularity
- Category distribution
- Unique users per tool
- Usage records per tool
- AI categories with the strongest activity
- Tool representation by category

---

## 💰 Pricing Model Analysis

Examines:

- Free tools
- Freemium tools
- Subscription-based tools
- Pricing-model reach
- Pricing-model adoption

---

## 📈 Usage Behavior Analysis

Analyzes:

- Sessions
- Prompts
- Tokens
- Minutes used
- Tasks completed
- Unique users
- Usage records
- Usage intensity

---

## 🎓 Experience-Level Analysis

Compares AI behavior across:

- Beginner
- Intermediate
- Advanced
- Expert

The analysis examines whether experience level meaningfully differentiates AI adoption and engagement.

---

## 💵 Revenue Analysis

Analyzes:

- Successful payment revenue
- Revenue by AI category
- Revenue by subscription plan
- Payment value tiers
- High-value transactions
- Active-subscription revenue

---

## 🔄 Cross-Category Usage

The project also analyzes how many different AI categories users interact with.

This helps identify opportunities for:

- Cross-selling
- Bundling
- Personalized recommendations
- Multi-product adoption

---

# 📈 Key Analysis Results

## 👥 User Distribution

The largest experience-level segments are:

| Experience Level | Users |
| ---------------- | ----- |
| Intermediate     | 3,528 |
| Beginner         | 3,017 |
| Advanced         | 2,479 |
| Expert           | 976   |

**65.45%** of users are Beginner or Intermediate.

---

## 💼 Largest Professional Segments

The largest professional groups include:

| Profession                  | Users |
| --------------------------- | ----- |
| Student                     | 1,634 |
| Software Developer          | 1,403 |
| Data Analyst                | 1,001 |
| Marketing Specialist        | 787   |
| Customer Support Specialist | 710   |

---

## 🌍 Largest Geographic Segments

|Country|Users|
|---|---|
|USA|1,747|
|India|1,467|
|Pakistan|1,002|
|United Kingdom|801|
|Canada|704|

USA, India, and Pakistan together account for **42.16%** of the user base.

---

## 💵 Pricing Model Distribution

|Pricing Model|Tools|Share|
|---|---|---|
|Freemium|18|60%|
|Subscription|9|30%|
|Free|3|10%|

Freemium represents the largest pricing model within the AI tool ecosystem.

---

## 🤖 Tool Usage

The analysis identified strong adoption among several major tools.

Examples include:

|Tool|Unique Users|Usage Records|
|---|---|---|
|Claude|9,075|77,898|
|ChatGPT|8,507|55,058|
|NotebookLM|7,644|47,775|
|Jasper|6,775|28,374|
|Perplexity|6,618|23,653|

---

## 📊 Category Usage

Several categories demonstrate particularly high usage intensity:

|Category|Sessions|Prompts|Tokens|
|---|---|---|---|
|Coding|297,074|2,782,034|3.085B|
|Research|311,409|2,777,996|3.046B|
|Writing|314,657|2,681,577|2.942B|

Coding, Research, and Writing represent some of the highest-intensity AI workloads in the dataset.

---

## 💰 Revenue by Category

Successful payment revenue by category shows:

|Category|Revenue|
|---|---|
|Research|$133,760.15|
|Writing|$132,876.27|
|Coding|$115,556.51|
|Data Analysis|$111,120.19|
|Education|$89,595.91|

Research and Writing lead the observed revenue results.

---

## 💳 Subscription Plan Performance

Active subscription analysis shows:

|Plan|Subscribers|MRR|
|---|---|---|
|Team|638|$38,273.62|
|Pro|1,487|$37,160.13|
|Enterprise|206|$30,897.94|
|Basic|1,903|$19,010.97|

Basic has the largest subscriber base, while higher-tier plans generate substantially more revenue per subscriber.

---

# 🧠 Key Business Findings

## 1. AI Adoption Is Universal

Every registered user has at least one AI usage record.

All four experience levels also show **100% AI adoption** within this dataset.
### Business Meaning

The opportunity is less about initial adoption and more about:
- Engagement
- Productivity
- Retention
- Monetization
- Expansion

---

## 2. Freemium Is the Dominant Model

Freemium represents **60% of the AI tools** in the dataset.
### Business Meaning
Freemium provides a strong acquisition layer and creates opportunities for free-to-paid conversion.

---

## 3. Writing & Research Are High-Value Categories

Writing and Research demonstrate strong reach and commercial performance.
### Business Meaning
These categories represent strong candidates for product investment and monetization initiatives.

---

## 4. Coding Shows High Usage Intensity

Coding generates approximately:
- **3.085B tokens**
- **2.782M prompts**
### Business Meaning
Coding users may generate substantial value through intensive usage, even when their unique-user count is lower than broader categories.

---

## 5. Students Are a Major AI User Segment

Students are the largest professional segment in the dataset.
### Business Meaning
Education and student productivity represent important opportunities for AI products and services.

---

## 6. AI Preferences Are Profession-Specific

Different professions show different dominant tools.

Examples include:
- Software Developers → GitHub Copilot
- Students → Khanmigo
- Customer Support Specialists → Zendesk AI
- Data Analysts → ChatGPT
- Teachers → NotebookLM
- Marketing Specialists → Canva Magic Studio
- Researchers → NotebookLM

### Business Meaning
Role-specific AI workflows can be more effective than a generic one-size-fits-all strategy.

---

## 7. Basic Is the Main Entry Plan

Basic is the most purchased plan across all 12 professions.
### Business Meaning
Basic acts as the strongest entry layer, while Pro, Team, and Enterprise provide natural upgrade opportunities.

---

## 8. Premium Plans Generate Stronger Revenue

Team generates the highest MRR despite having significantly fewer subscribers than Basic.
### Business Meaning
Upselling suitable Basic users into higher-value plans is a major monetization opportunity.

---
## 9. Cross-Category Usage Is Extremely High

**9,987 users** used at least two AI categories.
### Business Meaning
The high level of multi-category usage creates opportunities for:

- Personalized recommendations
- Bundles
- Cross-selling
- Category expansion

---

# 💡 Strategic Recommendations

## 🚀 1. Shift From Adoption to Engagement

Since adoption is already universal in this synthetic dataset, future growth should focus on increasing:
- Sessions
- Prompts
- Tasks completed
- Productivity
- Retention
- Paid conversion

---

## 💰 2. Optimize the Freemium Funnel

Use Freemium as an acquisition layer and improve conversion through:
- Usage limits
- Premium functionality
- Upgrade prompts
- Personalized offers
- Feature-based conversion triggers

---

## 🎯 3. Build Profession-Specific Experiences

Create specialized experiences for:
- Students
- Developers
- Analysts
- Researchers
- Marketers
- Teachers
- Customer support teams

---

## 💳 4. Encourage Premium Upgrades

Identify users with high:
- Usage
- Task completion
- Token consumption
- Session frequency

and provide relevant upgrade opportunities.

---

## ⭐ 5. Protect High-Value Users

High-value customers should receive stronger:
- Retention strategies
- Premium support
- Loyalty programs
- Account management
- Expansion opportunities

---
# ⚠️ Data & Analytical Caveats

### Synthetic Dataset
The dataset is synthetic and was generated specifically for this project.
Therefore, the findings represent patterns **within this dataset** and should not be interpreted as real-world AI market statistics.

### Universal Adoption
The 100% adoption result applies only to the registered users represented in this dataset.

### Metric Definitions
Some analysis results depend on the exact metric used.
For example, a query measuring usage records should not be interpreted as measuring unique users.

### Revenue Scope
Certain revenue calculations are based on specific subscription/payment filters. They should therefore be interpreted according to their analytical definition rather than automatically treated as lifetime revenue.

---

# 🛠️ Technologies Used

|Technology|Purpose|
|---|---|
|🐘 PostgreSQL|Relational database and SQL analytics|
|🖥️ pgAdmin|PostgreSQL database management and query execution|
|🐍 Python|Synthetic dataset generation|
|🐼 Pandas|DataFrame creation and CSV generation|
|🔢 NumPy|Numerical operations and probabilistic generation|
|🔌 psycopg2-binary|PostgreSQL connectivity from Python|
|🤖 ChatGPT|AI-assisted development and analytical support|

---

# 📁 Project Structure

```
AI-Tools-Usage-Analytics/
│
├── README.md
│
├── documentation/
│   ├── PROJECT_DOCUMENTATION.pdf
|   └── raw_detailed_description.md
│
├── python/
│   ├── generate_datasets.py
│   ├── generate_datasets_description.md
│   ├── export_query_results.py
|   └── export_query_results_description.md
|
├── sql/
│   └── project_analysis.sql
│
├── data/
│   ├── ai_tools.csv
│   ├── users.csv
│   ├── usage_log.csv
│   ├── subscriptions.csv
│   └── payments.csv
│
└── ...
```

> File names may vary slightly depending on the final repository structure.

---

# ⚙️ How to Run

## 1️⃣ Clone the Repository

```
git clone https://github.com/waleed4we/AI-Tools-Usage-Analytics.git
cd AI-Tools-Usage-Analytics
```

## 2️⃣ Install Python Dependencies

Make sure Python is installed, then install the required libraries:

```
pip install pandas numpy psycopg2-binary
```

## 3️⃣ Generate the Dataset

Run the Python data-generation script:

```
python python/main.py
```

This generates the required CSV datasets.

---

## 4️⃣ Set Up PostgreSQL

Create a PostgreSQL database using PostgreSQL / pgAdmin.

Then create the required tables according to the project's database schema.

---

## 5️⃣ Load the CSV Data

Import the generated CSV files into PostgreSQL.
The data should be loaded according to table dependencies so that referenced records exist before dependent transactional records are inserted.

Recommended logical order:

```
ai_tools
   ↓
users
   ↓
subscriptions
   ↓
usage_log
   ↓
payments
```

---

## 6️⃣ Run the SQL Analysis

Open the SQL project file inside pgAdmin or another PostgreSQL-compatible SQL environment.

The SQL file contains the project's analytical workflow and business questions.

---

# 🔬 Analytical Workflow

The complete project follows this pipeline:

```
                  ┌─────────────────────┐
                  │  Python Generation  │
                  └──────────┬──────────┘
                             │
                             ▼
                  ┌─────────────────────┐
                  │     CSV Dataset     │
                  └──────────┬──────────┘
                             │
                             ▼
                  ┌─────────────────────┐
                  │      PostgreSQL     │
                  └──────────┬──────────┘
                             │
                             ▼
                  ┌─────────────────────┐
                  │  Data Validation    │
                  └──────────┬──────────┘
                             │
                             ▼
                  ┌─────────────────────┐
                  │    SQL Analysis     │
                  └──────────┬──────────┘
                             │
                             ▼
                  ┌─────────────────────┐
                  │ Business Questions  │
                  └──────────┬──────────┘
                             │
                             ▼
                  ┌─────────────────────┐
                  │  Insights & Findings│
                  └──────────┬──────────┘
                             │
                             ▼
                  ┌─────────────────────┐
                  │    Recommendations  │
                  └─────────────────────┘
```

---

# 📌 Project Highlights

### Dataset

- **10,000 users**
- **30 AI tools**
- **477,087 usage records**
- **4,736 subscriptions**
- **31,214 payments**

### Analysis

- Demographic analysis
- AI tool analysis
- Category analysis
- Pricing analysis
- Usage behavior
- Productivity analysis
- Experience-level analysis
- Profession-level analysis
- Subscription analysis
- Revenue analysis
- User segmentation
- Cross-category analysis

### SQL Concepts

- Aggregations
- Joins
- CTEs
- Subqueries
- CASE statements
- Window functions
- Ranking
- Conditional analysis
- Percentage calculations
- Revenue analysis


---
# 📚 Documentation

Detailed project documentation is available in:

```
project_documentation.pdf and raw_detailed_description.md
```

---
# 👨‍💻 Author

## Malik Waleed Hussain

**Data Analytics / Computer Science Student**

---

# ⭐ Project Summary

**AI Tools Usage & Productivity Analytics** demonstrates how raw relational data can be transformed into meaningful business intelligence.

The project follows the complete journey:
**Python Data Generation → PostgreSQL Database → Data Validation → SQL Analysis → Business Questions → Insights → Strategic Recommendations**
