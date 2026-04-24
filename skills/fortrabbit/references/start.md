# Start — detect project state and ask about intent

This reference is loaded when the user invokes the skill with no specific intent. This is usually the first step.

---

## Definitions

Before routing, evaluate these four conditions:

- **software detected** — at least one signal from `software-detection.md` matches (see that file for the full ordered check list)
- **fortrabbit configured** — `.fortrabbit` file exists in the project root, OR `.env` contains `FORTRABBIT_APP_ENV_ID`
- **git ready** — ALL of the following are true:
  - `git rev-parse --git-dir` succeeds (repo exists)
  - `git remote get-url origin` returns a URL
  - either `git status --porcelain` is empty, or the user has acknowledged uncommitted changes
- **git absent** — `.git/` does not exist in the project root
- **git partial** — repo exists (`git rev-parse --git-dir` succeeds) but no `origin` remote is set

---

## Step 1 — Detect the software stack

Load `software-detection.md` and follow its detection procedure.

---

## Step 2 — Check local development setup

Load `local-development.md` and follow its detection procedure. This covers local dev tooling, Git and GitHub status, and whether the project is ready to run locally.

---

## Step 3 — Summarize and route

Present a one-paragraph status summary based on all findings. Example:

> "This looks like a **Craft CMS** project. fortrabbit is configured (`app-env-id: en-wjl0ai`, region: `eu-w1a`). Git is initialized with a GitHub remote. You're ready to deploy."

Then route using this decision tree (evaluate in order, first match wins):

```
IF NOT software detected AND NOT fortrabbit configured
  → Load connect.md from Step 1 (full onboarding — account, app, SSH)

ELSE IF software detected AND NOT fortrabbit configured
  → Load connect.md from Step 3 (skip account/app creation, go straight to app-env-id lookup)

ELSE IF fortrabbit configured AND NOT software detected
  → Load software-detection.md, then return here and re-evaluate

ELSE IF fortrabbit configured AND software detected
  IF git ready
    → Show summary and say: "You're ready to deploy."
      Suggest: /fortrabbit deploy

  ELSE IF git absent
    → Ask: "No Git repo found. Do you want to:
        A) Set up Git deployment (connects GitHub → fortrabbit)
        B) Use rsync to sync files directly (no Git required)"
      IF A → Load setup-git-github.md
      IF B → Load sync.md

  ELSE IF git partial (repo exists but no origin remote)
    → Load setup-git-github.md starting at the step for adding a GitHub remote
```
