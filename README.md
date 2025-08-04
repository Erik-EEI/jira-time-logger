![img.png](docs/logo.png)
# Jira Time Logger CLI

A ZSH command-line tool for logging and tracking work hours in Jira. This script allows you to log time entries to Jira tickets and check your daily worklog status directly from the terminal.

## 📋 Overview

The Jira Time Logger CLI provides two main functions:
- **Status checking**: View your logged hours for any date with detailed breakdowns
- **Time logging**: Log work hours to specific Jira tickets with support for date ranges and comments

Features include:
- ✅ Log time to Jira tickets with automatic validation
- 📊 View worklog summaries with verbose table output
- 🛡️ Built-in 8-hour daily limit protection
- 📅 Support for date ranges and historical logging
- 💬 Add comments to work entries
- 🎨 Formatted output with indicators

## 🚀 Installation

### Prerequisites

Ensure you have the following tools installed:
- **ZSH shell** (default on macOS)
- **curl** (for HTTP requests)
- **jq** (for JSON parsing)
- **bc** (for calculations)

Install missing dependencies on macOS:
```bash
brew install jq
```

### Setup Steps

1. **Create the scripts directory:**
   ```bash
   mkdir -p ~/.script
   ```

2. **Copy the script files:**
   ```bash
   # Copy the main jira script
   cp jira ~/.script/jira
   chmod +x ~/.script/jira
   
   # Copy and configure the core.sh file
   cp core-sample.sh ~/.script/core.sh
   ```

3. **Configure your Jira credentials** (see Configuration section below)

4. **Add to your ZSH profile:**
   Add this line to your `~/.zshrc` file:
   ```bash
   export PATH="$HOME/.script:$PATH"
   ```

5. **Reload your shell:**
   ```bash
   source ~/.zshrc
   ```

## ⚙️ Configuration

### Core Configuration File

Create and configure `~/.script/core.sh` with your Jira credentials:

```bash
#!/bin/zsh

# Jira Configuration
export JIRA_BASE_URL="https://yourcompany.atlassian.net/rest/api/2"
export JIRA_API_TOKEN="your_jira_api_token_here"
export JIRA_USERNAME="your.username"
export JIRA_DEFAULT_TIME="12:00"  # Default time for worklog entries
```

### Getting Your Jira API Token

1. Go to [Atlassian Account Settings](https://id.atlassian.com/manage-profile/security/api-tokens)
2. Click "Create API token"
3. Give it a label (e.g., "CLI Time Logger")
4. Copy the generated token to your `core.sh` file

### Environment Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `JIRA_BASE_URL` | Your Jira REST API base URL | `https://company.atlassian.net/rest/api/2` |
| `JIRA_API_TOKEN` | Your personal API token | `ATATT3xFfGF0...` |
| `JIRA_USERNAME` | Your Jira username | `john.doe` |
| `JIRA_DEFAULT_TIME` | Default time for worklog entries | `12:00` |

## 📖 Commands

### `jira status` - Check Worklog Status

View your logged hours for a specific date.

#### Syntax
```bash
jira status [-date YYYY-MM-DD] [-v|--verbose]
```

#### Flags
- `-date YYYY-MM-DD`: Specify date to check (defaults to today)
- `-v, --verbose`: Show detailed table with ticket titles

#### Examples

**Check today's logged hours:**
```bash
jira status
```
Output:
```
🗓 Worklog details for 2025-08-03
────────────────────────────
PROJ-123      2.50 hrs
PROJ-456      3.25 hrs
────────────────────────────
Total logged hours: 5.75
```

**Check specific date:**
```bash
jira status -date 2025-08-01
```

**Verbose output with full details:**
```bash
jira status -v
```
Output:
```
┌───────────────┬──────────────────────────────────────────┬────────────┬--------┐
│ Ticket        │ Title                                    │ Date       │ Hours  │
├───────────────┼──────────────────────────────────────────┼────────────┼--------┤
│ PROJ-123      │ Fix login authentication bug             │ 2025-08-03 │   2.50 │
│ PROJ-456      │ Implement user dashboard feature         │ 2025-08-03 │   3.25 │
└───────────────┴──────────────────────────────────────────┴────────────┴--------┘
Total logged hours: 5.75
```

**Check specific date with verbose output:**
```bash
jira status -date 2025-07-30 -v
```

### `jira log` - Log Work Time

Log work hours to a specific Jira ticket.

#### Syntax
```bash
jira log -ticket <TICKET_ID> -time <HOURS> [-date YYYY-MM-DD | -range YYYY-MM-DD..YYYY-MM-DD] [-comment "message"]
```

#### Required Flags
- `-ticket <TICKET_ID>`: Jira ticket ID (e.g., PROJ-123)
- `-time <HOURS>`: Hours to log (decimal format, e.g., 2.5)

#### Optional Flags
- `-date YYYY-MM-DD`: Specific date to log time (defaults to today)
- `-range YYYY-MM-DD..YYYY-MM-DD`: Log time for a date range
- `-comment "message"`: Add a comment to the worklog entry

#### Examples

**Log time for today:**
```bash
jira log -ticket PROJ-123 -time 3.5
```
Output:
```
✅ Logged 3.5h on PROJ-123 for 2025-08-03 at 12:00
```

**Log time for specific date:**
```bash
jira log -ticket PROJ-456 -time 2.0 -date 2025-08-01
```

**Log time with comment:**
```bash
jira log -ticket PROJ-789 -time 1.5 -comment "Fixed critical authentication bug"
```

**Log time for date range:**
```bash
jira log -ticket PROJ-123 -time 4.0 -range 2025-08-01..2025-08-03
```
This will log 4 hours for each day in the range (Aug 1, 2, and 3).

**Complex example with all options:**
```bash
jira log -ticket PROJ-456 -time 2.5 -date 2025-08-02 -comment "Completed user interface redesign"
```

### `jira suggest` - Suggest Tickets for Logging

Quickly list your assigned issues in open sprints to help you decide where to log your time.

#### Syntax
```bash
jira suggest [-v|--verbose]
```

#### Flags
- `-v, --verbose`: Show a table with ticket number, the first 30 characters of the ticket title, and status

#### Examples

**Simple list (ticket and status):**
```bash
jira suggest
```
Output:
```
┌───────────────┬────────────────────┐
│ Ticket        │ Status             │
├───────────────┼────────────────────┤
│ PROJ-123      │ In Progress        │
│ PROJ-456      │ To Do              │
└───────────────┴────────────────────┘
```

**Verbose table (ticket, title, status):**
```bash
jira suggest -v
```
Output:
```
┌───────────────┬────────────────────────────────┬────────────────────┐
│ Ticket        │ Title                          │ Status             │
├───────────────┼────────────────────────────────┼────────────────────┤
│ PROJ-123      │ Fix login authentication bug   │ In Progress        │
│ PROJ-456      │ Implement dashboard            │ To Do              │
└───────────────┴────────────────────────────────┴────────────────────┘
```

This command uses the filter `sprint in openSprints() AND assignee = currentUser()` to show only your issues in any open sprint.

## 🛡️ Safety Features

### Daily Hour Limit Protection
The script automatically prevents logging more than 8 hours per day:

```bash
jira log -ticket PROJ-123 -time 6.0  # This will fail if you already have 3+ hours logged
```
Output:
```
⚠️  Already logged 3.25 h on 2025-08-03. Adding 6.0 h would exceed 8 hours.
```

### Invalid JSON Handling
The script gracefully handles corrupted worklog data:
```
⚠️ Skipping PROJ-456 — invalid JSON after cleanup
```

## 🚨 Error Handling & Troubleshooting

### Common Issues

**1. "Command not found: jira"**
- Ensure `~/.script` is in your PATH
- Check that the script is executable: `chmod +x ~/.script/jira`
- Reload your shell: `source ~/.zshrc`

**2. "curl: command not found"**
```bash
# Install curl (usually pre-installed on macOS)
brew install curl
```

**3. "jq: command not found"**
```bash
brew install jq
```

**4. Authentication errors**
- Verify your API token is correct
- Check that `JIRA_USERNAME` matches your Jira account
- Ensure `JIRA_BASE_URL` is correct

**5. "Unknown option" errors**
- Check flag syntax: use `-date` not `--date`
- Ensure required flags are provided for `log` command

### Debug Mode
Add debug output by modifying the script temporarily:
```bash
# Add this line after the curl commands to see API responses
echo "API Response: $response"
```

## 💡 Best Practices

### Daily Time Management
- **Stay under 8 hours**: The script enforces this automatically
- **Log frequently**: Don't wait until end of day to log time
- **Use meaningful comments**: Help track what you accomplished

### Ticket Organization
```bash
# Good: Specific, actionable comments
jira log -ticket PROJ-123 -time 2.0 -comment "Implemented user authentication API endpoints"

# Avoid: Vague comments
jira log -ticket PROJ-123 -time 2.0 -comment "worked on stuff"
```

### Date Range Usage
```bash
# Log time for a week of vacation catch-up
jira log -ticket PROJ-456 -time 6.0 -range 2025-07-28..2025-08-01 -comment "Vacation backlog processing"
```

### Workflow Integration
Add aliases to your `~/.zshrc` for common operations:
```bash
# Quick aliases
alias jt="jira status"           # Today's status
alias jtv="jira status -v"       # Verbose today's status
alias jy="jira status -date \$(date -v-1d +%Y-%m-%d)"  # Yesterday's status
```

## 📁 File Structure

Your setup should look like this:
```
~/.script/
├── core.sh          # Configuration file with API credentials
└── jira              # Main executable script

~/.zshrc              # Should include PATH export
```

## 🔧 Sample Configuration Files

### Sample `~/.script/core.sh`
```bash
#!/bin/zsh

# Jira Configuration
export JIRA_BASE_URL="https://mycompany.atlassian.net/rest/api/2"
export JIRA_API_TOKEN="ATATT3xFfGF0T8..."  # Your actual API token
export JIRA_USERNAME="john.doe"
export JIRA_DEFAULT_TIME="12:00"
```

### Sample `~/.zshrc` Addition
```bash
# Add to the end of your ~/.zshrc file
export PATH="$HOME/.script:$PATH"

# Optional: Helpful aliases
alias jt="jira status"
alias jtv="jira status -v"
alias jlog="jira log"
```

## 📝 License

MIT License - Feel free to modify and distribute as needed.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📞 Support

For issues or questions:
1. Check the troubleshooting section above
2. Verify your configuration matches the examples
3. Test with verbose output to see detailed error messages
