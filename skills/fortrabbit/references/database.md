# Database operations

fortrabbit databases are only accessible from within the environment or via an SSH tunnel from your local machine. Direct remote connections are not allowed.

The MySQL credentials for your environment are shown in the dashboard under:
**Dashboard → Environment → MySQL → Access**

---

## Create and verify the SSH tunnel (required for all local DB operations)

**Step 1 — Open the tunnel.** Show this command and say: "Open a new terminal window and run this. Leave it running — it produces no output when working correctly:"

```shell
ssh -N -L 13306:mysql:3306 APP_ENV_ID@ssh.REGION.frbit.app
```

Then ask: "Ready? Let me know when the tunnel is open."

**Step 2 — Verify the tunnel** before running any database commands. Run:

```shell
mysql -h127.0.0.1 -P13306 -uAPP_ENV_ID --connect-timeout=5 -e "SELECT 1;" 2>&1
```

Interpret the result:

```
IF output contains "1"
  → Tunnel confirmed. Proceed with database operations.

IF error contains "Connection refused" OR "Can't connect"
  → Tell the user: "The tunnel isn't open yet or it disconnected. Check the terminal window where you started it."

IF error contains "Access denied"
  → Tell the user: "Connected! But the credentials are wrong. Check DB_USER and DB_PASS in the dashboard."

IF command times out
  → Tell the user: "Can't reach the tunnel. Check that port 22 is not blocked and the SSH command is still running."
```

No output = success. Maps `localhost:13306` → remote port 3306.

---

## Get and store the remote database password

Find the password at **Dashboard → Environment → MySQL → Access**.

Store it in `.env` (make sure `.env` is in `.gitignore`):

```env
FORTRABBIT_DB_PASSWORD=your_actual_password_here
```

Commands below show `-p` (prompt) and `-p$FORTRABBIT_DB_PASSWORD` (env var) variants.

---

## db down: download remote database to local

> **Warning:** This overwrites your local database. The current local data will be lost.

```shell
# Terminal window 2
# Step 1: dump from remote via the tunnel
mysqldump --set-gtid-purged=OFF --no-tablespaces \
  -h127.0.0.1 -P13306 -uAPP_ENV_ID -p APP_ENV_ID > fortrabbit-backup.sql
# Enter the MySQL password when prompted (from the dashboard)

# Alternative: if password is stored in .env as FORTRABBIT_DB_PASSWORD
mysqldump --set-gtid-purged=OFF --no-tablespaces \
  -h127.0.0.1 -P13306 -uAPP_ENV_ID -p$FORTRABBIT_DB_PASSWORD APP_ENV_ID > fortrabbit-backup.sql

# Step 2: import into your local database
mysql -uLOCAL_DB_USER -p LOCAL_DB_NAME < fortrabbit-backup.sql
```

For DDEV:

```shell
mysqldump --set-gtid-purged=OFF --no-tablespaces \
  -h127.0.0.1 -P13306 -uAPP_ENV_ID -p APP_ENV_ID > fortrabbit-backup.sql
ddev import-db < fortrabbit-backup.sql
```

---

## db up: upload local database to remote

> **Warning:** This overwrites the remote database. All remote data will be replaced by your local data. Confirm with the user before proceeding.

```shell
# Terminal window 1 — open the tunnel (see above)

# Terminal window 2
# Step 1: dump from local
mysqldump --set-gtid-purged=OFF -uLOCAL_DB_USER -p LOCAL_DB_NAME > local-dump.sql

# Step 2: import into remote via tunnel
mysql -h127.0.0.1 -P13306 -uAPP_ENV_ID -p APP_ENV_ID < local-dump.sql
# Enter the MySQL password when prompted (from the dashboard)

# Alternative: if password is stored in .env as FORTRABBIT_DB_PASSWORD
mysql -h127.0.0.1 -P13306 -uAPP_ENV_ID -p$FORTRABBIT_DB_PASSWORD APP_ENV_ID < local-dump.sql
```

For DDEV:

```shell
ddev export-db > local-dump.sql
mysql -h127.0.0.1 -P13306 -uAPP_ENV_ID -p APP_ENV_ID < local-dump.sql

# Alternative: if password is stored in .env as FORTRABBIT_DB_PASSWORD
mysql -h127.0.0.1 -P13306 -uAPP_ENV_ID -p$FORTRABBIT_DB_PASSWORD APP_ENV_ID < local-dump.sql
```

---

## Connect to the remote database interactively

```shell
# Terminal window 1 — open the tunnel

# Terminal window 2
mysql -uAPP_ENV_ID -h127.0.0.1 -P13306 -p -D APP_ENV_ID

# Alternative: if password is stored in .env as FORTRABBIT_DB_PASSWORD
mysql -uAPP_ENV_ID -h127.0.0.1 -P13306 -p$FORTRABBIT_DB_PASSWORD -D APP_ENV_ID
```

---

## Notes

- The MySQL password is different from your SSH key. Find it in the dashboard.
- The database name and username are both the environment ID (e.g. `en-wjl0ai`).
- Close the tunnel window when done.

After database operations, review the changes in your browser. See [browser-review.md](browser-review.md) for test domain instructions.
