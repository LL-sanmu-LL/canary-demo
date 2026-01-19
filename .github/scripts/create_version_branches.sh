#!/bin/bash

VERSION=$1

if [ -z "$VERSION" ]; then
  echo "Usage: $0 <version>"
  exit 1
fi

echo "Creating feature-$VERSION and release-$VERSION branches..."

# 确保 main 最新
git checkout main
git pull origin main

# 创建 feature 分支
FEATURE_BRANCH="feature-$VERSION"
git checkout -b $FEATURE_BRANCH
git push https://x-access-token:${PAT_TOKEN}@github.com/LL-sanmu-LL/canary-demo.git $FEATURE_BRANCH

# 创建 release 分支
RELEASE_BRANCH="release-$VERSION"
git checkout main
git checkout -b $RELEASE_BRANCH
git push https://x-access-token:${PAT_TOKEN}@github.com/LL-sanmu-LL/canary-demo.git $RELEASE_BRANCH

echo "✅ Branches created: $FEATURE_BRANCH, $RELEASE_BRANCH"
