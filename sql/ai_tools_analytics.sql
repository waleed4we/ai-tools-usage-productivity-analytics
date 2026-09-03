DROP TABLE IF EXISTS payments CASCADE;
DROP TABLE IF EXISTS subscriptions CASCADE;
DROP TABLE IF EXISTS usage_log CASCADE;
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS ai_tools CASCADE;

CREATE TABLE ai_tools (
    tool_id INTEGER PRIMARY KEY,
    tool_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    pricing_model VARCHAR(30) NOT NULL,
    CONSTRAINT chk_ai_tools_category
        CHECK (
            category IN (
                'Coding', 'Writing',
                'Research', 'Image Generation',
                'Video Generation', 'Data Analysis',
                'Productivity', 'Education',
                'Marketing', 'Customer Support'
            )
        ),
    CONSTRAINT chk_ai_tools_pricing_model
        CHECK (
            pricing_model IN (
                'Free',
                'Freemium',
                'Subscription',
                'Usage-Based'
            )
        )
);

CREATE TABLE users (
    user_id INTEGER PRIMARY KEY,
    country VARCHAR(50),
    profession VARCHAR(100) NOT NULL,
    experience_level VARCHAR(20),
    created_at TIMESTAMP NOT NULL,
    CONSTRAINT chk_users_experience_level
        CHECK (
            experience_level IS NULL
            OR experience_level IN (
                'Beginner',
                'Intermediate',
                'Advanced',
                'Expert'
            )
        )
);

CREATE TABLE usage_log (
    usage_id BIGINT PRIMARY KEY,
    user_id INTEGER NOT NULL,
    tool_id INTEGER NOT NULL,
    usage_date DATE NOT NULL,
    sessions INTEGER NOT NULL,
    prompts INTEGER NOT NULL,
    minutes_used INTEGER NOT NULL,
    tokens_used BIGINT NOT NULL,
    tasks_completed INTEGER NOT NULL,
    CONSTRAINT fk_usage_user
        FOREIGN KEY (user_id)
        REFERENCES users(user_id)
        ON DELETE RESTRICT,
    CONSTRAINT fk_usage_tool
        FOREIGN KEY (tool_id)
        REFERENCES ai_tools(tool_id)
        ON DELETE RESTRICT,
    CONSTRAINT chk_usage_sessions
        CHECK (sessions >= 0),
    CONSTRAINT chk_usage_prompts
        CHECK (prompts >= 0),
    CONSTRAINT chk_usage_minutes
        CHECK (minutes_used >= 0),
    CONSTRAINT chk_usage_tokens
        CHECK (tokens_used >= 0),
    CONSTRAINT chk_usage_tasks
        CHECK (tasks_completed >= 0)
);

CREATE TABLE subscriptions (
    subscription_id BIGINT PRIMARY KEY,
    user_id INTEGER NOT NULL,
    tool_id INTEGER NOT NULL,
    plan VARCHAR(20) NOT NULL,
    monthly_price NUMERIC(10,2) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    status VARCHAR(20) NOT NULL,
    CONSTRAINT fk_subscription_user
        FOREIGN KEY (user_id)
        REFERENCES users(user_id)
        ON DELETE RESTRICT,
    CONSTRAINT fk_subscription_tool
        FOREIGN KEY (tool_id)
        REFERENCES ai_tools(tool_id)
        ON DELETE RESTRICT,
    CONSTRAINT chk_subscription_plan
        CHECK (
            plan IN (
                'Basic',
                'Pro',
                'Team',
                'Enterprise'
            )
        ),
    CONSTRAINT chk_subscription_price
        CHECK (monthly_price >= 0),
    CONSTRAINT chk_subscription_status
        CHECK (
            status IN (
                'Active',
                'Cancelled'
            )
        ),
    CONSTRAINT chk_subscription_dates
        CHECK (
            end_date IS NULL
            OR end_date >= start_date
        ),
    CONSTRAINT chk_subscription_status_dates
        CHECK (
            (status = 'Active' AND end_date IS NULL)
            OR
            (status = 'Cancelled' AND end_date IS NOT NULL)
        )
);

DROP TABLE IF EXISTS payments CASCADE;

CREATE TABLE payments (
    payment_id BIGINT PRIMARY KEY,
    subscription_id BIGINT NOT NULL,
    payment_date DATE NOT NULL,
    amount NUMERIC(10,2) NOT NULL,
    payment_status VARCHAR(20) NOT NULL,
    CONSTRAINT fk_payments_subscription
        FOREIGN KEY (subscription_id)
        REFERENCES subscriptions(subscription_id)
        ON DELETE RESTRICT,
    CONSTRAINT chk_payments_amount
        CHECK (amount >= 0),
    CONSTRAINT chk_payments_status
        CHECK (
            payment_status IN (
                'Success',
                'Failed',
                'Refunded'
            )
        )
);




CREATE INDEX idx_usage_user_id
    ON usage_log(user_id);

CREATE INDEX idx_usage_tool_id
    ON usage_log(tool_id);

CREATE INDEX idx_usage_date
    ON usage_log(usage_date);

CREATE INDEX idx_subscription_user_id
    ON subscriptions(user_id);

CREATE INDEX idx_subscription_tool_id
    ON subscriptions(tool_id);

CREATE INDEX idx_subscription_dates
    ON subscriptions(start_date, end_date);

CREATE INDEX idx_payments_subscription_id
    ON payments(subscription_id);

CREATE INDEX idx_payments_date
    ON payments(payment_date);

ALTER TABLE users
ALTER COLUMN created_at TYPE DATE
USING created_at::DATE;

-- ai_tools , users , subscriptions , usage_log , payments , import order

-- Start Of Project

select * from ai_tools limit 5;
select * from users limit 5;
select * from subscriptions limit 5;
select * from usage_log limit 5;
select * from payments limit 5;



SELECT
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns
WHERE table_name = 'users'
ORDER BY ordinal_position;

SELECT COUNT(*) AS total_rows
FROM users;


SELECT *
FROM users
WHERE country IS NULL;

-- Questions Start Here

-- 1. Counting Rows In Every Table
select 'Ai Tools' as table_name , count(*) as total_records from ai_tools
union all
select 'Users'  as table_name , count(*) as total_records from users
union all
select 'Subscriptions' as table_name ,count(*) as total_records from subscriptions
union all
select 'Usage Log' as table_name ,count(*) as total_records from usage_log
union all
select 'Payments' as table_name ,count(*) as total_records from payments;


-- 2 Find Total users , Total countries , Total professions , Total experience levels
select count(user_id) as no_of_users, 
count(distinct(country)) as total_countries, 
count(distinct(profession)) as total_professions,
count(distinct(experience_level)) as total_ExperienceLevels
from users;

-- 3 Find: Total AI tools , Total AI categories , Total pricing models
select count(tool_id) as total_tools, 
count(distinct category) as total_categories,
count(distinct(pricing_model)) as pricing_models
from ai_tools;

-- 4 Find Number of users according to experience level
select experience_level , count(*) as number_of_users 
from users
group by experience_level
order by number_of_users desc;

-- 5 Find Number of users according to profession
select profession , count(*) as number_of_users 
from users
group by profession
order by number_of_users desc;

-- 6 Find Number of users according to country
select country , count(*) as number_of_users 
from users
group by country
order by number_of_users desc;

-- 7 Find Number of users according to country
select pricing_model , count(*) as number_of_tools
from ai_tools
group by pricing_model
order by number_of_tools desc;

-- 8 Find the number of AI tools available in each AI category. 
--Display the categories from the highest number of tools to the lowest.

select category , count(*) as number_of_tools
from ai_tools
group by category
order by number_of_tools desc ;


-- 9 Find all AI tools whose pricing model is Free.
select * from ai_tools where pricing_model = 'Free';

-- 10 Find the number of AI tools in each pricing model and calculate what percentage of all AI tools each pricing model represents. 
--Sort the results from the highest percentage to the lowest.

select pricing_model , count(*) as number_of_tools , round(( count(*) / sum(count(*)) over() ) * 100.0,2) as percentage
from ai_tools
group by pricing_model
order by percentage desc ;

-- 11 Find the total number of users and the percentage of total users for each country.
-- Display the countries from the highest number of users to the lowest.

select country , count(*) as users_count , round((count(*) / sum(count(1)) over() )*100,2) as users_percentage
from users
group by country
order by users_percentage desc;

-- 12 Find the number and percentage of users in each experience level. 
-- Sort the results from the experience level with the highest number of users to the lowest

select experience_level , count(*) , round((count(*) / sum(count(*)) over()) *100 ,2)
from users
group by experience_level
order by 3 desc;

-- 13 For each profession, find the total number of users and determine which experience level is most common within that profession. 
--Sort professions by total users from highest to lowest.


with table_cte as (
select profession , experience_level , count(*) as number_of_users ,
dense_rank() over(partition by profession order by count(*) desc) as ranking
from users
group by profession , experience_level )
select * from table_cte
where table_cte.ranking = 1
order by number_of_users desc;


WITH experience_counts AS (
    SELECT
        profession,
        experience_level,
        COUNT(*) AS number_of_users
    FROM users
    GROUP BY profession, experience_level
)
SELECT *
FROM experience_counts ec
WHERE number_of_users = (
    SELECT MAX(ec2.number_of_users)
    FROM experience_counts ec2
    WHERE ec2.profession = ec.profession
)
ORDER BY number_of_users DESC;

-- 14 Find the total number of unique users who have used each AI tool,
-- along with the total number of usage records for each tool. Display the tools with the highest number of unique users first.

select ait.tool_name , count(distinct usage_log.user_id) as unique_users ,count(usage_log.usage_id) as usage_records
from ai_tools as ait join usage_log
on ait.tool_id = usage_log.tool_id 
group by ait.tool_name
order by unique_users desc;

-- 15 Find how many unique users from each profession have used AI tools.
-- Display the professions with the highest number of AI users first.
select us.profession , count(distinct ul.user_id) as unique_users
from users as us join usage_log as ul
on us.user_id = ul.user_id
group by us.profession
order by unique_users desc;

-- 16 Write an SQL query to find the total number of users for each profession from the users table. 
-- The output should display the profession and total_users, sorted in descending order based on the user count
select profession  , count(*) as users_count
from users
group by profession
order by users_count desc; 

-- 17 Retrieve the tool_name, category, and pricing_model from the ai_tools table
-- for all tools where the pricing_model is 'Freemium' and the category is either 'Coding' or 'Research'.

select tool_name , category , pricing_model
from ai_tools
where pricing_model = 'Freemium' and category in ('Coding','Research');

select tool_name , category , pricing_model
from ai_tools
where pricing_model = 'Freemium' and (category = 'Coding' or category = 'Research') ;

-- 18 Write an SQL query to calculate how many new users registered each year using the created_at timestamp from the users table. 
--The result should display the Year and Total Signups, sorted in ascending order by year.
SELECT EXTRACT(YEAR FROM created_at) AS signup_year,
COUNT(*) AS total_signups
FROM users
GROUP BY EXTRACT(YEAR FROM created_at)
ORDER BY signup_year ASC;


-- 19 Find the number of unique AI users in each experience level  
-- And calculate what percentage of users within each experience level have used at least one AI tool.

SELECT u.experience_level, COUNT(DISTINCT u.user_id) AS total_users,
COUNT(DISTINCT ul.user_id) AS unique_ai_users,
ROUND(  COUNT(DISTINCT ul.user_id) * 100.0 / COUNT(DISTINCT u.user_id),2 ) AS ai_adoption_percentage
FROM users AS u
LEFT JOIN usage_log AS ul
    ON u.user_id = ul.user_id
GROUP BY u.experience_level
ORDER BY ai_adoption_percentage DESC;

-- 20 Write an SQL query to retrieve the top 5 countries with the highest number of users, replacing any NULL or missing country values with the string 'Unknown'. 
--Display the country name as country_name and total users as total_users
select coalesce(country,'Unknown') as country_name , count(*) as total_users 
from users
group by coalesce(country,'Unknown')
order by total_users desc
limit 5;


-- 21 Write an SQL query to calculate the total usage metrics (total_sessions, total_prompts, and total_tokens) for each tool category by joining usage and ai_tools tables.
-- Sort the output by total_tokens in descending order.

select ai_tools.category , sum(usage_log.sessions) as total_sessions, sum(usage_log.prompts) as total_prompts , sum(usage_log.tokens_used) as tokens_used
from ai_tools join usage_log on ai_tools.tool_id = usage_log.tool_id
group by ai_tools.category 
order by tokens_used desc;

-- 22 Write an SQL query to list all active subscriptions (status = 'Active') created in the year 2025. 
--Display subscription_id, user_id, plan, monthly_price, and start_date, sorted by start_date ascending.
select subscription_id, user_id, plan, monthly_price, start_date
from subscriptions
where extract(Year from start_date) = 2025 and status = 'Active'
order by start_date;

-- 23 Write an SQL query to calculate the total revenue generated from successful payments (payment_status = 'Success') for each AI tool category. 
--Display category and total_revenue, formatted or sorted in descending order of revenue
select ai_tools.category , sum(payments.amount) as total_revenue
from ai_tools join subscriptions
on ai_tools.tool_id = subscriptions.tool_id
join payments on subscriptions.subscription_id = payments.subscription_id
where payments.payment_status = 'Success'
group by ai_tools.category
order by total_revenue desc;

-- 24 Write an SQL query to find all users (user_id and profession) who have completed a total of more than 500 tasks across all their usage logs.
-- Display user_id, profession, and total_tasks_completed, sorted by total_tasks_completed descending.
select users.user_id , users.profession , sum(usage_log.tasks_completed) as total_tasks_completed
from users join usage_log
on users.user_id = usage_log.user_id
group by users.user_id , users.profession
having sum(usage_log.tasks_completed) > 500
order by total_tasks_completed desc;

with user_activity_cte as (
select users.user_id , users.profession , sum(usage_log.tasks_completed) as total_tasks_completed
from users join usage_log
on users.user_id = usage_log.user_id
group by users.user_id , users.profession ) 
select * from user_activity_cte
where user_activity_cte.total_tasks_completed > 500
order by total_tasks_completed desc;

-- 25 Write an SQL query to list all users (user_id and country) who are currently using a 'Freemium'
--  pricing model tool in their subscriptions (status = 'Active').  Display unique users using DISTINCT.

select distinct users.user_id , users.country
from users join subscriptions
on users.user_id = subscriptions.user_id 
join ai_tools on ai_tools.tool_id = subscriptions.tool_id
where ai_tools.pricing_model = 'Freemium' and subscriptions.status = 'Active';

-- 26 Write an SQL query to find all users (user_id, profession) whose total token consumption (tokens_used) 
-- across all their usage logs is higher than the average token consumption of all users.

WITH user_tokens AS (
    SELECT 
        users.user_id, 
        users.profession, 
        SUM(usage_log.tokens_used) AS total_tokens_used
    FROM users 
    JOIN usage_log ON users.user_id = usage_log.user_id
    GROUP BY users.user_id, users.profession
)
SELECT *
FROM user_tokens
WHERE total_tokens_used > (SELECT AVG(total_tokens_used) FROM user_tokens)
order by total_tokens_used desc;

-- 27 Using a Window Function (DENSE_RANK() or ROW_NUMBER()), 
-- write an SQL query to find the most used AI tool (tool_name) for each profession based on total prompts submitted (prompts).
with ranking_cte as (
select usage_log.tool_id, ai_tools.tool_name, users.profession ,sum(usage_log.prompts) as prompts_used ,
dense_rank() over(partition by users.profession order by sum(usage_log.prompts) desc) as ranking
from usage_log join ai_tools
on ai_tools.tool_id = usage_log.tool_id join users
on users.user_id = usage_log.user_id
group by usage_log.tool_id,ai_tools.tool_name,users.profession
	)
	select tool_id , tool_name , profession , prompts_used from ranking_cte
	where ranking = 1 
	order by prompts_used desc;

-- 28 Write an SQL query using CASE WHEN to categorize payments into three groups:
-- 'High Value' if amount > $50
-- 'Medium Value' if amount is between $20 and $50
-- 'Low Value' if amount < $20
-- Display the payment_category, total count of transactions, and total revenue generated for each category.

select 
	case when amount > 50 then 'High Value'
	when amount between 20 and 50 then 'Medium Value'
	when amount < 20 then 'Low Value'
	end as payment_category , count(*) as number_of_transactions ,sum(amount) as total_revenue
from payments
group by payment_category;

-- 29 Write an SQL query to find all registered users (user_id, profession, country) 
-- who have never used any AI tool (i.e., they have no records in the usage_log table).
select users.user_id , users.country, users.profession
from users left join usage_log
on users.user_id = usage_log.user_id
WHERE usage_log.user_id IS NULL;


-- 30 Write an SQL query to identify users (user_id) who have an 'Expired' subscription (status = 'Expired'), 
-- but had a total prompt consumption of more than 100 prompts in their usage logs
SELECT users.user_id, users.country, users.profession, subscriptions.status, SUM(usage_log.prompts) AS total_prompts
FROM users JOIN subscriptions
ON users.user_id = subscriptions.user_id JOIN usage_log
ON usage_log.user_id = users.user_id
WHERE subscriptions.status = 'Expired'
GROUP BY users.user_id, users.country, users.profession, subscriptions.status
HAVING SUM(usage_log.prompts) > 100;

-- 31 Find how many unique users from each profession have used AI tools. 
--Display the professions with the highest number of AI users first.
select users.profession , count(distinct usage_log.user_id)
from users join usage_log
on users.user_id = usage_log.user_id
group by users.profession
order by 2 desc;

-- 32 For each AI tool category, find the total number of unique users who have used at least one tool from that category,
-- along with the total number of usage records. Sort the categories by unique users from highest to lowest.

SELECT 
    ai_tools.category, 
    COUNT(DISTINCT usage_log.user_id) AS unique_users,
    COUNT(usage_log.usage_id) AS total_usage_records
FROM ai_tools 
JOIN usage_log ON ai_tools.tool_id = usage_log.tool_id
GROUP BY ai_tools.category
ORDER BY unique_users DESC;

-- 33 Write an SQL query to find users (user_id, profession) who have utilized
-- AI tools across more than 2 or equal to 2 different categories (e.g., Coding, Research, Design).

with explain_cte as (
	select users.user_id , users.profession, count(distinct ai_tools.category) as cat_count
	from users join usage_log
	on users.user_id = usage_log.user_id
	join ai_tools on ai_tools.tool_id = usage_log.tool_id
	group by users.user_id , users.profession
)
select * from explain_cte 
where cat_count >= 2 ;

select users.user_id , users.profession, count(distinct ai_tools.category) as cat_count
	from users join usage_log
	on users.user_id = usage_log.user_id
	join ai_tools on ai_tools.tool_id = usage_log.tool_id
	group by users.user_id , users.profession
	having count(distinct ai_tools.category) >= 2;

-- 34 Write an SQL query using CTEs to find users who signed up in 2025 (created_at) AND have generated more than 50 total sessions in usage_log. 
-- Display their user_id, profession, country, and total sessions.


select users.user_id, users.profession , users.country , sum(usage_log.sessions) as total_sessions
from users join usage_log
on users.user_id = usage_log.user_id
where extract(year from users.created_at) = 2025 
group by users.user_id, users.profession , users.country
having  sum(usage_log.sessions) > 50 ;

with conditional_cte as (
select users.user_id, users.profession , users.country , sum(usage_log.sessions) as total_sessions
from users join usage_log
on users.user_id = usage_log.user_id
where extract(year from users.created_at) = 2025
group by users.user_id, users.profession , users.country 
) select * from conditional_cte 
where total_sessions > 50 ;

-- 35 Write an SQL query to generate a complete summary for each AI tool (tool_name, category):
-- Total unique users who used it (unique_users)
-- Total tasks completed (total_tasks)
-- Total revenue generated from active subscriptions linked to that tool (total_revenue)
-- (Hint: Use LEFT JOIN and COUNT(DISTINCT) to avoid duplication).

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
    JOIN payments p ON s.subscription_id = p.subscription_id
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
left JOIN tool_usage u ON t.tool_id = u.tool_id
left JOIN tool_revenue r ON t.tool_id = r.tool_id;

-- 36 Write an SQL query to calculate the Monthly Recurring Revenue (MRR) generated from all active subscriptions (status = 'Active'), 
-- grouped by plan name (plan). Include the total number of active subscribers and the total monthly revenue for each plan.

select subscriptions.plan, count(*) as number_of_subscribers,  sum(monthly_price) as monthly_revenue
from subscriptions
where subscriptions.status = 'Active'
group by subscriptions.plan 
order by number_of_subscribers ;

-- 37 Which Ai Is Most Popular
SELECT 
    ai_tools.tool_name ,
    COUNT(DISTINCT usage_log.user_id) AS total_unique_users
FROM ai_tools 
JOIN usage_log ON ai_tools.tool_id = usage_log.tool_id
GROUP BY ai_tools.tool_id, ai_tools.tool_name
ORDER BY total_unique_users DESC
LIMIT 1;


-- 38 Which Ai Is Least Used
with ranking_cte as (
	SELECT 
    ai_tools.tool_name, 
    COUNT(DISTINCT usage_log.user_id) AS total_unique_users ,
	row_number() over(order by COUNT(DISTINCT usage_log.user_id)) as ranking_in_Least_Used
FROM ai_tools 
JOIN usage_log ON ai_tools.tool_id = usage_log.tool_id
GROUP BY ai_tools.tool_id, ai_tools.tool_name
)
select * from ranking_cte where ranking_in_Least_Used = 1 ;

-- 39 Which Profession Uses Ai The Most
select users.profession , count(distinct usage_log.user_id)
from users join usage_log
on users.user_id = usage_log.user_id
group by users.profession
order by count(distinct usage_log.user_id) desc
limit 1;

-- 40 Which Profession Uses Ai The Least
select users.profession , count(usage_log.user_id) as number_of_users
from users join usage_log
on users.user_id = usage_log.user_id
group by users.profession
order by number_of_users
limit 1;

-- 41 Which Pricing Model Is Commenly Used
select ai_tools.pricing_model , count(distinct usage_log.user_id) as number_of_users
from ai_tools join usage_log
on ai_tools.tool_id = usage_log.tool_id
group by pricing_model
order by 2 desc
limit 1;

-- 42 Which Pricing Model Is Least Used
select ai_tools.pricing_model , count(distinct usage_log.user_id) as number_of_users
from ai_tools join usage_log
on ai_tools.tool_id = usage_log.tool_id
group by pricing_model
order by number_of_users
limit 1;

-- 43 Rank Ai_Tool Categories Users According To Their Users
select ai_tools.category , count(distinct usage_log.user_id) as number_of_users ,
dense_rank() over(order by count(distinct usage_log.user_id) desc) as ranking
from ai_tools join usage_log
on ai_tools.tool_id = usage_log.tool_id
group by ai_tools.category
order by ranking;

-- 44 How many active subscriptions are there
select count(*) as Active_Subscriptions
from subscriptions 
where subscriptions.status = 'Active';


-- 45 How many expired subscriptions are there
select count(*) as Active_Subscriptions
from subscriptions 
where end_date is not null or subscriptions.status = 'Cancelled';

-- 47 Which Profession Buys Which Plan The Most

with profession_and_plan_cte as(
	select users.profession , subscriptions.plan , count(subscriptions.subscription_id) as total_purchases,
	dense_rank() over(partition by users.profession order by count(subscriptions.subscription_id) desc) as ranking
from users join subscriptions
on users.user_id = subscriptions.user_id 
group by users.profession , subscriptions.plan
) select * from profession_and_plan_cte
where ranking = 1 ;
































































































