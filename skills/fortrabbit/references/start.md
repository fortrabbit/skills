# Start — detect project state and ask about intent

This reference is loaded when the user invokes the skill with no specific intent. By the time it loads, SKILL.md Step 1 has already resolved the fortrabbit config (or established that none exists). Do not re-check for `.fortrabbit` or env vars here.

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

If everything is in place, suggest the logical next action and stop — do not ask the user a question they don't need to answer.

| State                                                 | Route to                                           |
| ----------------------------------------------------- | -------------------------------------------------- |
| fortrabbit configured + software detected + git ready | Suggest `/fortrabbit deploy` or relevant operation |
| fortrabbit configured + software detected + no git    | Load `deploy.md`                                   |
| fortrabbit configured + no software detected          | Load `software-detection.md`                       |
| No fortrabbit config + software detected              | Go to Path A below                                 |
| Folder empty or no software detected, no config       | Go to Path B below                                 |

---

## Path A — Connect an existing project to fortrabbit

The user has a local codebase but no fortrabbit config was found.

1. Confirm the detected software stack (or ask if unclear).
2. Load `setup.md` — it covers account and app setup, writing `.fortrabbit`, SSH key setup, and testing the connection.
3. Once SSH works, load `setup-git-github.md` to wire up Git and GitHub.
4. Suggest `/fortrabbit deploy` once everything is connected.

---

## Path B — Start from scratch

The user has no local project yet.

1. Ask which software they want to use:
   - WordPress
   - Craft CMS
   - Statamic
   - Kirby CMS
   - Laravel
   - Generic PHP

2. Load `local-development.md` to check whether DDEV or another local dev tool is available.

3. Load the matching framework guide (`wordpress.md`, `craft-cms.md`, `statamic.md`, or `kirby-cms.md`) — each includes local installation steps.

4. Once the local project is running, continue with Path A.
