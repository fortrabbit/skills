# Database operations

fortrabbit databases are only accessible from within the environment or via an SSH tunnel from your local machine. Direct remote connections are not allowed.

The MySQL credentials for your environment are shown in the dashboard under:
**Dashboard → Environment → MySQL → Access**

---

## Create an SSH tunnel (required for all local DB operations)

Open a dedicated terminal window and keep it running:

```shell
# Terminal window 1 — keep this open
ssh -N -L 13306:mysql:3306 APP_ENV_ID@ssh.REGION.frbit.app
# No output is expected. That means it worked. Open a new terminal window.
```

The tunnel maps `localhost:13306` on your machine to the remote MySQL server. Port 13306 is the convention; any port in the range 1025–65535 works. Remote port must always be 3306.

---

## Get and store the remote database password

The remote database requires a password for connection. Get the password from the fortrabbit dashboard:

**Dashboard → Environment → MySQL → Access**

To avoid entering the password each time, store it locally:

### Option 1: Store in .env (recommended for secrets)

Add to your `.env` file:

```env
FORTRABBIT_DB_PASSWORD=your_actual_password_here
```

Make sure `.env` is in `.gitignore`.

### Option 2: Store in .fortrabbit

If you prefer to keep all fortrabbit config together, add to `.fortrabbit`:

```text
app-env-id=en-xxxxxx
region=eu-w1a
db-password=your_actual_password_here
```

Then update your database commands to use the stored password instead of prompting.

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
