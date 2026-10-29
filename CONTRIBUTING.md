# Contributing to DownloadKit

DownloadKit follows **GitHub Flow**: `main` is always releasable, and every change reaches it through a pull request.

## Workflow

1. **Open or pick an issue.** Every task is an issue written from the **Task spec** template (see [Task specs](#task-specs)). Tasks are sub-issues of an epic, and epics are grouped into milestones that follow the build phases in [`docs/architecture.html`](docs/architecture.html).
2. **Branch from `main`** using a short, prefixed name:

   | Prefix | Use for |
   |---|---|
   | `feat/` | New behaviour, e.g. `feat/scheduler-priorities` |
   | `fix/` | Bug fixes |
   | `chore/` | Tooling, CI, docs, refactors with no behaviour change |

3. **Commit in small steps.** Write the subject line in the imperative mood ("Add retry backoff"), keep it under about 72 characters, and add a body explaining *why* when it isn't obvious.
4. **Open a PR to `main`.** Fill in the template and link the issue (`Closes #N`).
5. **Merge once CI is green.** Squash-merge so each PR becomes one commit on `main`, then delete the branch.

## Local checks

Run these before pushing. CI runs the same checks on macOS 15, plus an iOS Simulator build.

```bash
swift build
swift test
```

## Task specs

A task issue is a complete spec: someone (or an automated workflow) should be able to build it from the issue alone, without asking questions. Create tasks with **New issue → Task spec**.

| Section | What it must contain |
|---|---|
| Epic / Depends on | The parent epic, and the issues that must be closed first. Also link them on GitHub: add the task as a sub-issue of the epic, and each dependency as *blocked by*. |
| Kind / Branch slug | The branch is `<kind>/<issue number>-<slug>`, e.g. `fix/15-http-status-failures` |
| Verify command | The command that proves the task works, usually `swift test --filter <Suite>` |
| Goal | One sentence describing what is true when the task is done |
| Description | Why the task exists and where it fits |
| In scope / Out of scope | Out-of-scope items link to the issue that owns them |
| Files | Source and test files to create or change |
| Design | Signatures, rules, and transition or decision tables |
| Acceptance criteria | Numbered (AC1, AC2, …); each one checkable by a test or a named manual step |
| Test cases | At least one test per acceptance criterion: test name, scenario, expected result |
| Notes | Gotchas, open questions, and anything unverified, labelled as such |

When work reveals that a spec is wrong, update the issue first, then the code.

## Testing rules

These apply to every task unless its spec lists different rules (for example, manual device tests).

- Use [Swift Testing](https://developer.apple.com/documentation/testing) (`import Testing`, `@Test`, `#expect`, `#require`), not XCTest.
- No real network: use `StubURLProtocol` or `FakeTransport` from `Tests/DownloadKitTests/Support/`.
- No `Task.sleep` or wall-clock waits: inject clocks and time sources, and await events instead.
- File-system tests use a unique temporary directory per test and delete it afterwards.
- Every acceptance criterion is covered by at least one test. Name tests after the behaviour (e.g. `pauseKeepsResumeData`).
- Tests must pass in parallel and in any order (`swift test --parallel`).
- Bugs found outside the task's scope get their own issue; do not widen the scope.

## Definition of done

- [ ] All acceptance criteria are met and ticked in the PR description
- [ ] `swift build` and `swift test` pass locally; CI is green
- [ ] No compiler warnings under Swift 6 strict concurrency
- [ ] New or changed public symbols have `///` doc comments
- [ ] If the shipped API differs from `docs/architecture.html`, the doc is updated in the same PR
- [ ] The PR body contains `Closes #<issue>`, and the PR is squash-merged

## Releases

Releases are [SemVer](https://semver.org) git tags on `main`; SwiftPM resolves versions from these tags.

| Change | Bump |
|---|---|
| Breaking public API change | Major (minor while below `1.0.0`) |
| New, backwards-compatible API | Minor |
| Bug fix only | Patch |

To release, tag the latest `main` commit and create a GitHub release with notes:

```bash
git tag -a 0.1.0 -m "DownloadKit 0.1.0"
git push origin 0.1.0
```

Tags have no `v` prefix (`0.1.0`, not `v0.1.0`), which is the SwiftPM convention.
