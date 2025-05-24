#!/bin/bash

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

if [ $# -eq 0 ]; then
  echo -e "${RED}Error: Version number required${NC}"
  echo "Usage: $0 <version>"
  exit 1
fi

VERSION=$1
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SWIFT_FILE="$PROJECT_ROOT/Sources/pbctl.swift"

cd "$PROJECT_ROOT"

if ! [[ "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo -e "${RED}Error: Invalid version format${NC}"
  exit 1
fi

if git tag -l "v$VERSION" | grep -q .; then
  echo -e "${RED}Error: Tag v$VERSION already exists${NC}"
  exit 1
fi

CURRENT_VERSION=$(grep -o 'pbctl [0-9]\+\.[0-9]\+\.[0-9]\+' "$SWIFT_FILE" | head -1 | awk '{print $2}')

echo "Current version: $CURRENT_VERSION"
echo "New version: $VERSION"

if [[ "$OSTYPE" == "darwin"* ]]; then
  sed -i '' "s/pbctl $CURRENT_VERSION/pbctl $VERSION/" "$SWIFT_FILE"
else
  sed -i "s/pbctl $CURRENT_VERSION/pbctl $VERSION/" "$SWIFT_FILE"
fi

git add "$SWIFT_FILE"
git commit -m "Bump version to $VERSION"
git tag -a "v$VERSION" -m "Release version $VERSION"

echo -e "${GREEN}Pushing to GitHub...${NC}"
git push origin main
git push origin "v$VERSION"

echo -e "${GREEN}Creating GitHub release...${NC}"
gh release create "v$VERSION" --title "v$VERSION" --generate-notes

echo -e "${GREEN}Successfully released version $VERSION${NC}"
