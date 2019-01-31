#!/bin/sh

# This will build and commit any changes to the site, it stashes unstaged
# changes before building

set -e

git stash -k -u
git clean -d -f # Stashing restores deleted files, remove them before building

hugo --cleanDestinationDir --baseURL "https://nchlswhttkr.github.io/"
rm public/CNAME

cd public
git add .
git commit -m "published site changes" --allow-empty
cd ..

git stash pop
