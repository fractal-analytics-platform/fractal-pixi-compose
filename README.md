# fractal-pixi-compose

A [pixi](https://pixi.sh) workspace that manages local environments and startup for [fractal-server](https://github.com/fractal-analytics-platform/fractal-server) and [fractal-web](https://github.com/fractal-analytics-platform/fractal-web).

## Requirements

- [pixi](https://pixi.sh/latest/#installation)

## Setup

Run these once before starting the services for the first time.

**1. Install all environments**

```bash
pixi install -a
```

This will install all the dependency for the `fractal-server` and `fractal-web` environments, as well as the Python interpreters for task packages.

**2. Set up fractal-server**

```bash
pixi run -e fractal-server fractal-server-setup
```

This task:
- Initializes the PostgreSQL database
- Creates a `resources.json` file with absolute paths based on the `scripts/_resources_template.json`.
- Sets up a default admin user `admin@example.org` with password `1234`.

**Important**: Re-running this task will reset the database and delete all data.

**3. Set up fractal-web** (clones the repository and installs npm dependencies)

```bash
pixi run -e fractal-web fractal-web-setup
```

## Running

### With process-compose (recommended)

Starts PostgreSQL, fractal-server, and fractal-web in the correct order, with health checks between each step.

```bash
# Headless (logs streamed to terminal)
pixi run -e orchestrator start
```

Services:
| Service | URL |
|---|---|
| PostgreSQL | (not exposed) |
| fractal-server API | http://localhost:8000 |
| fractal-web | http://localhost:5173 |

### Manually (three terminals)

**Terminal 1 — PostgreSQL**

```bash
pixi run -e fractal-server sh -c 'postgres -D $PGDATA'
```

**Terminal 2 — fractal-server**

```bash
pixi run -e fractal-server fractal-server-start
```

**Terminal 3 — fractal-web**

```bash
pixi run -e fractal-web fractal-web-start
```

To stop, press `Ctrl+C` in each terminal. To check whether PostgreSQL is still running:

```bash
pixi run -e fractal-server pg_ctl status -D local/postgres/data
```

If it is still running, shut it down with:

```bash
pixi run -e fractal-server _pg-stop
```

## Project structure

```
.
├── pixi.toml              # Environment and task definitions
├── process-compose.yaml   # Process orchestration (startup order, health checks)
├── scripts/
│   ├── _resources_template.json # Resource template (uses {{PIXI_PROJECT_ROOT}} tokens, committed to git)
│   └── build_resources.py       # Converts _resources_template.json → resources.json
└── resources.json               # Generated resource config (absolute paths, gitignored)
```

### pixi environments

| Environment | Purpose |
|---|---|
| `fractal-server` | fractal-server + PostgreSQL (Python 3.13) |
| `fractal-web` | fractal-web (Node.js 20) |
| `orchestrator` | process-compose |
| `py11`–`py14` | Bare Python interpreters for fractal task workers |
