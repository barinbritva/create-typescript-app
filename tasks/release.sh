#!/bin/bash

# todo check is git repository
# todo check master branch
echo "Check if working directory clean."
if [ -n "$(git status --porcelain)" ]; then
  echo "Git working directory not clean. Please commit changes or stash them before release."
  exit 1
fi

echo "Run build process."
npm run build

packageVersion=$(grep version package.json | cut -c 15- | rev | cut -c 3- | rev)
echo "Tag version as $packageVersion."
git tag "$packageVersion"

echo "Publish package as $packageVersion."
npm publish --access public

echo "Bump package version."
npm --no-git-tag-version version patch
packageVersion=$(grep version package.json | cut -c 15- | rev | cut -c 3- | rev)
git add package.json package-lock.json
git commit -m "Bump version to $packageVersion."

echo "Push changes to Git."
git push && git push --tags
