CS Department Setup
===================

1. Create a config/database.yml.  You might be able to use config/database.example without too much trouble.

2. Create SQLite3 databases in db/ folder:
  unix-% sqlite3 calvincs_test.db
  sqlite> .schema
  sqlite> .quit
    This may or may not work with the full_migration_test.
