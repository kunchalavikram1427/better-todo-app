# Better Todo App

A polished Flask todo application with persistent storage, Docker support, and a full set of Claude Code skills and commands for AI-assisted development.

## Features

- Add, complete, and delete todo items
- Live stats dashboard (total, open, done)
- SQLite for local development, PostgreSQL via Docker Compose
- Clean white UI with gradient buttons and stat cards
- Responsive design (desktop, tablet, mobile)

## Quick Start

### Local Python

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
python run.py
# Open http://localhost:5000
```

### Docker Compose

```bash
docker compose up --build
# Open http://localhost:5000
```

### With Claude Code

```
/dev            # sets up venv + deps + starts the server
/docker-up      # builds and launches the Docker stack
```

## Environment Variables

| Variable | Purpose | Default |
|----------|---------|---------|
| `DATABASE_URL` | SQLAlchemy connection string | `sqlite:///instance/todos.db` |
| `SECRET_KEY` | Flask session secret | `dev-secret-key` |
| `FLASK_DEBUG` | Enable debug mode (`1`, `true`, `yes`, `on`) | off |
| `DB_CONNECT_RETRIES` | Database connection retry attempts | `10` |
| `DB_CONNECT_DELAY` | Seconds between retries | `2` |

---

## Claude Code Skills & Commands

This repo demonstrates both **skills** (`.claude/skills/`) and **commands** (`.claude/commands/`) — the two ways to extend Claude Code with custom slash commands.

### Skills vs Commands — When to Use Which

| | Commands | Skills |
|---|---|---|
| **Location** | `.claude/commands/<name>.md` | `.claude/skills/<name>/SKILL.md` |
| **Format** | Single markdown file | Directory with entry point + supporting files |
| **Supporting files** | Not supported | `templates/`, `examples/`, `scripts/`, reference docs |
| **YAML frontmatter** | Same fields supported | Same fields supported |
| **Creates slash command** | Yes — filename becomes `/name` | Yes — directory name becomes `/name` |
| **Auto-triggering** | Yes — Claude reads the `description` | Yes — Claude reads the `description` |
| **Best for** | Simple, self-contained tasks | Complex workflows needing templates, examples, or validation scripts |
| **Name conflict rule** | **Skill wins** if both share the same name | Takes precedence over commands |
| **Status** | Fully supported, not deprecated | Recommended for new work |

**Rule of thumb:** Start with a command. Promote to a skill when you need supporting files.

---

### Commands (`.claude/commands/`)

Commands are single markdown files. The filename (minus `.md`) becomes the slash command.

```
.claude/commands/
├── health.md        # creates /health
└── reset-db.md      # creates /reset-db
```

#### How to use commands

Type the slash command directly in Claude Code:

```
/health              # quick project health check
/reset-db            # delete SQLite DB for a clean schema reset
```

#### How commands work

1. You type `/health` in Claude Code
2. Claude reads `.claude/commands/health.md`
3. The YAML frontmatter tells Claude the name, description, and argument hints
4. The markdown body is the instruction set Claude follows
5. Claude executes the steps and reports back

#### Command file anatomy

```yaml
---
name: health                          # slash command name
description: Quick project health     # when Claude should auto-trigger this
  check — shows git status and deps.
argument-hint: ""                     # autocomplete hint (empty = no args)
---

Markdown instructions that Claude follows when this command is invoked.
```

#### `/health` — Project Health Check

Shows git branch, uncommitted changes, venv status, dependencies, SQLite database, and Docker containers in a quick summary table.

```
/health
```

#### `/reset-db` — Reset the Local Database

Deletes `instance/todos.db` so tables are recreated on next server start. Use this after changing the model schema.

```
/reset-db
```

---

### Skills (`.claude/skills/`)

Skills are directories. Each contains a `SKILL.md` entry point and optional supporting files that Claude reads at runtime.

```
.claude/skills/
├── add-feature/
│   ├── SKILL.md                        # Entry point
│   ├── conventions.md                  # Project coding standards reference
│   ├── examples/
│   │   └── priority-feature.md         # Worked example of a full feature
│   └── scripts/
│       └── validate.sh                 # Syntax and structure validation
│
├── dev/
│   ├── SKILL.md
│   ├── templates/
│   │   └── status-report.md            # Output format template
│   └── scripts/
│       └── setup.sh                    # Bootstrap script
│
├── review/
│   ├── SKILL.md
│   ├── templates/
│   │   └── review-checklist.md         # 35-item review checklist
│   ├── examples/
│   │   └── sample-report.md            # Example review report
│   └── scripts/
│       └── lint.sh                     # Static analysis scanner
│
├── test-gen/
│   ├── SKILL.md
│   ├── templates/
│   │   ├── conftest.py.md              # Pytest fixture boilerplate
│   │   └── test-template.py.md         # Test naming conventions
│   ├── examples/
│   │   └── sample-tests.md             # Complete test suite example
│   └── scripts/
│       └── run-tests.sh                # Test runner script
│
└── docker-up/
    ├── SKILL.md
    ├── templates/
    │   └── status-report.md            # Docker status format
    ├── examples/
    │   └── successful-run.md           # Example successful launch
    └── scripts/
        └── preflight.sh                # Docker prerequisite checks
```

#### How to use skills

Type the slash command with optional arguments:

```
/add-feature add a priority field with color-coded badges
/dev
/dev 8080
/review
/review security
/test-gen
/test-gen routes
/docker-up
/docker-up --status
```

Some skills also **auto-trigger** — Claude reads the `description` field and activates the skill when your request matches. For example, saying "can you review the code for security issues?" will auto-trigger `/review` without typing the slash command.

#### How skills work

1. You type `/add-feature add due dates` or just ask "add a due date feature"
2. Claude reads `.claude/skills/add-feature/SKILL.md`
3. The YAML frontmatter configures behavior (tools allowed, auto-trigger, argument hints)
4. The markdown body references supporting files: `[conventions.md](conventions.md)`, `[examples/priority-feature.md](examples/priority-feature.md)`
5. Claude reads those supporting files on demand for additional context
6. Claude executes the instructions, optionally running `scripts/validate.sh`
7. Claude reports what was done

#### Skill file anatomy

```yaml
---
name: add-feature                                    # slash command name
description: Implements a new feature end-to-end     # triggers auto-invocation
  across the Flask todo app.
argument-hint: "[feature description]"               # shown in autocomplete
allowed-tools: Read, Grep, Glob, Edit, Write, Bash   # tool restrictions
disable-model-invocation: false                      # true = manual /slash only
---

Instructions referencing supporting files:
- Read [conventions.md](conventions.md) for coding standards
- See [examples/priority-feature.md](examples/priority-feature.md) for a worked example
- Run `bash ${CLAUDE_SKILL_DIR}/scripts/validate.sh` to validate changes
```

#### Supporting file types

| Directory | Purpose | Example |
|-----------|---------|---------|
| `templates/` | Output format and boilerplate that Claude follows for consistent responses | `review-checklist.md` — 35-item checklist Claude walks through |
| `examples/` | Fully worked examples used as few-shot references | `sample-tests.md` — complete pytest suite Claude mirrors |
| `scripts/` | Executable shell scripts Claude runs during skill execution | `validate.sh` — checks Python syntax, HTML blocks, CSS braces |
| Root-level `.md` | Reference documents with project-specific knowledge | `conventions.md` — design system tokens and coding standards |

#### Frontmatter fields — all 5 on every skill

| Field | Purpose | When to set |
|-------|---------|-------------|
| `name` | Slash command name in the `/` menu | Always |
| `description` | Tells Claude when to auto-trigger based on what the user asks | Always — be specific with keywords |
| `argument-hint` | Autocomplete hint shown after the command (e.g. `[port]`) | When the skill accepts input |
| `allowed-tools` | Restricts which tools Claude can use while the skill is active | Use to enforce read-only or limit scope |
| `disable-model-invocation` | `true` prevents Claude from auto-triggering — requires manual `/` invocation | Set `true` for side-effects (servers, Docker, deployments) |

**Full audit of this project's skills:**

| Skill | `argument-hint` | `allowed-tools` | `disable-model-invocation` |
|-------|-----------------|-----------------|---------------------------|
| `/add-feature` | `[feature description]` | Read, Grep, Glob, Edit, Write, Bash | `false` — auto-triggers on "add a feature..." |
| `/dev` | `[port]` | Bash, Read | `true` — manual only (starts a server) |
| `/review` | `[file-or-area]` | Read, Grep, Glob (read-only) | `false` — auto-triggers on "review the code..." |
| `/test-gen` | `[routes\|models\|all]` | Read, Grep, Glob, Edit, Write, Bash | `false` — auto-triggers on "write tests..." |
| `/docker-up` | `[--rebuild \| --status \| --down]` | Bash, Read | `true` — manual only (launches containers) |

---

### All 7 Slash Commands at a Glance

| Command | Source | What it does | Auto-triggers? |
|---------|--------|-------------|----------------|
| `/health` | command | Quick project health table | Yes |
| `/reset-db` | command | Delete SQLite DB for clean schema | Yes |
| `/add-feature` | skill | Implement a feature across all layers | Yes |
| `/dev` | skill | Set up venv + start Flask dev server | No (manual) |
| `/review` | skill | Code quality audit with severity ratings | Yes |
| `/test-gen` | skill | Generate pytest test suite | Yes |
| `/docker-up` | skill | Build and launch Docker Compose stack | No (manual) |

---

### Creating Your Own

#### Add a command (simple, single-file)

Create `.claude/commands/my-command.md`:

```yaml
---
name: my-command
description: What it does and when Claude should trigger it
argument-hint: "[optional args]"
---

Instructions for Claude to follow.
Use $ARGUMENTS to reference user input.
```

#### Add a skill (rich, with supporting files)

Create `.claude/skills/my-skill/SKILL.md`:

```yaml
---
name: my-skill
description: What it does and when Claude should trigger it
argument-hint: "[optional args]"
allowed-tools: Read, Grep, Glob
disable-model-invocation: false
---

Instructions for Claude.
Reference supporting files: [templates/output.md](templates/output.md)
Run validation: `bash ${CLAUDE_SKILL_DIR}/scripts/check.sh`
```

Then add supporting files as needed:
- `templates/` — output formats
- `examples/` — worked references
- `scripts/` — validation and automation

The command or skill appears in the `/` menu on the next Claude Code session.
