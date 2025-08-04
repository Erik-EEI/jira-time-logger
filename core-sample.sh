#!/bin/zsh

# Jira Time Logger Configuration
# Copy this file to ~/.script/core.sh and update with your actual values

# Your Jira instance base URL for REST API v2
# Replace 'yourcompany' with your actual Jira domain
export JIRA_BASE_URL="https://yourcompany.atlassian.net/rest/api/2"

# Your Jira API token
# Get this from: https://id.atlassian.com/manage-profile/security/api-tokens
# Replace with your actual API token
export JIRA_API_TOKEN="your_jira_api_token_here"

# Your Jira username (usually your email or username)
# Replace with your actual Jira username
export JIRA_USERNAME="your.username"

# Default time for worklog entries (24-hour format)
# This is the time that will be used when logging work entries
export JIRA_DEFAULT_TIME="12:00"

# Optional: Add any custom aliases or functions here
# Example:
# alias jt="jira status"
# alias jtv="jira status -v"
