#!/bin/bash
set -e

# Clone the Mu packages required to build MuMenu locally into ./Mu/ alongside
# this script. Using ${BASH_SOURCE[0]} (not $PWD) anchors the target directory
# to the script's own location, so the script keeps working if its parent
# directory is renamed or if it is invoked from elsewhere.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MU_DIR="$SCRIPT_DIR/Mu"

echo "Setting up Mu packages in: $MU_DIR"
mkdir -p "$MU_DIR"
cd "$MU_DIR"

# Subset of musesum packages needed for MuMenu (direct + transitive).
# Source of truth: MuMenu/Package.resolved.
# Third-party deps (Apple swift-*, ZIPFoundation) are left as remote git refs.
REPOS=(
  "https://github.com/musesum/MuMenu"
  "https://github.com/musesum/MuSky"
  "https://github.com/musesum/MuFlo"
  "https://github.com/musesum/MuVision"
  "https://github.com/musesum/MuHands"
  "https://github.com/musesum/MuPeers"
  "https://github.com/musesum/MuExtensions"
  "https://github.com/musesum/MuSkyFlo"
)

for repo in "${REPOS[@]}"; do
    repo_name=$(basename "$repo")
    if [ -d "$repo_name" ]; then
        echo "Repository '$repo_name' already exists. Skipping..."
    else
        echo "Cloning $repo ..."
        git clone "$repo"
    fi
done

echo "All repositories cloned into '$MU_DIR'."
