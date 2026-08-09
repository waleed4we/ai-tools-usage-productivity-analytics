

```python
import os
import random
from datetime import datetime, timedelta
import numpy as np
import pandas as pd

SEED = 42
NUM_USERS = 10_000
START_DATE = datetime(2025, 1, 1)
END_DATE = datetime(2026, 6, 30)
OUTPUT_DIR = "data"

random.seed(SEED)
np.random.seed(SEED)
os.makedirs(OUTPUT_DIR, exist_ok=True)

COUNTRIES = [
    "USA", "India", "Pakistan", "United Kingdom", "Canada",
    "Germany", "France", "Australia", "UAE", "Saudi Arabia",
    "Japan", "Singapore", "Brazil", "Netherlands",
    "Spain", "Italy", "Malaysia", "South Korea"
]

COUNTRY_WEIGHTS = [
    0.18, 0.15, 0.10, 0.08, 0.07,
    0.06, 0.05, 0.05, 0.04, 0.04,
    0.03, 0.03, 0.03, 0.02, 0.02,
    0.02, 0.01, 0.02
]

PROFESSIONS = [
    "Software Developer", "Data Analyst", "Data Scientist", "Student",
    "Designer", "Marketing Specialist", "Content Creator", "Researcher",
    "Teacher", "Business Analyst", "Entrepreneur", "Customer Support Specialist"
]

PROFESSION_WEIGHTS = [
    0.14, 0.10, 0.07, 0.16, 0.07, 0.08,
    0.07, 0.05, 0.07, 0.07, 0.05, 0.07
]

EXPERIENCE_LEVELS = ["Beginner", "Intermediate", "Advanced", "Expert"]
EXPERIENCE_WEIGHTS = [0.30, 0.35, 0.25, 0.10]

CATEGORIES = [
    "Coding", "Writing", "Research", "Image Generation", "Video Generation",
    "Data Analysis", "Productivity", "Education", "Marketing", "Customer Support"
]

PROFESSION_CATEGORY_WEIGHTS = {
    "Software Developer": {
        "Coding": 0.60, "Data Analysis": 0.15, "Productivity": 0.10,
        "Research": 0.05, "Writing": 0.05, "Education": 0.05
    },
    "Data Analyst": {
        "Data Analysis": 0.45, "Coding": 0.20, "Research": 0.15,
        "Productivity": 0.10, "Writing": 0.05, "Education": 0.05
    },
    "Data Scientist": {
        "Data Analysis": 0.40, "Coding": 0.25, "Research": 0.20,
        "Productivity": 0.05, "Writing": 0.05, "Education": 0.05
    },
    "Student": {
        "Education": 0.30, "Writing": 0.20, "Research": 0.20,
        "Productivity": 0.15, "Coding": 0.10, "Image Generation": 0.05
    },
    "Designer": {
        "Image Generation": 0.50, "Video Generation": 0.20,
        "Writing": 0.10, "Marketing": 0.10, "Productivity": 0.10
    },
    "Marketing Specialist": {
        "Marketing": 0.40, "Writing": 0.25, "Image Generation": 0.15,
        "Research": 0.10, "Video Generation": 0.10
    },
    "Content Creator": {
        "Writing": 0.30, "Image Generation": 0.25, "Video Generation": 0.25,
        "Marketing": 0.10, "Research": 0.10
    },
    "Researcher": {
        "Research": 0.50, "Writing": 0.15, "Data Analysis": 0.15,
        "Education": 0.10, "Productivity": 0.10
    },
    "Teacher": {
        "Education": 0.45, "Writing": 0.20, "Research": 0.15,
        "Productivity": 0.10, "Image Generation": 0.10
    },
    "Business Analyst": {
        "Data Analysis": 0.30, "Research": 0.20, "Productivity": 0.20,
        "Writing": 0.15, "Marketing": 0.10, "Coding": 0.05
    },
    "Entrepreneur": {
        "Productivity": 0.25, "Marketing": 0.25, "Research": 0.20,
        "Writing": 0.15, "Data Analysis": 0.10, "Image Generation": 0.05
    },
    "Customer Support Specialist": {
        "Customer Support": 0.55, "Writing": 0.20,
        "Productivity": 0.15, "Research": 0.10
    }
}

ACTIVITY_PROFILES = {
    "Casual": {
        "events": (5, 20), "sessions": (1, 2), "prompts": (1, 8),
        "minutes": (5, 25), "tokens_per_prompt": (150, 400), "tasks": (0, 2)
    },
    "Regular": {
        "events": (25, 55), "sessions": (1, 4), "prompts": (5, 20),
        "minutes": (15, 60), "tokens_per_prompt": (300, 700), "tasks": (1, 5)
    },
    "Power": {
        "events": (60, 110), "sessions": (2, 7), "prompts": (15, 50),
        "minutes": (40, 150), "tokens_per_prompt": (500, 1200), "tasks": (3, 12)
    },
    "Heavy": {
        "events": (120, 200), "sessions": (4, 12), "prompts": (40, 120),
        "minutes": (90, 300), "tokens_per_prompt": (800, 2000), "tasks": (8, 25)
    }
}

CATEGORY_USAGE_MULTIPLIER = {
    "Coding": 1.20, "Writing": 1.10, "Research": 1.15,
    "Image Generation": 0.70, "Video Generation": 0.50,
    "Data Analysis": 1.20, "Productivity": 0.90, "Education": 0.80,
    "Marketing": 1.00, "Customer Support": 1.10
}

TOOLS_DATA = [
    ("ChatGPT", "Coding", "Freemium"),
    ("Claude", "Coding", "Freemium"),
    ("GitHub Copilot", "Coding", "Subscription"),
    ("Google Antigravity", "Coding", "Free"),
    ("ChatGPT", "Writing", "Freemium"),
    ("Claude", "Writing", "Freemium"),
    ("Grammarly", "Writing", "Freemium"),
    ("Jasper", "Writing", "Subscription"),
    ("Perplexity", "Research", "Freemium"),
    ("NotebookLM", "Research", "Free"),
    ("Claude", "Research", "Freemium"),
    ("Midjourney", "Image Generation", "Subscription"),
    ("ChatGPT Images", "Image Generation", "Freemium"),
    ("Adobe Firefly", "Image Generation", "Freemium"),
    ("Leonardo AI", "Image Generation", "Freemium"),
    ("Sora", "Video Generation", "Subscription"),
    ("Runway", "Video Generation", "Freemium"),
    ("ChatGPT", "Data Analysis", "Freemium"),
    ("Claude", "Data Analysis", "Freemium"),
    ("Julius AI", "Data Analysis", "Freemium"),
    ("Notion AI", "Productivity", "Subscription"),
    ("Microsoft Copilot", "Productivity", "Freemium"),
    ("Google Gemini", "Productivity", "Freemium"),
    ("NotebookLM", "Education", "Free"),
    ("Khanmigo", "Education", "Subscription"),
    ("Jasper", "Marketing", "Subscription"),
    ("Copy.ai", "Marketing", "Freemium"),
    ("Canva Magic Studio", "Marketing", "Freemium"),
    ("Intercom Fin", "Customer Support", "Subscription"),
    ("Zendesk AI", "Customer Support", "Subscription")
]

PLAN_PRICES = {
    "Basic": 9.99,
    "Pro": 24.99,
    "Team": 59.99,
    "Enterprise": 149.99
}

def random_date(start_date, end_date):
    days = (end_date - start_date).days
    return start_date + timedelta(days=random.randint(0, days))

def choose_activity_segment(experience):
    if experience == "Beginner":
        weights = [0.50, 0.35, 0.12, 0.03]
    elif experience == "Intermediate":
        weights = [0.35, 0.42, 0.18, 0.05]
    elif experience == "Advanced":
        weights = [0.25, 0.35, 0.30, 0.10]
    else:
        weights = [0.18, 0.30, 0.35, 0.17]
    return random.choices(list(ACTIVITY_PROFILES.keys()), weights=weights, k=1)[0]

def generate_users():
    print("Generating users...")
    users = []
    max_join_days = int((END_DATE - START_DATE).days * 0.80)

    for user_id in range(1, NUM_USERS + 1):
        country = np.random.choice(COUNTRIES, p=COUNTRY_WEIGHTS)
        profession = np.random.choice(PROFESSIONS, p=PROFESSION_WEIGHTS)
        experience = np.random.choice(EXPERIENCE_LEVELS, p=EXPERIENCE_WEIGHTS)
        created_at = START_DATE + timedelta(days=random.randint(0, max_join_days))
        activity_segment = choose_activity_segment(experience)

        users.append({
            "user_id": user_id,
            "country": country,
            "profession": profession,
            "experience_level": experience,
            "created_at": created_at,
            "_segment": activity_segment
        })

    return pd.DataFrame(users)

def generate_tools():
    print("Generating AI tools...")
    tools = []
    for tool_id, item in enumerate(TOOLS_DATA, start=1):
        tools.append({
            "tool_id": tool_id,
            "tool_name": item[0],
            "category": item[1],
            "pricing_model": item[2]
        })
    return pd.DataFrame(tools)

def generate_usage(users_df, tools_df):
    print("Generating usage logs...")
    usage = []
    usage_id = 1

    tools_by_category = tools_df.groupby("category")["tool_id"].apply(list).to_dict()

    for _, user in users_df.iterrows():
        user_id = user["user_id"]
        profession = user["profession"]
        segment = user["_segment"]
        joined_date = user["created_at"]

        preferred_categories = PROFESSION_CATEGORY_WEIGHTS[profession]
        categories = list(preferred_categories.keys())
        category_weights = list(preferred_categories.values())

        profile = ACTIVITY_PROFILES[segment]
        event_count = random.randint(profile["events"][0], profile["events"][1])
        max_days = (END_DATE - joined_date).days

        if max_days <= 0:
            continue

        for _ in range(event_count):
            selected_category = random.choices(categories, weights=category_weights, k=1)[0]
            available_tools = tools_by_category[selected_category]
            tool_id = random.choice(available_tools)
            usage_date = joined_date + timedelta(days=random.randint(0, max_days))
            multiplier = CATEGORY_USAGE_MULTIPLIER[selected_category]

            sessions = random.randint(profile["sessions"][0], profile["sessions"][1])
            prompts = max(1, int(random.randint(profile["prompts"][0], profile["prompts"][1]) * multiplier))
            minutes = max(1, int(random.randint(profile["minutes"][0], profile["minutes"][1]) * multiplier))

            tokens_per_prompt = random.randint(profile["tokens_per_prompt"][0], profile["tokens_per_prompt"][1])
            tokens = prompts * tokens_per_prompt
            tasks_completed = random.randint(profile["tasks"][0], profile["tasks"][1])

            usage.append({
                "usage_id": usage_id,
                "user_id": user_id,
                "tool_id": tool_id,
                "usage_date": usage_date.date(),
                "sessions": sessions,
                "prompts": prompts,
                "minutes_used": minutes,
                "tokens_used": tokens,
                "tasks_completed": tasks_completed
            })
            usage_id += 1

    return pd.DataFrame(usage)

def generate_subscriptions(users_df, usage_df, tools_df):
    print("Generating subscriptions...")
    subscriptions = []
    subscription_id = 1
    user_tools = usage_df.groupby("user_id")["tool_id"].apply(list).to_dict()

    for _, user in users_df.iterrows():
        user_id = user["user_id"]
        segment = user["_segment"]
        joined_date = user["created_at"]

        prob_map = {"Casual": 0.10, "Regular": 0.35, "Power": 0.70, "Heavy": 0.90}
        probability = prob_map.get(segment, 0.10)

        if random.random() >= probability:
            continue

        number_of_subscriptions = random.choice([1, 2]) if segment in ["Power", "Heavy"] else 1
        available_tools = user_tools.get(user_id, [])

        if not available_tools:
            continue

        selected_tools = random.sample(available_tools, min(number_of_subscriptions, len(available_tools)))

        for tool_id in selected_tools:
            plan = random.choices(
                ["Basic", "Pro", "Team", "Enterprise"],
                weights=[0.45, 0.35, 0.15, 0.05],
                k=1
            )[0]

            price = PLAN_PRICES[plan]
            max_start_offset = min(300, max(0, (END_DATE - joined_date).days))
            start_date = joined_date + timedelta(days=random.randint(0, max_start_offset))

            cancelled = random.random() < 0.15
            if cancelled:
                active_days = random.randint(30, 180)
                end_date = start_date + timedelta(days=active_days)
                if end_date > END_DATE:
                    end_date = None
                    status = "Active"
                else:
                    status = "Cancelled"
            else:
                end_date = None
                status = "Active"

            subscriptions.append({
                "subscription_id": subscription_id,
                "user_id": user_id,
                "tool_id": int(tool_id),
                "plan": plan,
                "monthly_price": price,
                "start_date": start_date.date(),
                "end_date": end_date.date() if end_date else None,
                "status": status
            })
            subscription_id += 1

    return pd.DataFrame(subscriptions, columns=[
        "subscription_id", "user_id", "tool_id", "plan",
        "monthly_price", "start_date", "end_date", "status"
    ])

def generate_payments(subscriptions_df):
    print("Generating payments...")
    payments = []
    payment_id = 1

    for _, subscription in subscriptions_df.iterrows():
        current_date = subscription["start_date"]
        payment_end = END_DATE.date() if pd.isna(subscription["end_date"]) else subscription["end_date"]

        while current_date <= payment_end:
            payment_status = random.choices(
                ["Success", "Failed", "Refunded"],
                weights=[0.92, 0.06, 0.02],
                k=1
            )[0]

            amount = subscription["monthly_price"] if payment_status == "Success" else 0.00

            payments.append({
                "payment_id": payment_id,
                "subscription_id": subscription["subscription_id"],
                "payment_date": current_date,
                "amount": amount,
                "payment_status": payment_status
            })
            payment_id += 1
            current_date += timedelta(days=30)

    return pd.DataFrame(payments, columns=[
        "payment_id", "subscription_id", "payment_date", "amount", "payment_status"
    ])

def introduce_data_quality_issues(users_df):
    print("Adding small amount of realistic missing data...")
    users_df = users_df.copy()
    country_mask = np.random.random(len(users_df)) < 0.01
    users_df.loc[country_mask, "country"] = None
    return users_df

def save_csv(df, filename):
    path = os.path.join(OUTPUT_DIR, filename)
    df.to_csv(path, index=False)
    print(f"✓ {filename:<20} {len(df):>10,} rows")

def main():
    print("\n" + "=" * 60)
    print("AI TOOL USAGE & PRODUCTIVITY ANALYTICS")
    print("Synthetic Data Generator")
    print("=" * 60 + "\n")

    tools_df = generate_tools()
    users_df = generate_users()

    usage_df = generate_usage(users_df, tools_df)
    subscriptions_df = generate_subscriptions(users_df, usage_df, tools_df)
    payments_df = generate_payments(subscriptions_df)

    users_df = introduce_data_quality_issues(users_df)
    users_df = users_df.drop(columns=["_segment"])

    print("\nSaving CSV files...\n")
    save_csv(users_df, "users.csv")
    save_csv(tools_df, "ai_tools.csv")
    save_csv(usage_df, "usage.csv")
    save_csv(subscriptions_df, "subscriptions.csv")
    save_csv(payments_df, "payments.csv")

    print("\n" + "=" * 60)
    print("DATA GENERATION COMPLETE")
    print("=" * 60 + "\n")

    print(f"Files generated inside:\n  {OUTPUT_DIR}/\n")
    print("Dataset summary:")
    print(f"  Users          : {len(users_df):,}")
    print(f"  AI Tools       : {len(tools_df):,}")
    print(f"  Usage Records  : {len(usage_df):,}")
    print(f"  Subscriptions  : {len(subscriptions_df):,}")
    print(f"  Payments       : {len(payments_df):,}\n")

if __name__ == "__main__":
    main()
```


dwsd