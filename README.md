# 🚀 Flutter Mobile & Web SaaS Template (Supabase + Stripe)

A production-ready, full-stack cross-platform SaaS starter kit built with **Flutter (Dart 3)**, **Supabase Auth & Database**, **Stripe Recurring Subscriptions**, and **Riverpod State Management**. Designed for indie hackers, startups, and agencies looking to ship high-converting SaaS MVPs in days, not months.

[![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.2+-0175C2.svg?style=for-the-badge&logo=Dart&logoColor=white)](https://dart.dev)
[![Supabase](https://img.shields.io/badge/Supabase-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white)](https://supabase.com)
[![Stripe](https://img.shields.io/badge/Stripe-635BFF?style=for-the-badge&logo=stripe&logoColor=white)](https://stripe.com)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)

---

## 🌟 Key Highlights

- 🔐 **Multi-Provider Authentication:**
  - Email & Password with automatic verification links.
  - Supabase Magic Link authentication (passwordless).
  - Social OAuth (Google, GitHub, Apple) via Supabase Auth with secure session refresh.
- 💳 **End-to-End Stripe Subscription Flow:**
  - Serverless Deno Edge functions (`get_stripe_url`, `stripe_webhook`) for Stripe Checkout sessions.
  - Automated webhook verification for monthly & annual plans.
  - Dynamic user entitlement checks based on PostgreSQL subscription tables.
- ⚡ **Realtime Database & Security:**
  - Reactive Supabase PostgreSQL database tables with Row-Level Security (RLS) policies.
  - S3-compatible Supabase Storage bucket for user avatars and assets.
- 📱 **Modern SaaS Dashboard & Pricing Matrix:**
  - Sleek Material 3 dynamic Dark & Light UI.
  - Interactive KPI metric cards (MRR, Active Users, API Quotas, Health SLA).
  - Monthly vs. Annual toggle with tier comparisons (Starter, Pro, Enterprise).
- 🧱 **Scalable Architecture:**
  - Strict feature-first Clean Architecture.
  - State management powered by `flutter_riverpod` with code-generation and Dart 3 records.
  - Declarative deep-link navigation powered by `go_router`.

---

## 🏛️ Architecture & Project Structure

The project strictly separates presentation, domain logic, and external services:

```text
flutter-supabase-saas-template/
├── lib/
│   ├── components/            # Reusable UI dialogs and form widgets
│   │   ├── dialog_page.dart
│   │   ├── email_form.dart
│   │   ├── recover_password_dialog.dart
│   │   └── reset_password_dialog.dart
│   ├── models/                # Immutable domain & entity models
│   │   ├── stripe.dart        # Stripe products, prices, and subscriptions
│   │   └── user_metadata.dart # User profile & account metadata
│   ├── screens/               # Screen presentation layer
│   │   ├── auth_screen.dart   # Social & Email auth gate
│   │   ├── home_screen.dart   # SaaS Dashboard, analytics & pricing plans
│   │   └── payments_screen.dart# Stripe checkout redirect handler
│   ├── services/              # Riverpod controllers & state notifiers
│   │   ├── auth_notifier.dart # Supabase Auth state controller
│   │   ├── metadata_notifier.dart # User subscription & profile stream
│   │   └── router_notifier.dart # Deep linking & route redirect guards
│   └── main.dart              # Application bootstrap & Supabase initialization
│
├── supabase/                  # Backend infrastructure & serverless
│   ├── functions/             # Supabase Edge Functions (Deno / TypeScript)
│   │   ├── get_stripe_url/    # Generates Stripe customer checkout URL
│   │   ├── stripe_webhook/    # Handles subscription lifecycle webhooks
│   │   └── on_user_modify/    # Syncs auth users to public profile table
│   └── migrations/            # Production PostgreSQL SQL migrations & RLS policies
│       └── 20240717231009_init.sql
│
├── android/                   # Native Android configuration
├── ios/                       # Native iOS configuration
├── web/                       # Web build shell
└── pubspec.yaml               # Dependencies and assets
```

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (`>= 3.2.3`)
- [Supabase CLI](https://supabase.com/docs/guides/cli) (optional, for local backend development)
- A free [Supabase](https://supabase.com) account
- A free [Stripe](https://stripe.com) test account

### 1. Clone the repository

```bash
git clone https://github.com/Dharmikkothiya/flutter-supabase-saas-template.git
cd flutter-supabase-saas-template
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Environment Configuration

Create or update `env.json` with your credentials:

```json
{
  "SUPABASE_URL": "https://YOUR_SUPABASE_PROJECT_ID.supabase.co",
  "SUPABASE_ANON_KEY": "YOUR_SUPABASE_ANON_KEY",
  "POSTHOG_KEY": "YOUR_POSTHOG_KEY"
}
```

### 4. Run the Application

To run on your connected device, Android emulator, or Web:

```bash
# Run on Chrome
flutter run -d chrome --dart-define-from-file=env.json

# Run on Mobile device/emulator
flutter run --dart-define-from-file=env.json
```

---

## 🗄️ Supabase Database & Stripe Setup

1. **Deploy Migrations:**  
   Copy the SQL contents of [`supabase/migrations/20240717231009_init.sql`](supabase/migrations/20240717231009_init.sql) into your Supabase Dashboard SQL Editor and execute it. This creates:
   - `users` table linked to `auth.users`
   - `customers` table for Stripe customer IDs
   - `products` and `prices` tables
   - `subscriptions` table tracking active SaaS tiers
   - Row Level Security (RLS) policies

2. **Deploy Edge Functions:**
   ```bash
   supabase functions deploy get_stripe_url
   supabase functions deploy stripe_webhook
   ```

3. **Stripe Webhook:**  
   Configure a Stripe webhook endpoint pointing to your deployed `stripe_webhook` edge function URL for the events:
   - `customer.subscription.created`
   - `customer.subscription.updated`
   - `customer.subscription.deleted`

---

## 🛠️ Tech Stack & Dependencies

| Layer | Technology |
| :--- | :--- |
| **Framework** | [Flutter 3.x](https://flutter.dev) (Dart 3+) |
| **State Management** | [flutter_riverpod](https://pub.dev/packages/flutter_riverpod) + `riverpod_annotation` |
| **Routing** | [go_router](https://pub.dev/packages/go_router) with Auth redirect guards |
| **Backend & DB** | [Supabase](https://supabase.com) (PostgreSQL, Auth, RLS, Storage) |
| **Payments** | [Stripe](https://stripe.com) Checkout + Deno Serverless Edge Functions |
| **Analytics** | [PostHog Flutter](https://pub.dev/packages/posthog_flutter) |
| **Auth UI** | [supabase_auth_ui](https://pub.dev/packages/supabase_auth_ui) |

---

## 📄 License

Distributed under the **MIT License**. See [`LICENSE`](LICENSE) for more information.
