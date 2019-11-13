#!/bin/sh
# Docker entrypoint script.

# Wait until Postgres is ready
while ! pg_isready -q -h $DB_HOST -p 5432 -U $DB_USER
do
  echo "$(date) - waiting for database to start"
  sleep 2
done

./prod/rel/bank_stone/bin/bank_stone eval BankStone.Release.migrate

./prod/rel/bank_stone/bin/bank_stone start   