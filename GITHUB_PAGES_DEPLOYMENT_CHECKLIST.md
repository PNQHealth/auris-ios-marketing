# GitHub Pages Deployment Checklist (CLI-First)

## 1. Project Preparation
- [ ] Ensure your project directory contains all required site files (HTML, CSS, JS, images, etc.).
- [ ] Confirm that your `_config.yml` and `sitemap.xml` (and any other config files) are up-to-date and correct.
- [ ] Make sure your `.gitignore` exists at the project root and is configured to ignore build artifacts, secrets, etc.

## 2. Repository Setup
- [ ] Initialize a git repository (if not already done):
  ```sh
  git init
  ```
- [ ] Add your remote GitHub repository (if not already set):
  ```sh
  git remote add origin https://github.com/<yourusername>/auris-ios-marketing.git
  ```

## 3. Branch Management
- [ ] Ensure you are on the main branch:
  ```sh
  git checkout main
  ```
- [ ] Pull the latest changes to avoid conflicts:
  ```sh
  git pull origin main
  ```

## 4. Commit and Push Changes
- [ ] Stage all updated or new files:
  ```sh
  git add .
  ```
- [ ] Commit your changes with a clear message:
  ```sh
  git commit -m "Update marketing site content and configuration"
  ```
- [ ] Push your changes to GitHub:
  ```sh
  git push origin main
  ```

## 5. GitHub Actions Workflow
- [ ] Ensure `.github/workflows/github-pages.yml` exists and is configured for GitHub Pages deployment.
- [ ] Check the workflow file for:
  - Correct permissions for `GITHUB_TOKEN`
  - Steps to build and upload artifacts
  - Use of `actions/deploy-pages@v1` or equivalent

## 6. Trigger Deployment
- [ ] After pushing, GitHub Actions will automatically trigger the workflow.
- [ ] Monitor the workflow status:
  - Open the Actions tab on your GitHub repo
  - Watch for any errors or failed steps
  - If a failure occurs, read the logs and debug as needed

## 7. Verify Deployment
- [ ] Once the workflow succeeds, visit your GitHub Pages URL:
  ```
  https://<yourusername>.github.io/auris-ios-marketing/
  ```
- [ ] Confirm that your site loads and all links, images, and assets work as expected.

## 8. Post-Deployment Checks
- [ ] Validate your sitemap at `/sitemap.xml` and ensure URLs are correct.
- [ ] Test on multiple devices/browsers if possible.
- [ ] Optionally, use the following to clear your local cache and force-refresh:
  - Chrome: `Cmd+Shift+R`
  - Safari: `Cmd+Option+R`

## 9. Troubleshooting (if needed)
- [ ] If the site does not appear, check:
  - The Actions logs for errors
  - That the repository is set to deploy from the correct branch/folder in GitHub Pages settings
  - That your workflow does not exclude necessary files in the artifact step

---

### Example CLI Commands for Your Project

```sh
# Stage, commit, and push changes
git add .
git commit -m "Update marketing site content and configuration"
git push origin main

# Monitor workflow (in browser, but can use CLI for logs via gh CLI)
gh run list
gh run view <run-id>
```

---

**Tip:**  
If you have the GitHub CLI (`gh`) installed, you can monitor workflow runs and even open the deployed site from the command line.
