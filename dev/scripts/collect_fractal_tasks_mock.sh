#!/bin/bash

set -eu

WHEEL_FILE_NAME="fractal_tasks_mock-0.0.1-py3-none-any.whl"
LOCAL_WHEEL_FILE="local/$WHEEL_FILE_NAME"

# Fetch wheel file
wget \
    --quiet \
    -O "$LOCAL_WHEEL_FILE" \
    "https://github.com/fractal-analytics-platform/fractal-server/raw/e0a3ca44f521fe622cf1d3a09d3e5058b096c6f2/tests/v2/fractal_tasks_mock/dist/$WHEEL_FILE_NAME"
ls -lh "$LOCAL_WHEEL_FILE"

# Get token
FRACTAL_TOKEN=$(
    curl \
    --no-progress-meter \
    http://localhost:8000/auth/token/login/ \
    -X POST \
    -H "Content-Type: application/x-www-form-urlencoded" \
    -d "username=admin@example.org&password=1234" \
    | python3 -c 'import sys, json; print(json.load(sys.stdin)["access_token"])'
)
echo "Got FRACTAL_TOKEN"

# Trigger task collection
curl \
    --no-progress-meter \
    -X POST \
    "http://localhost:8000/api/v2/task/collect/pip/" \
    -H "Authorization: Bearer $FRACTAL_TOKEN" \
    -F "file=@./local/fractal_tasks_mock-0.0.1-py3-none-any.whl"
echo

echo "End"
