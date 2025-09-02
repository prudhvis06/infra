#!/bin/bash

set -e

echo "🚀 Executing full infrastructure setup..."

# Step 1: Run parts 1, 2, and 3
echo "▶️ Running part 1..."
bash infra-setup-part1.sh

echo "▶️ Running part 2..."
bash infra-setup-part2.sh

echo "▶️ Running part 3..."
bash infra-setup-part3.sh
