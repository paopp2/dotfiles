---
name: google-workspace-cli
description: Use when the task involves Google Workspace services — Gmail, Drive, Sheets, Docs, Calendar, Chat, Tasks, Slides, Forms, Meet, Keep, People, Classroom, or cross-service workflows like standup reports and meeting prep. Triggers on mentions of email, spreadsheets, documents, calendar events, file uploads, chat messages, or any Google Workspace API interaction.
---

# Google Workspace CLI (`gws`)

## Overview

`gws` is a unified CLI for all Google Workspace APIs. Use it instead of writing API code or asking the user to open a browser. All output is structured JSON.

## Command Structure

```
gws <service> <resource> <method> [flags]
```

**Key flags:** `--params '{"key":"val"}'` (query params), `--json '{"key":"val"}'` (request body), `--upload <file>`, `--page-all` (auto-paginate as NDJSON), `--dry-run` (preview without executing), `--format <json|table|yaml|csv>`, `--output <path>` (binary responses).

**Schema introspection:** `gws schema <service.resource.method>` — use this to discover request/response shapes for any API method.

## Services

| Service | Alias | Key Resources |
|---------|-------|---------------|
| `drive` | | files, permissions, comments, drives |
| `gmail` | | users.messages, users.labels, users.threads |
| `sheets` | | spreadsheets, spreadsheets.values |
| `calendar` | | events, calendarList, freebusy |
| `docs` | | documents |
| `chat` | | spaces, spaces.messages |
| `tasks` | | tasklists, tasks |
| `slides` | | presentations, presentations.pages |
| `forms` | | forms, forms.responses |
| `people` | | people, contactGroups |
| `meet` | | conferenceRecords, spaces |
| `keep` | | notes |
| `classroom` | | courses, courseWork |
| `admin-reports` | `reports` | activities, userUsageReport |
| `workflow` | `wf` | cross-service helpers |
| `events` | | subscriptions |
| `modelarmor` | | templates |

## Helper Commands (`+` prefix)

Convenience commands with named flags for common operations. **Always prefer helpers over raw API calls when available.**

### Gmail
| Command | Required Flags |
|---------|---------------|
| `gmail +send` | `--to`, `--subject`, `--body` (optional: `--cc`, `--bcc`) |
| `gmail +reply` | `--message-id`, `--body` |
| `gmail +reply-all` | `--message-id`, `--body` |
| `gmail +forward` | `--message-id`, `--to` |
| `gmail +triage` | (none — shows unread inbox summary) |
| `gmail +watch` | (streams new emails as NDJSON) |

### Drive
| Command | Required Flags |
|---------|---------------|
| `drive +upload` | `<file>` (optional: `--name`, `--parent`) |

### Sheets
| Command | Required Flags |
|---------|---------------|
| `sheets +append` | `--spreadsheet` (use `--values` or `--json-values`) |
| `sheets +read` | `--spreadsheet` |

### Calendar
| Command | Required Flags |
|---------|---------------|
| `calendar +agenda` | (none — shows upcoming events) |
| `calendar +insert` | `--summary`, `--start`, `--end` (ISO 8601, optional: `--location`, `--description`, `--attendee`) |

### Docs
| Command | Required Flags |
|---------|---------------|
| `docs +write` | (append text to a document) |

### Chat
| Command | Required Flags |
|---------|---------------|
| `chat +send` | (send message to a space) |

### Workflow (cross-service)
| Command | Purpose |
|---------|---------|
| `workflow +standup-report` | Today's meetings + open tasks |
| `workflow +meeting-prep` | Agenda, attendees, linked docs for next meeting |
| `workflow +email-to-task` | Convert Gmail message to Tasks entry |
| `workflow +weekly-digest` | Week's meetings + unread email count |
| `workflow +file-announce` | Share Drive file in Chat space |

## Raw API Patterns

When no helper exists, use the three-level structure:

```bash
# List resources
gws <service> <resource> list --params '{"key": "value"}'

# Get a single resource
gws <service> <resource> get --params '{"resourceId": "..."}'

# Create
gws <service> <resource> create --json '{"field": "value"}'

# Update
gws <service> <resource> update --params '{"resourceId": "..."}' --json '{"field": "new"}'

# Delete
gws <service> <resource> delete --params '{"resourceId": "..."}'
```

## Common Recipes

```bash
# List 10 recent Drive files
gws drive files list --params '{"pageSize": 10}'

# Search Drive files by name
gws drive files list --params '{"q": "name contains '\''report'\''", "pageSize": 10}'

# List Gmail messages
gws gmail users messages list --params '{"userId": "me", "maxResults": 10}'

# Get a specific Gmail message
gws gmail users messages get --params '{"userId": "me", "id": "MSG_ID"}'

# Create a spreadsheet
gws sheets spreadsheets create --json '{"properties": {"title": "My Sheet"}}'

# Read spreadsheet values
gws sheets +read --spreadsheet SHEET_ID

# List all calendar events for today
gws calendar +agenda

# List task lists
gws tasks tasklists list --params '{"maxResults": 10}'
```

## Important Notes

- **All output is JSON** by default — pipe to `jq` for extraction. Use `--format table` for human-readable output.
- **Use `--dry-run`** before destructive or send operations to preview what will be sent.
- **Gmail userId is always `"me"`** for the authenticated user.
- **Dates use ISO 8601 / RFC 3339** (e.g., `2026-03-13T09:00:00-07:00`).
- **Use `gws <service> <resource> <method> --help`** to discover exact flags for any command.
- **Use `gws schema <service.resource.method>`** to inspect request/response schemas.
- **Exit codes:** 0=success, 1=API error, 2=auth error, 3=validation error.
- **Auth:** If not authenticated, run `gws auth login`. For scope issues, use `--scopes drive,gmail,sheets,...`.
