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

# ⚡ 核心：覆盖 origin URL，使用 PAT
git remote set-url origin https://x-access-token:${PAT_TOKEN}@github.com/LL-sanmu-LL/canary-demo.git

# 创建 feature 分支并 push
FEATURE_BRANCH="feature-$VERSION"
git checkout -b $FEATURE_BRANCH
git push origin $FEATURE_BRANCH

# 创建 release 分支并 push
git checkout main
RELEASE_BRANCH="release-$VERSION"
git checkout -b $RELEASE_BRANCH
git push origin $RELEASE_BRANCH

echo "✅ Branches created and pushed: $FEATURE_BRANCH, $RELEASE_BRANCH"
