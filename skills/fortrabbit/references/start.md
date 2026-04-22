# Start — detect project state and ask about intent

This reference is loaded when the user invokes the skill with no specific intent. This is usually the first step.

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

| State                                                       | Route to                                           |
| ----------------------------------------------------------- | -------------------------------------------------- |
| Folder empty or no software detected + no fortrabbit config | Load `connect.md`                                  |
| No fortrabbit config + software detected                    | Load `connect.md`                                  |
| fortrabbit configured + software detected + no git          | Load `deploy.md`                                   |
| fortrabbit configured + no software detected                | Load `connect.md` go to step 6                     |
| fortrabbit configured + software detected + git ready       | Suggest `/fortrabbit deploy` or relevant operation |
