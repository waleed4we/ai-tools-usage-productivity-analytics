
```python
import pandas as pd
import psycopg2
from pathlib import Path

# Database settings
DB_CONFIG = {
    "host": "localhost",
    "port": 5432,
    "dbname": "your_database_name",
    "user": "postgres",
    "password": "your_password",
}

OUTPUT_FILE = "query_results.csv"

# Analytical queries
QUERIES = [
    (
        "1.1",
        "Row counts across every table",
        """
        SELECT 'Ai Tools' AS table_name, COUNT(*) AS total_records
        FROM ai_tools
        UNION ALL
        SELECT 'Users', COUNT(*)
        FROM users
        UNION ALL
        SELECT 'Subscriptions', COUNT(*)
        FROM subscriptions
        UNION ALL
        SELECT 'Usage Log', COUNT(*)
        FROM usage_log
        UNION ALL
        SELECT 'Payments', COUNT(*)
        FROM payments;
        """
    ),
    (
        "1.2",
        "Users overview: total users, countries, professions, experience levels",
        """
        SELECT
            COUNT(user_id) AS no_of_users,
            COUNT(DISTINCT country) AS total_countries,
            COUNT(DISTINCT profession) AS total_professions,
            COUNT(DISTINCT experience_level) AS total_experience_levels
        FROM users;
        """
    ),
    (
        "1.3",
        "AI tools overview: total tools, categories, pricing models",
        """
        SELECT
            COUNT(tool_id) AS total_tools,
            COUNT(DISTINCT category) AS total_categories,
            COUNT(DISTINCT pricing_model) AS pricing_models
        FROM ai_tools;
        """
    ),
    (
        "2.1",
        "Users by experience level",
        """
        SELECT
            experience_level,
            COUNT(*) AS number_of_users
        FROM users
        GROUP BY experience_level
        ORDER BY number_of_users DESC;
        """
    ),
    (
        "2.2",
        "Users by profession",
        """
        SELECT
            profession,
            COUNT(*) AS number_of_users
        FROM users
        GROUP BY profession
        ORDER BY number_of_users DESC;
        """
    ),
    (
        "2.3",
        "Users by country",
        """
        SELECT
            country,
            COUNT(*) AS number_of_users
        FROM users
        GROUP BY country
        ORDER BY number_of_users DESC;
        """
    ),
    (
        "2.4",
        "Number of AI tools per category, highest to lowest",
        """
        SELECT
            category,
            COUNT(*) AS number_of_tools
        FROM ai_tools
        GROUP BY category
        ORDER BY number_of_tools DESC;
        """
    ),
    (
        "2.5",
        "Pricing model distribution with percentage of total tools",
        """
        SELECT
            pricing_model,
            COUNT(*) AS number_of_tools,
            ROUND(
                (COUNT(*)::NUMERIC / SUM(COUNT(*)) OVER()) * 100,
                2
            ) AS percentage
        FROM ai_tools
        GROUP BY pricing_model
        ORDER BY percentage DESC;
        """
    ),
    (
        "2.6",
        "User distribution by country with percentage of total users",
        """
        SELECT
            country,
            COUNT(*) AS users_count,
            ROUND(
                (COUNT(*)::NUMERIC / SUM(COUNT(*)) OVER()) * 100,
                2
            ) AS users_percentage
        FROM users
        GROUP BY country
        ORDER BY users_percentage DESC;
        """
    ),
    (
        "2.7",
        "User distribution by experience level with percentage of total users",
        """
        SELECT
            experience_level,
            COUNT(*) AS number_of_users,
            ROUND(
                (COUNT(*)::NUMERIC / SUM(COUNT(*)) OVER()) * 100,
                2
            ) AS percentage
        FROM users
        GROUP BY experience_level
        ORDER BY percentage DESC;
        """
    ),
    (
        "2.8",
        "Signups per year",
        """
        SELECT
            EXTRACT(YEAR FROM created_at) AS signup_year,
            COUNT(*) AS total_signups
        FROM users
        GROUP BY EXTRACT(YEAR FROM created_at)
        ORDER BY signup_year ASC;
        """
    ),
    (
        "2.9",
        "Top 5 countries by user count, NULLs relabeled as 'Unknown'",
        """
        SELECT
            COALESCE(country, 'Unknown') AS country_name,
            COUNT(*) AS total_users
        FROM users
        GROUP BY COALESCE(country, 'Unknown')
        ORDER BY total_users DESC
        LIMIT 5;
        """
    ),
    (
        "3.1",
        "All free-tier AI tools",
        """
        SELECT *
        FROM ai_tools
        WHERE pricing_model = 'Free';
        """
    ),
    (
        "3.2",
        "Freemium tools in the Coding or Research categories",
        """
        SELECT
            tool_name,
            category,
            pricing_model
        FROM ai_tools
        WHERE pricing_model = 'Freemium'
          AND category IN ('Coding', 'Research');
        """
    ),
    (
        "4.1",
        "Unique users and total usage records per tool",
        """
        SELECT
            ait.tool_name,
            COUNT(DISTINCT ul.user_id) AS unique_users,
            COUNT(ul.usage_id) AS usage_records
        FROM ai_tools ait
        JOIN usage_log ul
            ON ait.tool_id = ul.tool_id
        GROUP BY ait.tool_name
        ORDER BY unique_users DESC;
        """
    ),
    (
        "4.2",
        "Total usage metrics (sessions, prompts, tokens) per tool category",
        """
        SELECT
            ai_tools.category,
            SUM(usage_log.sessions) AS total_sessions,
            SUM(usage_log.prompts) AS total_prompts,
            SUM(usage_log.tokens_used) AS total_tokens
        FROM ai_tools
        JOIN usage_log
            ON ai_tools.tool_id = usage_log.tool_id
        GROUP BY ai_tools.category
        ORDER BY total_tokens DESC;
        """
    ),
    (
        "4.3",
        "Registered users who have never used any AI tool",
        """
        SELECT
            users.user_id,
            users.country,
            users.profession
        FROM users
        LEFT JOIN usage_log
            ON users.user_id = usage_log.user_id
        WHERE usage_log.user_id IS NULL;
        """
    ),
    (
        "4.4",
        "Unique users and usage records per category (with category ranking)",
        """
        SELECT
            ai_tools.category,
            COUNT(DISTINCT usage_log.user_id) AS unique_users,
            COUNT(usage_log.usage_id) AS total_usage_records,
            DENSE_RANK() OVER (
                ORDER BY COUNT(DISTINCT usage_log.user_id) DESC
            ) AS ranking
        FROM ai_tools
        JOIN usage_log
            ON ai_tools.tool_id = usage_log.tool_id
        GROUP BY ai_tools.category
        ORDER BY ranking;
        """
    ),
    (
        "5.1",
        "Most common experience level within each profession (ties included)",
        """
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
        SELECT
            profession,
            experience_level,
            number_of_users
        FROM experience_counts
        WHERE ranking = 1
        ORDER BY number_of_users DESC;
        """
    ),
    (
        "5.2",
        "AI adoption rate per experience level",
        """
        SELECT
            u.experience_level,
            COUNT(DISTINCT u.user_id) AS total_users,
            COUNT(DISTINCT ul.user_id) AS unique_ai_users,
            ROUND(
                COUNT(DISTINCT ul.user_id) * 100.0 /
                COUNT(DISTINCT u.user_id),
                2
            ) AS ai_adoption_percentage
        FROM users u
        LEFT JOIN usage_log ul
            ON u.user_id = ul.user_id
        GROUP BY u.experience_level
        ORDER BY ai_adoption_percentage DESC;
        """
    ),
    (
        "5.3",
        "Users whose total token consumption exceeds the average across all users",
        """
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
        WHERE total_tokens_used > (
            SELECT AVG(total_tokens_used)
            FROM user_tokens
        )
        ORDER BY total_tokens_used DESC;
        """
    ),
    (
        "5.4",
        "Most-used AI tool per profession, ranked by total prompts submitted",
        """
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
            GROUP BY
                usage_log.tool_id,
                ai_tools.tool_name,
                users.profession
        )
        SELECT
            tool_id,
            tool_name,
            profession,
            prompts_used
        FROM ranking_cte
        WHERE ranking = 1
        ORDER BY prompts_used DESC;
        """
    ),
    (
        "5.5",
        "Full per-tool summary: unique users, total tasks, total revenue from active subs",
        """
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
        """
    ),
    (
        "5.6",
        "Which plan each profession purchases the most",
        """
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
        SELECT
            profession,
            plan,
            total_purchases
        FROM profession_and_plan_cte
        WHERE ranking = 1;
        """
    ),
    (
        "6.1",
        "Active subscriptions created in 2025",
        """
        SELECT
            subscription_id,
            user_id,
            plan,
            monthly_price,
            start_date
        FROM subscriptions
        WHERE EXTRACT(YEAR FROM start_date) = 2025
          AND status = 'Active'
        ORDER BY start_date;
        """
    ),
    (
        "6.2",
        "Total revenue from successful payments per AI tool category",
        """
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
        """
    ),
    (
        "6.3",
        "Users who completed more than 500 tasks in total",
        """
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
        """
    ),
    (
        "6.4",
        "Users currently on an Active Freemium-tool subscription",
        """
        SELECT DISTINCT
            users.user_id,
            users.country
        FROM users
        JOIN subscriptions
            ON users.user_id = subscriptions.user_id
        JOIN ai_tools
            ON ai_tools.tool_id = subscriptions.tool_id
        WHERE ai_tools.pricing_model = 'Freemium'
          AND subscriptions.status = 'Active';
        """
    ),
    (
        "6.5",
        "Payments categorized by value tier (High / Medium / Low)",
        """
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
        """
    ),
    (
        "6.6",
        "Users signed up in 2025 with more than 50 total sessions",
        """
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
            GROUP BY
                users.user_id,
                users.profession,
                users.country
        )
        SELECT *
        FROM conditional_cte
        WHERE total_sessions > 50;
        """
    ),
    (
        "6.7",
        "Monthly Recurring Revenue (MRR) by plan, from active subscriptions",
        """
        SELECT
            subscriptions.plan,
            COUNT(*) AS number_of_subscribers,
            SUM(monthly_price) AS monthly_revenue
        FROM subscriptions
        WHERE subscriptions.status = 'Active'
        GROUP BY subscriptions.plan
        ORDER BY monthly_revenue DESC;
        """
    ),
    (
        "6.8",
        "Count of active subscriptions",
        """
        SELECT COUNT(*) AS active_subscriptions
        FROM subscriptions
        WHERE status = 'Active';
        """
    ),
    (
        "6.9",
        "Count of cancelled subscriptions",
        """
        SELECT COUNT(*) AS cancelled_subscriptions
        FROM subscriptions
        WHERE status = 'Cancelled';
        """
    ),
    (
        "6.10",
        "Users with more than 2 tool categories used",
        """
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
        """
    ),
    (
        "7.1",
        "Most popular AI tool (by unique users)",
        """
        SELECT
            ai_tools.tool_name,
            COUNT(DISTINCT usage_log.user_id) AS total_unique_users
        FROM ai_tools
        JOIN usage_log
            ON ai_tools.tool_id = usage_log.tool_id
        GROUP BY ai_tools.tool_id, ai_tools.tool_name
        ORDER BY total_unique_users DESC
        LIMIT 1;
        """
    ),
    (
        "7.2",
        "Least used AI tool (by unique users)",
        """
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
        SELECT
            tool_name,
            total_unique_users
        FROM ranking_cte
        WHERE ranking_in_least_used = 1;
        """
    ),
    (
        "7.3",
        "Profession that uses AI the most",
        """
        SELECT
            users.profession,
            COUNT(DISTINCT usage_log.user_id) AS unique_users
        FROM users
        JOIN usage_log
            ON users.user_id = usage_log.user_id
        GROUP BY users.profession
        ORDER BY unique_users DESC
        LIMIT 1;
        """
    ),
    (
        "7.4",
        "Profession that uses AI the least",
        """
        SELECT
            users.profession,
            COUNT(usage_log.user_id) AS number_of_users
        FROM users
        JOIN usage_log
            ON users.user_id = usage_log.user_id
        GROUP BY users.profession
        ORDER BY number_of_users
        LIMIT 1;
        """
    ),
    (
        "7.5",
        "Most commonly used pricing model",
        """
        SELECT
            ai_tools.pricing_model,
            COUNT(DISTINCT usage_log.user_id) AS number_of_users
        FROM ai_tools
        JOIN usage_log
            ON ai_tools.tool_id = usage_log.tool_id
        GROUP BY pricing_model
        ORDER BY number_of_users DESC
        LIMIT 1;
        """
    ),
    (
        "7.6",
        "Least used pricing model",
        """
        SELECT
            ai_tools.pricing_model,
            COUNT(DISTINCT usage_log.user_id) AS number_of_users
        FROM ai_tools
        JOIN usage_log
            ON ai_tools.tool_id = usage_log.tool_id
        GROUP BY pricing_model
        ORDER BY number_of_users
        LIMIT 1;
        """
    ),
]


def main():
    all_results = []

    print(f"Found {len(QUERIES)} queries.")

    if len(QUERIES) != 40:
        raise RuntimeError(
            f"Expected 40 analytical queries, but found {len(QUERIES)}."
        )

    conn = psycopg2.connect(**DB_CONFIG)

    try:
        for query_no, query_name, sql in QUERIES:
            print(f"Running Query {query_no}: {query_name}")

            try:
                df = pd.read_sql_query(sql, conn)

                if df.empty:
                    df = pd.DataFrame([{"result": "No rows returned"}])

                df.insert(0, "row_no", range(1, len(df) + 1))
                df.insert(0, "query_name", query_name)
                df.insert(0, "query_no", query_no)

                all_results.append(df)

            except Exception as e:
                print(f"ERROR in Query {query_no}: {e}")

                error_df = pd.DataFrame([{
                    "query_no": query_no,
                    "query_name": query_name,
                    "row_no": 1,
                    "ERROR": str(e),
                }])

                all_results.append(error_df)

    finally:
        conn.close()

    final_df = pd.concat(
        all_results,
        ignore_index=True,
        sort=False
    )

    final_df.to_csv(
        OUTPUT_FILE,
        index=False,
        encoding="utf-8-sig"
    )

    print("\n========================================")
    print("DONE!")
    print(f"CSV created: {Path(OUTPUT_FILE).resolve()}")
    print(f"Total result rows: {len(final_df)}")
    print("========================================")


if __name__ == "__main__":
    main()
```


# Python SQL Query Export Script

This Python script connects to the **PostgreSQL AI Tools Usage & Productivity Analytics database**, executes all predefined analytical SQL queries, and exports their results into a **single CSV file**.

## Purpose

The script automates the process of running multiple SQL analysis queries and collecting their results in one place. This makes it easier to review, analyze, and share the project's analytical output.

## Technologies Used

 **Python**
 **Pandas** – Executes queries and combines results
 **Psycopg2** – Connects Python to PostgreSQL
 **Pathlib** – Handles the output file path

## How It Works

1. Connects to the PostgreSQL database using the configured credentials.
2. Stores all analytical SQL queries in the `QUERIES` list.
3. Executes each query automatically.
4. Adds `query_no`, `query_name`, and `row_no` to every result.
5. Handles failed queries without stopping the remaining queries.    
6. Combines all query results into a single Pandas DataFrame.
7. Exports the final results to : `query_results.csv`
## Output Structure

The generated CSV contains:

`query_no` – Query identifier
`query_name` – Description of the analysis
`row_no` – Row number within that query's result

**Result columns** – Columns returned by the individual SQL query

Since different queries return different columns, unavailable fields are automatically left blank.

## Key Benefit

This script provides a simple **Python → PostgreSQL → SQL Analysis → CSV Export** pipeline, allowing all analytical query results to be generated automatically instead of manually executing and exporting each query.