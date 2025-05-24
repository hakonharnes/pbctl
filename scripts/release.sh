#!/bin/bash

# Release script for pbctl
# Usage: ./release.sh <version>
# Example: ./release.sh 0.4.5

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if version argument is provided
if [ $# -eq 0 ]; then
  echo -e "${RED}Error: Version number required${NC}"
  echo "Usage: $0 <version>"
  echo "Example: $0 0.4.5"
  exit 1
fi

VERSION=$1
SWIFT_FILE="Sources/pbctl.swift"

# Validate version format (basic semver check)
if ! [[ "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo -e "${RED}Error: Invalid version format${NC}"
  echo "Version should be in format: X.Y.Z (e.g., 0.4.5)"
  exit 1
fi

# Check if Swift file exists
if [ ! -f "$SWIFT_FILE" ]; then
  echo -e "${RED}Error: $SWIFT_FILE not found${NC}"
  exit 1
fi

# Check if we're in a git repository
if ! git rev-parse --git-dir >/dev/null 2>&1; then
  echo -e "${RED}Error: Not in a git repository${NC}"
  exit 1
fi

# Check for uncommitted changes
if ! git diff-index --quiet HEAD --; then
  echo -e "${YELLOW}Warning: You have uncommitted changes${NC}"
  read -p "Do you want to continue? (y/N) " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Aborted"
    exit 1
  fi
fi

# Check if tag already exists
if git tag -l "v$VERSION" | grep -q .; then
  echo -e "${RED}Error: Tag v$VERSION already exists${NC}"
  exit 1
fi

# Get current version from file
CURRENT_VERSION=$(grep -o 'pbctl [0-9]\+\.[0-9]\+\.[0-9]\+' "$SWIFT_FILE" | head -1 | awk '{print $2}')

if [ -z "$CURRENT_VERSION" ]; then
  echo -e "${RED}Error: Could not find current version in $SWIFT_FILE${NC}"
  exit 1
fi

echo "Current version: $CURRENT_VERSION"
echo "New version: $VERSION"

# Update version in Swift file
echo -e "${GREEN}Updating version in $SWIFT_FILE...${NC}"

# Use sed to replace the version
if [[ "$OSTYPE" == "darwin"* ]]; then
  # macOS sed requires -i ''
  sed -i '' "s/pbctl $CURRENT_VERSION/pbctl $VERSION/" "$SWIFT_FILE"
else
  # GNU sed
  sed -i "s/pbctl $CURRENT_VERSION/pbctl $VERSION/" "$SWIFT_FILE"
fi

# Verify the change
if ! grep -q "pbctl $VERSION" "$SWIFT_FILE"; then
  echo -e "${RED}Error: Failed to update version in file${NC}"
  exit 1
fi

# Show the diff
echo -e "${GREEN}Changes:${NC}"
git diff "$SWIFT_FILE"

# Commit the change
echo -e "${GREEN}Committing version change...${NC}"
git add "$SWIFT_FILE"
git commit -m "Bump version to $VERSION"

# Create tag
echo -e "${GREEN}Creating tag v$VERSION...${NC}"
git tag -a "v$VERSION" -m "Release version $VERSION"

# Push to origin
echo -e "${GREEN}Pushing to GitHub...${NC}"
read -p "Push to origin? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  git push origin main
  git push origin "v$VERSION"
  echo -e "${GREEN}✓ Successfully released version $VERSION${NC}"
  echo -e "${GREEN}✓ Tag v$VERSION has been pushed to GitHub${NC}"
else
  echo -e "${YELLOW}Changes committed locally but not pushed${NC}"
  echo "To push manually, run:"
  echo "  git push origin main"
  echo "  git push origin v$VERSION"
fi
