#!/bin/bash
# deploy_github_pages.sh - Automate GitHub Pages deployment checklist for Auris iOS marketing site

set -e
REPO_URL="https://github.com/PNQHealth/auris-ios-marketing.git"
SITE_URL="https://pnqhealth.github.io/auris-ios-marketing/"
REQUIRED_FILES=("index.html" "404.html" "_config.yml" "sitemap.xml" ".gitignore" ".github/workflows/github-pages.yml")

# 1. Project Preparation
step=1
printf "\n[$step] Checking for required files...\n"
for file in "${REQUIRED_FILES[@]}"; do
  if [ ! -e "$file" ]; then
    echo "ERROR: Missing $file"; exit 1;
  fi
done
ls -l index.html 404.html _config.yml sitemap.xml .gitignore

# 2. Repository Setup
step=$((step+1))
printf "\n[$step] Checking git repository and remote...\n"
if [ ! -d .git ]; then
  echo "Initializing git repo..."; git init;
fi
git remote -v | grep origin | grep "$REPO_URL" || git remote add origin "$REPO_URL"

git fetch origin main || true

# 3. Branch Management
step=$((step+1))
printf "\n[$step] Ensuring on main branch and up to date...\n"
git checkout main
if ! git diff --quiet origin/main..main; then
  echo "Local branch differs from origin/main. Consider pulling changes.";
fi

git pull --rebase origin main

# 4. Commit and Push Changes
step=$((step+1))
printf "\n[$step] Staging, committing, and pushing changes...\n"
git add .
if ! git diff --cached --quiet; then
  git commit -m "Automated: Update marketing site content and configuration"
  git push origin main
else
  echo "No changes to commit."
fi

# 5. GitHub Actions Workflow
step=$((step+1))
printf "\n[$step] Validating GitHub Actions workflow...\n"
if grep -q 'actions/deploy-pages' .github/workflows/github-pages.yml; then
  echo "Workflow looks valid."
else
  echo "ERROR: Workflow does not contain deploy-pages action."; exit 1;
fi

# 6. Trigger Deployment & Monitor
step=$((step+1))
printf "\n[$step] Monitoring GitHub Actions workflow run...\n"
if command -v gh >/dev/null 2>&1; then
  gh run list --limit 5
  latest_run=$(gh run list --limit 1 --json databaseId -q '.[0].databaseId')
  echo "Waiting for workflow run #$latest_run to complete..."
  gh run watch $latest_run
  gh run view $latest_run --log
else
  echo "GitHub CLI (gh) not installed. Please monitor workflow in the GitHub Actions web UI."
fi

# 7. Verify Deployment
step=$((step+1))
printf "\n[$step] Verifying deployed site...\n"
if curl -s --head "$SITE_URL" | grep "200 OK"; then
  echo "Site is live: $SITE_URL"
else
  echo "Site not live yet or returned non-200 status."
fi

# 8. Post-Deployment Checks
step=$((step+1))
printf "\n[$step] Checking sitemap.xml URLs...\n"
if curl -s "$SITE_URL/sitemap.xml" | grep -q '<urlset'; then
  echo "sitemap.xml found and appears valid."
else
  echo "sitemap.xml missing or invalid."
fi

echo "\nAll steps completed. Please check your site and workflow logs for any issues."
