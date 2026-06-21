# Wedding planner (local web app)

Local-first wedding planning dashboard (Tasks, Vendors, Budget) you can run on your PC and open from your phone on the same Wi‑Fi.

## Prereqs

- Node.js (npm)
- Postgres (local install)
  - You already have `psql`, so you likely have Postgres available

## 1) Create the app env file

From `apps/wedding-planner/`:

1. Copy `.env.example` → `.env`
2. Set `DATABASE_URL` to your local Postgres credentials.

Example format:

```text
DATABASE_URL="postgresql://USERNAME:PASSWORD@localhost:5432/agentic_os?schema=wedding"
```

Notes:
- The `?schema=wedding` part keeps the tables isolated in a dedicated `wedding` schema.
- Do **not** commit `.env` (it is ignored).

## 2) Prepare the database

This repo includes a Postgres setup helper under `agentic-db/`.

### Option A: Use your existing local Postgres (no Docker)

From `agentic-db/`:

1. Copy `.env.example` → `.env` and set a strong `POSTGRES_PASSWORD`
2. Run:

```powershell
.\scripts\setup-local.ps1
```

This will create/update the role + database and apply `agentic-db/db/init.sql`.

### Option B: Docker (if you install Docker Desktop later)

From `agentic-db/`:

```powershell
docker compose up -d
```

## 3) Apply the wedding planner migration

From `apps/wedding-planner/`:

```powershell
npm install
npm run db:generate
npm run db:migrate
```

If `db:migrate` fails with authentication errors, double-check your `DATABASE_URL` in `apps/wedding-planner/.env`.

## 4) Run the app (LAN / phone access)

From `apps/wedding-planner/`:

```powershell
npm run dev
```

Then open on your PC:
- `http://localhost:3000`

To open from your phone (same Wi‑Fi):
1. Find your PC’s LAN IP address (example command):

```powershell
ipconfig
```

2. On your phone browser, open:
- `http://<PC_LAN_IP>:3000`

### Windows Firewall note

If your phone can’t connect, allow inbound access for Node/Next on port `3000` (Private network). Common fixes:
- Allow Node.js through Windows Defender Firewall
- Or create an inbound rule for TCP `3000`

## Production mode (optional)

If you want to run without the dev server:

```powershell
npm run build
npm run start
```

`npm run start` is also bound to `0.0.0.0:3000` so it’s reachable on your LAN.

## What’s included (MVP)

- **Tasks**: create/edit/delete tasks, set status + optional due date
- **Vendors**: shortlist vendors, status + optional quote + notes
- **Budget**: items with category/name + optional target/actual
- **Guests**: guest list with RSVP + party size

This is a [Next.js](https://nextjs.org) project bootstrapped with [`create-next-app`](https://nextjs.org/docs/app/api-reference/cli/create-next-app).

## Getting Started

First, run the development server:

```bash
npm run dev
# or
yarn dev
# or
pnpm dev
# or
bun dev
```

Open [http://localhost:3000](http://localhost:3000) with your browser to see the result.

You can start editing the page by modifying `app/page.tsx`. The page auto-updates as you edit the file.

This project uses [`next/font`](https://nextjs.org/docs/app/building-your-application/optimizing/fonts) to automatically optimize and load [Geist](https://vercel.com/font), a new font family for Vercel.

## Learn More

To learn more about Next.js, take a look at the following resources:

- [Next.js Documentation](https://nextjs.org/docs) - learn about Next.js features and API.
- [Learn Next.js](https://nextjs.org/learn) - an interactive Next.js tutorial.

You can check out [the Next.js GitHub repository](https://github.com/vercel/next.js) - your feedback and contributions are welcome!

## Deploy on Vercel

The easiest way to deploy your Next.js app is to use the [Vercel Platform](https://vercel.com/new?utm_medium=default-template&filter=next.js&utm_source=create-next-app&utm_campaign=create-next-app-readme) from the creators of Next.js.

Check out our [Next.js deployment documentation](https://nextjs.org/docs/app/building-your-application/deploying) for more details.
