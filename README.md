# fractal-pixi-compose

A [pixi](https://pixi.sh) workspace that manages local environments and startup for [fractal-server](https://github.com/fractal-analytics-platform/fractal-server) and [fractal-web](https://github.com/fractal-analytics-platform/fractal-web).

## Requirements

- [pixi](https://pixi.sh/latest/#installation)

## Setup

### Install

Install the default platform dependencies
```bash
pixi install
```

Install the default platform dependencies, as well as the Python interpreters for task packages:
```bash
pixi install -a
```

### Set up

 Set up `postgresql`, `fractal-server` and `fractal-web` via

```bash
pixi run setup
```

This task:
- Initializes the PostgreSQL database and starts it.
- Creates a `resources.json` file with absolute paths based on the `scripts/_resources_template.json`.
- Sets up a default admin user `admin@example.org` with password `1234`.

**Important**: Re-running this task will reset the database and delete all data.

### Cleanup

Clean up all data via

```bash
pixi run cleanup
```

## Running

### With process-compose

Starts PostgreSQL, fractal-server, and fractal-web in the correct order, with health checks between each step.

```bash
pixi run process-compose up
```
or
```bash
pixi run process-compose -f process-compose-dev.yaml up
```


Services:
| Service | URL |
|---|---|
| PostgreSQL | (not exposed) |
| fractal-server API | http://localhost:8000 |
| fractal-web | http://localhost:5173 |


## Project structure

```
.
├── pixi.toml                    # Environment and task definitions
├── process-compose.yaml         # Process orchestration (startup order, health checks)
├── process-compose-dev.yaml     # Process orchestration, dev version
├── scripts/
│   ├── _resources_template.json # Resource template (uses {{PIXI_PROJECT_ROOT}} tokens, committed to git)
│   └── build_resources.py       # Converts _resources_template.json → resources.json
└── resources.json               # Generated resource config (absolute paths, gitignored)
```


## TODOs

- Add additional services:
    - fractal-data
    - vizarr
    - dashboard
- Add pixi configuration for task collections.
- Add selected tasks packages collections during setup:
    - fractal-tasks-core
    - fractal-uzh-converters
    - fractal-cellpose-sam-task
- Setup some testing
- Document how to personalize the configuration
