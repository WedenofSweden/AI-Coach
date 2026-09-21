#!/bin/sh
set -eu

OPTIONS_FILE=/data/options.json

if [ ! -r "$OPTIONS_FILE" ]; then
    echo "[coach-addon] Missing $OPTIONS_FILE" >&2
    exit 1
fi

export OPENAI_API_KEY="$(jq -r '.OPENAI_API_KEY // empty' "$OPTIONS_FILE")"
export HEVY_API_KEY="$(jq -r '.HEVY_API_KEY // empty' "$OPTIONS_FILE")"
export WITHINGS_CLIENT_ID="$(jq -r '.WITHINGS_CLIENT_ID // empty' "$OPTIONS_FILE")"
export WITHINGS_CLIENT_SECRET="$(jq -r '.WITHINGS_CLIENT_SECRET // empty' "$OPTIONS_FILE")"
export SMTP_PASSWORD="$(jq -r '.SMTP_PASSWORD // empty' "$OPTIONS_FILE")"
export GARMIN_EMAIL="$(jq -r '.GARMIN_EMAIL // empty' "$OPTIONS_FILE")"
export GARMIN_PASSWORD="$(jq -r '.GARMIN_PASSWORD // empty' "$OPTIONS_FILE")"
export COACH_WEEKLY_HOUR="$(jq -r '.weekly_hour // 19' "$OPTIONS_FILE")"
export COACH_WEEKLY_MINUTE="$(jq -r '.weekly_minute // 0' "$OPTIONS_FILE")"

export COACH_DB_PATH="/data/state/coach.db"

cd "/share/workout planner"
# `serve` performs the daily weekly-schedule check and runs post-workout
# processing every 15 minutes (the defaults in orchestrator.py).
exec python orchestrator.py serve
