# Guiding principles: calledtoconstruct/omarchy-cyber-lab

## Purpose and scope
An Omarchy bar badge that shows whether a packet capture is running and whether the newest lab folder names who authorized it.

## Stack and layout
Omarchy plugin `manifest.json`, `LabWidget.qml`, Bash `status.sh` (prints one JSON object), test script `test/status.sh`.

## Commands
| Check | Command | Evidence |
|---|---|---|
| Validate | `omarchy plugin validate .` | README.md |
| Lint | None configured | - |
| Tests | `test/status.sh` (uses `CYBER_LAB_WORK` to point at temp folders) | test/status.sh, README.md |
| CI | None | repository tree |

Commands marked as not written down come from the build files, not from project docs; confirm them before relying on them.

## Before every push
Before every push: run the build and type-check/lint that exist here, plus only the tests for the files or feature you changed (team rule, ideas #14 note 6797). Do not run the full suite locally as a routine gate; this repository has no CI that runs the full suite, so run the full suite only when the change is broad, and say in the PR that CI coverage is missing. Merge needs a positive review. Explain any new failure your change caused. Never weaken a valid test to make it pass, and never invent a command this file does not list.

## Project rules
- The badge only reports. It never starts a capture, installs packages or edits `scope.md`.
- Tests use a temporary work folder, never the real `~/Work`.

## What to avoid
- Committing to the default branch; work on a branch and open a pull request.
- Deleting files, branches or history, or changing repository settings.
- Adding tooling, CI or dependencies that the change does not need.
- Rules copied from other projects (file-size limits, clocks, quotas) that this repository never adopted.

## Delivery and safety
- Installed by the cyber bundle in omarchy-bundles or with `omarchy plugin add`.

## Open questions
- No CI.

## Sources
Read from the `main` branch on 2026-11-08 ET: `README.md`, `manifest.json`, `test/status.sh`.

## Instruction updates
Check `guiding-principles.version` at the start of each turn and when you enter this project; reload this file when the version changes. Change this file, its version and date, and `PRINCIPLES_HISTORY.md` in the same commit. Team-wide role instructions are versioned separately in the team-process repository.
