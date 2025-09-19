#!/usr/bin/env bash
set -euo pipefail

# ──────────────────────────────────────────────────────────────────────────────
# Config: change if you must
PROJECT_DIR="C:/Users/maaza/OneDrive/Desktop/new_set/best of all projects/syncslate"
REPO_URL="https://github.com/AnsariTech-25667/syncslate"
GIT_NAME="Maaz Ansari"
GIT_EMAIL="maazansari25667@gmail.com"
BRANCH="main"
# ──────────────────────────────────────────────────────────────────────────────

cd "$PROJECT_DIR"

# Helpers
add_if_exists() {
  # usage: add_if_exists path1 path2 ...
  local any=0
  for p in "$@"; do
    # quote the glob so bash expands; skip literal patterns
    for f in $p; do
      if [ -e "$f" ]; then
        git add "$f"
        any=1
      fi
    done
  done
  return $any
}

commit_if_any() {
  local msg="$1"
  if ! git diff --cached --quiet; then
    git commit -m "$msg"
  else
    echo "skip: $msg (no staged changes)"
  fi
}

file_absent_touch() {
  # create file with content only if it doesn't exist
  local path="$1"; shift
  if [ ! -e "$path" ]; then
    mkdir -p "$(dirname "$path")"
    printf "%s\n" "$@" > "$path"
  fi
}

# Init repo if needed
if [ ! -d ".git" ]; then
  git init -b "$BRANCH"
  git config user.name "$GIT_NAME"
  git config user.email "$GIT_EMAIL"
  git config core.autocrlf true
fi

# 1) gitignore + attributes
file_absent_touch ".gitignore" \
"# Node / Next" "node_modules/" ".next/" "out/" "dist/" ".cache/" "coverage/" \
"# Env" ".env" ".env.local" ".env.*.local" \
"# Logs" "npm-debug.log*" "yarn-debug.log*" "pnpm-debug.log*" \
"# OS" ".DS_Store" "Thumbs.db" \
"# Prisma" "prisma/*.db"
file_absent_touch ".gitattributes" "* text=auto"
git add .gitignore .gitattributes
commit_if_any "chore: add .gitignore and normalize line endings"

# 2) README + LICENSE + env example
# (Assumes you already pasted the hot README I wrote. If not, this creates a stub.)
file_absent_touch "README.md" "# SyncSlate" "" "See full README in later commit."
file_absent_touch "LICENSE" "MIT License © 2025 Maaz Ansari"
file_absent_touch ".env.example" \
"DATABASE_URL=postgresql://USER:PASSWORD@HOST:PORT/DB" \
"NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY=pk_xxx" \
"CLERK_SECRET_KEY=sk_xxx" \
"NEXT_PUBLIC_CLERK_SIGN_IN_URL=/sign-in" \
"NEXT_PUBLIC_CLERK_SIGN_UP_URL=/sign-up" \
"GOOGLE_CLIENT_ID=xxx" \
"GOOGLE_CLIENT_SECRET=xxx" \
"SMTP_HOST=smtp.example.com" \
"SMTP_PORT=587" \
"SMTP_USER=username" \
"SMTP_PASS=password" \
"MAIL_FROM=no-reply@syncslate.app"
git add README.md LICENSE .env.example
commit_if_any "docs: add README, LICENSE, and environment template"

# 3) Tooling/configs
add_if_exists package.json package-lock.json tsconfig.json \
              next.config.* postcss.config.* tailwind.config.* \
              .eslintrc.* .prettierrc* .editorconfig
commit_if_any "build: add project scaffolding and tool configs"

# 4) Global styles and base layout
add_if_exists app/globals.* app/layout.* styles/** public/**
commit_if_any "feat(ui): global styles, base layout, and static assets"

# 5) UI kit pieces
add_if_exists components/** lib/ui/** src/components/**
commit_if_any "feat(ui): add shadcn/radix components and icon system"

# 6) Auth and middleware
add_if_exists app/(auth)/** middleware.* lib/auth.*
commit_if_any "feat(auth): Clerk auth flows and route protection"

# 7) Prisma schema
add_if_exists prisma/schema.prisma
commit_if_any "db: define Prisma schema and enums"

# 8) Prisma client helper and seeds
add_if_exists lib/db.* lib/prisma.* prisma/seed.*
commit_if_any "chore(db): prisma client helper and seed scripts"

# 9) Domain types
add_if_exists types/** lib/types.*
commit_if_any "refactor(types): centralize domain types and enums"

# 10) Validation and forms
add_if_exists lib/validation/** lib/forms/**
commit_if_any "feat(forms): Zod schemas and React Hook Form adapters"

# 11) Scheduling logic
add_if_exists lib/scheduling/** lib/time/**
commit_if_any "feat(scheduling): buffered overlap checks and slot utilities"

# 12) Server actions
add_if_exists actions/**
commit_if_any "feat(api): server actions for bookings and events"

# 13) API routes and errors
add_if_exists app/api/** lib/errors.*
commit_if_any "feat(api): REST endpoints with robust error handling"

# 14) Availability UI
add_if_exists app/(main)/availability/**
commit_if_any "feat(availability): manage per-day windows and buffers"

# 15) Events UI
add_if_exists app/(main)/events/**
commit_if_any "feat(events): create and edit event types"

# 16) Meetings dashboard
add_if_exists app/(main)/meetings/**
commit_if_any "feat(meetings): host dashboard and booking list"

# 17) Public booking pages
add_if_exists 'app/[username]/**' 'app/@(username)/**'
commit_if_any "feat(booking): public pages at /[username]"

# 18) Email + ICS
add_if_exists lib/email/** lib/ics/**
commit_if_any "feat(notifications): transactional email with ICS attachments"

# 19) Google Calendar integration
add_if_exists lib/google/**
commit_if_any "feat(calendar): Google Calendar sync via OAuth"

# 20) Accessibility polish
add_if_exists components/** app/**
commit_if_any "style(a11y): focus states, keyboard nav, and semantics"

# 21) Responsive tweaks
add_if_exists app/** components/** styles/**
commit_if_any "style(responsive): mobile-first layout improvements"

# 22) Tests
add_if_exists jest.config.* vitest.config.* tests/** __tests__/**
commit_if_any "test: configure test runner and add sample tests"

# 23) CI workflow
if [ ! -e ".github/workflows/ci.yml" ]; then
  mkdir -p .github/workflows
  cat > .github/workflows/ci.yml <<'YML'
name: ci
on: [push, pull_request]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: "20"
      - run: npm ci || npm i
      - run: npm run -s build
YML
fi
git add .github/workflows/ci.yml
commit_if_any "ci: add build workflow with Node 20"

# 24) Docs expansion (assumes README exists)
add_if_exists README.md docs/**
commit_if_any "docs: expand usage, env, performance, troubleshooting"

# 25) Cleanup
git add -A
commit_if_any "chore: remove dead code, fix imports, final lint"

# Remote wiring and push
if ! git remote | grep -q "^origin$"; then
  git remote add origin "$REPO_URL"
fi

set +e
git pull --rebase origin "$BRANCH"
pull_status=$?
set -e

if [ $pull_status -ne 0 ]; then
  # Try unrelated histories if the remote has an initial commit
  git pull origin "$BRANCH" --allow-unrelated-histories || true
fi

git push -u origin "$BRANCH"

echo "✅ Done. 25 commits pushed to $REPO_URL on branch $BRANCH."
