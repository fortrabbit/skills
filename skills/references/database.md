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

## Pull: download remote database to local

> **Warning:** This overwrites your local database. The current local data will be lost.

```shell
# Terminal window 2
# Step 1: dump from remote via the tunnel
mysqldump --set-gtid-purged=OFF --no-tablespaces \
  -h127.0.0.1 -P13306 -uAPP_ENV_ID -p APP_ENV_ID > fortrabbit-backup.sql
# Enter the MySQL password when prompted (from the dashboard)

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

## Push: upload local database to remote

> **Warning:** This overwrites the remote database. All remote data will be replaced by your local data. Confirm with the user before proceeding.

```shell
# Terminal window 1 — open the tunnel (see above)

# Terminal window 2
# Step 1: dump from local
mysqldump --set-gtid-purged=OFF -uLOCAL_DB_USER -p LOCAL_DB_NAME > local-dump.sql

# Step 2: import into remote via tunnel
mysql -h127.0.0.1 -P13306 -uAPP_ENV_ID -p APP_ENV_ID < local-dump.sql
# Enter the MySQL password when prompted (from the dashboard)
```

For DDEV:
```shell
ddev export-db > local-dump.sql
mysql -h127.0.0.1 -P13306 -uAPP_ENV_ID -p APP_ENV_ID < local-dump.sql
```

---

## Connect to the remote database interactively

```shell
# Terminal window 1 — open the tunnel

# Terminal window 2
mysql -uAPP_ENV_ID -h127.0.0.1 -P13306 -p -D APP_ENV_ID
```

---

## Notes

- The MySQL password is different from your SSH key. Find it in the dashboard.
- The database name and username are both the environment ID (e.g. `en-wjl0ai`).
- Use `127.0.0.1` not `localhost` — MySQL treats these differently.
- Close the tunnel window when done.
