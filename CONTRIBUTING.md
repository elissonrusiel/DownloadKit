# Contributing to DownloadKit

DownloadKit follows **GitHub Flow**: `main` is always releasable, and every change reaches it through a pull request.

## Workflow

1. **Open or pick an issue.** Larger work is grouped into milestones that follow the build phases in [`docs/architecture.html`](docs/architecture.html).
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

Tests use [Swift Testing](https://developer.apple.com/documentation/testing). Network behaviour is tested with a stubbed `URLProtocol`; tests never touch the real network.

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
