#!/bin/bash

set -euo pipefail

echo 'Debugging'
git diff-tree --no-commit-id --name-status -r HEAD | grep "^A\tcontent/newsletter/....-..\.md" | cut -f 2 | sed -n 's;content/newsletter/\(....-..\)\.md;\1;p' > new-newsletters.txt
cat new-newsletters.txt

echo 'Looping'
while read NEWSLETTER; do
    echo 'Curling'
    curl -X POST "https://api.buildkite.com/v2/organizations/$BUILDKITE_ORGANIZATION_SLUG/pipelines/newsletter/builds" \
        -H "Authorization: Bearer $BUILDKITE_API_TOKEN" \
        -d '{
            "commit": "HEAD",
            "branch": "master",
            "env": {
                "NEWSLETTER_ISSUE": "$NEWSLETTER"
            }
        }'
done < new-newsletters.txt
echo 'Done'