# Start — detect project state and ask about intent

This reference is loaded when the user invokes the skill with no specific intent. By the time it loads, SKILL.md Step 1 has already resolved the fortrabbit config (or established that none exists). Do not re-check for `.fortrabbit` or env vars here.

---

## Step 1 — Detect the software stack

Load `software-detection.md` and follow its detection procedure.

---

## Step 2 — Check for Git and GitHub

```shell
git rev-parse --git-dir 2>/dev/null && echo "git repo" || echo "not a git repo"
git remote -v 2>/dev/null
```

Note whether:
- The folder is a Git repository
- A remote named `origin` points to `github.com`
- The GitHub CLI (`gh`) is authenticated: `gh auth status 2>/dev/null`

---

## Step 3 — Summarize and route

Present a one-paragraph status summary based on all findings. Example:

> "This looks like a **Craft CMS** project. fortrabbit is configured (`app-env-id: en-wjl0ai`, region: `eu-w1a`). Git is initialized with a GitHub remote. You're ready to deploy."

If everything is in place, suggest the logical next action and stop — do not ask the user a question they don't need to answer.

| State | Route to |
|-------|----------|
| fortrabbit configured + software detected + git ready | Suggest `/fortrabbit deploy` or relevant operation |
| fortrabbit configured + software detected + no git | Load `setup-git-github.md` |
| fortrabbit configured + no software detected | Load `software-detection.md` |
| No fortrabbit config + software detected | Go to Path A below |
| Folder empty or no software detected, no config | Go to Path B below |

---

## Path A — Connect an existing project to fortrabbit

The user has a local codebase and wants to connect it to fortrabbit.

1. Confirm the detected software stack (or ask if unclear).
2. Ask for the fortrabbit app environment ID and region if not already known.
3. Load `setup.md` — it covers writing `.fortrabbit`, SSH key setup, and testing the connection.
4. Once SSH works, load `setup-git-github.md` to wire up Git and GitHub.
5. Suggest `/fortrabbit deploy` once everything is connected.

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

2. Load `local-development.md` to check whether DDEV or another local dev tool is already available. If nothing is set up, direct the user to install DDEV from [ddev.readthedocs.io](https://ddev.readthedocs.io) and scaffold a project for the chosen software.

3. Once the local project is running, continue with Path A.
