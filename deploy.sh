#!/bin/bash

# Check for changes
CHANGES=$(git status --porcelain)

if [ -n "$CHANGES" ]; then
  # Print changed files
  echo "Changed files:"
  echo "$CHANGES" | awk '{print $2}'

  # Ask user to commit
  read -p "Commit changes? (yes/no): " RESPONSE
  if [ "${RESPONSE,,}" = "yes" ]; then
    # Prompt for commit message
    read -p "Enter commit message: " MESSAGE

    # Commit and push changes
    git add .
    git commit -m "$MESSAGE"
    git push

    # Copy .sh files
    cp see/*.sh dertoz/

    # Log deployment
    TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
    echo "$TIMESTAMP - Deployed files:" >> logs/deploy.log
    echo "$CHANGES" | awk '{print $2}' >> logs/deploy.log
    echo "Deployment successful!"
  else
    echo "Deployment cancelled."
  fi
else
  echo "No changes to deploy."
fi

