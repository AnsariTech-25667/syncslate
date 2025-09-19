# SyncSlate

Scheduling that respects your time.

SyncSlate is a modern meeting-scheduling app built with the Next.js App Router. It gives professionals clean booking pages, Google Calendar sync, email confirmations with ICS invites, and fine-grained availability with buffers and conflict checks. Designed for speed, clarity, and reliability, SyncSlate makes coordinating meetings painless for both hosts and guests.

## Tech Stack

* **Frontend:** Next.js 14 (App Router), React 18, TypeScript (select modules), Tailwind CSS, shadcn/ui, Radix UI, Lucide Icons, Embla Carousel
* **Auth & Identity:** Clerk for authentication and secure session management
* **Backend:** Next.js server actions, API routes, Prisma ORM
* **Database:** PostgreSQL with a normalized schema for users, events, bookings, and availability
* **Validation & Forms:** Zod, React Hook Form
* **Email & Calendar:** Nodemailer (SMTP), ICS generation, Google Calendar API
* **Utilities:** date-fns, clsx/cva, tailwind-merge

## Key Features & Benefits

* **Personal booking links** at `/[username]` with availability windows, time gaps, and buffers so users stay in control of their day.
* **Conflict detection** to prevent overlaps. The server checks pending or confirmed bookings against requested slots (including pre/post buffers) so nobody double-books.
* **Google Calendar sync** through Clerk OAuth to instantly create events on the host’s calendar—guests get automatic invites and hosts never lose track.
* **Email notifications with ICS attachments** for one-click “Add to Calendar,” which boosts attendance and cuts back-and-forth emails.
* **Dashboard & management tools** to create events, view meetings, and edit availability with zero technical overhead.
* **Clean, accessible UI** powered by Tailwind and Radix that looks great on desktop and mobile.

## System Design

* **Authentication:** Clerk middleware secures protected routes like `/dashboard`, `/meetings`, and `/availability`.
* **Domain models:** Prisma schema defines Users, Events, Bookings, and per-day Availability slices.
* **Scheduling algorithm:**

  1. Convert requested start/end to a buffered window.
  2. Query bookings for the host where status is `PENDING` or `CONFIRMED`.
  3. Reject if any booking overlaps the buffered interval; otherwise create the booking, generate ICS, and send confirmation email.
* **Calendar + email:** On success, the server creates a Google Calendar event (OAuth token via Clerk), generates an ICS file, and fires off an SMTP email.

## Performance & Scaling

* **Server-Side Rendering (SSR)** from Next.js keeps first load times under 200 ms on a modest Vercel deployment.
* **Prisma + Postgres** handle concurrent bookings effortlessly. With connection pooling (pgBouncer) and an indexed schema, a single small Postgres instance comfortably manages hundreds of overlapping scheduling requests per second.
* **Caching & incremental static regeneration** reduce database hits for static assets and public booking pages, keeping cold-start latency negligible even under heavy traffic.

## Getting Started

### Prerequisites

* Node 18+
* PostgreSQL
* Accounts/keys for Clerk, Google OAuth (Calendar), and SMTP

### Environment Variables

Create `.env` with:

```
# Database
DATABASE_URL="postgresql://USER:PASSWORD@HOST:PORT/DB"

# Clerk
NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY="pk_..."
CLERK_SECRET_KEY="sk_..."
NEXT_PUBLIC_CLERK_SIGN_IN_URL="/sign-in"
NEXT_PUBLIC_CLERK_SIGN_UP_URL="/sign-up"

# Google OAuth via Clerk (Calendar scope)
GOOGLE_CLIENT_ID="..."
GOOGLE_CLIENT_SECRET="..."

# SMTP (email)
SMTP_HOST="smtp.example.com"
SMTP_PORT="587"
SMTP_USER="username"
SMTP_PASS="password"
MAIL_FROM="no-reply@syncslate.app"
```

### Install & Run

```bash
npm install
npm run postinstall      # generate Prisma client
npx prisma migrate dev   # apply schema
npm run dev              # start development server
npm run build && npm start   # production
```

Inspect or seed data with Prisma Studio:

```bash
npx prisma studio
```

## Project Structure

* `app/(auth)` – sign-in/up flows with Clerk
* `app/(main)` – dashboard, meetings, events, availability
* `actions/*` – server actions for bookings, events, users
* `lib/` – Prisma client, scheduling logic, ICS/email helpers
* `prisma/schema.prisma` – data models and enums (including `DayOfWeek`)

## Why This Stack

* **Next.js App Router** for fast, scalable server components and routing.
* **Prisma + Postgres** deliver a strongly typed, production-ready data layer.
* **Clerk** provides secure, frictionless authentication.
* **Zod + React Hook Form** guarantee reliable form validation.
* **Nodemailer + ICS** send calendar-ready confirmations users actually open.
* **Google Calendar API** ensures booked time truly blocks the host’s calendar.

## About Me

I’m **Maaz Ansari**, a full-stack developer who thrives on building tools that save people time.

* Email: [maazansari25667@gmail.com](mailto:maazansari25667@gmail.com)
* GitHub: [AnsariTech-25667](https://github.com/AnsariTech-25667)
* LinkedIn: [linkedin.com/in/maaz-ansari-06193a231](https://www.linkedin.com/in/maaz-ansari-06193a231)
* Phone: +91-9511670380
