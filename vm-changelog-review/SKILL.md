---
name: vm-changelog-review
description: Write or review VictoriaMetrics CHANGELOG entries (SECURITY, FEATURE, BUGFIX, Update Note). Use when the user asks to add or write a changelog entry, check or fix changelog lines, write a release note for a change, asks whether a change needs a changelog entry, or edits docs/**/CHANGELOG*.md.
allowed-tools: Bash(git diff:*), Bash(git branch -r:*), Bash(git status:*), WebFetch
---

## Rules

Files:
- Changelog files match `docs/**/CHANGELOG[_YYYY].md`. `CHANGELOG.md` holds the current year, `CHANGELOG_YYYY.md` files hold previous years.
- Edit `CHANGELOG.md`, never the current year's `CHANGELOG_YYYY.md`: it only includes `CHANGELOG.md` via `{{% content "CHANGELOG.md" %}}`.
- Keep the header at the top of `CHANGELOG.md` (description and links) intact.
- Ignore the `vmdocs` directory: it is generated and can't be committed.

Placement:
- New entries go to the `tip` section (merged, not released). Touch released versions only to refine an entry or add a missing one.
- Within a version: update notes first, then `SECURITY`, `FEATURE`, `BUGFIX` groups, with a blank line between groups and between update notes.

Entries:
- Format: `* TYPE: <components or features>: <description>. See [#N](link). Thanks to @github_username for the contribution.`
- Every entry must match the actual code change: type, components, flag/metric/API names, default values and behavior.
- Components or features: each one links to its docs page. `FEATURE` and `BUGFIX` must list at least one; `SECURITY` and update notes may omit them. See [Components or features](#components-or-features).
- Describe the change from the user's perspective, not too technically. Link the relevant doc section inline where possible.
- End with a link to the related issue/PR/commit (for `SECURITY`, the advisory, CVE or release notes).
- Add the thanks sentence to `SECURITY`, `FEATURE` and `BUGFIX` entries only when the code is by an external contributor. Never guess who the contributor is; ask.
- A version in link text must match the version in the entry.

See [examples.md](examples.md) for real entries of every type.

## Review workflow

1. Ask the user which base to compare against and whether the change is by an external contributor, unless they already said. Ask in three `AskUserQuestion` calls, one after another:
   1. Remote: `origin`, `opensource`, `enterprise`. The user can also type the whole `<remote>/<branch>`; then skip the branch question.
   2. Base branch: offer only branches that exist on the chosen remote (`git branch -r --list '<remote>/*'`), from `main`, `master`, `cluster`, `enterprise-single-node`, `enterprise-cluster`.
   3. External contributor: `no`, or `yes` with their GitHub username typed in.

   The base is `<remote>/<branch>`.
2. Collect the changelog changes: `git diff <base>...HEAD -- 'docs/**/CHANGELOG*.md'` plus uncommitted changes.
3. Read the code changes: `git diff <base>...HEAD` plus uncommitted changes.
4. Check each changed entry against the code change. Flag claims the code doesn't support and user-visible changes the entry leaves out.
   If the change [belongs in the changelog](#what-belongs-in-the-changelog) and there is no entry, report it.
5. Check each changed entry against the [rules](#rules) and the section for its type.
6. Report every problem with a corrected line. Say nothing about entries that are fine.

## Write workflow

1. Ask for the base and the external contributor as in step 1 of the [review workflow](#review-workflow).
2. Read the code changes: `git diff <base>...HEAD` plus uncommitted changes.
3. Decide whether the change [belongs in the changelog](#what-belongs-in-the-changelog), and pick the type: security, feature, bugfix or update note.
4. Find the affected [components or features](#components-or-features) and the related issue/PR. If the issue/PR can't be found, ask the user.
5. Add the entry to the right group in `tip` of `CHANGELOG.md`, or update the existing entry for the same change.
6. Every time you add or edit an entry, re-check it as in [review workflow](#review-workflow) steps 4–5: against the code change, the [rules](#rules) and the section for its type.

## What belongs in the changelog

- Changes visible to end users must be in the changelog: new functionality, fixed bugs, security fixes, changed behavior, flags, metrics or APIs.
- Code changes by external contributors are usually reflected in the changelog to credit them, even if they aren't visible to end users, e.g. refactoring or tests. The maintainer who merges the change makes the final decision.
- Refactoring, chores, tests and other changes invisible to end users can be omitted when they are done by the team.

## Version layout

`tip`:

```md
## tip

**Update Note 1:** xxx

**Update Note 2:** yyy

* SECURITY: xxx
* SECURITY: yyy

* FEATURE: xxx
* FEATURE: yyy

* BUGFIX: xxx
* BUGFIX: yyy
```

Released versions have the same body below a version header. A release candidate has a tag but no release date:

```md
## [v1.156.0](https://github.com/VictoriaMetrics/VictoriaMetrics/releases/tag/v1.156.0)

Release candidate
```

A released version has a release date:

```md
## [v1.156.0](https://github.com/VictoriaMetrics/VictoriaMetrics/releases/tag/v1.156.0)

Released at 2026-11-09
```

An LTS release also has an LTS note after the release date:

```md
## [v1.148.9](https://github.com/VictoriaMetrics/VictoriaMetrics/releases/tag/v1.148.9)

Released at 2026-11-06

**v1.148.x is a line of [LTS releases](https://docs.victoriametrics.com/victoriametrics/lts-releases/). It contains important up-to-date bugfixes for [VictoriaMetrics enterprise](https://docs.victoriametrics.com/victoriametrics/enterprise/).
All these fixes are also included in [the latest community release](https://github.com/VictoriaMetrics/VictoriaMetrics/releases/latest).
The v1.148.x line will be supported for at least 12 months since [v1.148.0](https://docs.victoriametrics.com/victoriametrics/changelog/#v11480) release**
```

## Security

Security entries fix vulnerabilities or reduce exposure to them. Upgrades of the Go builder, the base docker image or dependencies affect all components and usually omit them.
For a fix in VictoriaMetrics code, describe the risk from the user's perspective without details that help exploit it.

```md
* SECURITY: upgrade Go builder from Go1.27.3 to Go1.27.4. See [the list of issues addressed in Go1.27.4](https://github.com/golang/go/issues?q=milestone%3AGo1.27.4%20label%3ACherryPickApproved).
* SECURITY: upgrade base docker image (Alpine) from 3.24.2 to 3.24.3. See [Alpine 3.24.3 release notes](https://www.alpinelinux.org/posts/Alpine-3.21.9-3.22.7-3.23.7-3.24.3-released.html).
* SECURITY: upgrade golang.org/x/net from v0.33.0 to v0.36.0 to address [CVE-2025-22870](https://github.com/advisories/GHSA-qxp5-gwg8-xv66).
* SECURITY: <components or features>: description of the fixed vulnerability. See [GHSA-xxxx-xxxx-xxxx](https://github.com/VictoriaMetrics/VictoriaMetrics/security/advisories/GHSA-xxxx-xxxx-xxxx).
```

When reviewing, open every link in a security entry and check that it points to the right page: the advisory or CVE exists, the release notes match the upgraded version, and the Go milestone matches the Go version.
VictoriaMetrics advisories (`https://github.com/VictoriaMetrics/*/security/advisories/GHSA-*`) are usually published after the release and may not open yet; only check that they follow this URL format.

## Features

Features add functionality that didn't exist before.

```md
* FEATURE: <components or features>: description. See [#11384](https://github.com/VictoriaMetrics/VictoriaMetrics/issues/11384). Thanks to @github_username for the contribution.
```

## Bugfixes

Bugfixes fix incorrect behavior of existing functionality. Describe how it works now, then how it worked before, so users can tell whether they were affected.

```md
* BUGFIX: <components or features>: description of how it works now. Previously, description of how it worked before. See [#11384](https://github.com/VictoriaMetrics/VictoriaMetrics/issues/11384). Thanks to @github_username for the contribution.
```

## Update notes

Update notes warn users about what they must know or do when upgrading:

- breaking changes: changed default flag values, new required flags or parameters, removed or renamed flags, metrics, APIs or docker tags, changed API behavior;
- deprecations, e.g. a flag deprecated in favor of another one;
- actions required before or after the upgrade, e.g. a config to adjust or components to upgrade together;
- known issues found after a release was published, e.g. a regression causing memory leaks or failures.

Number them sequentially within a release, starting from 1, and separate them with a blank line. Only the `**Update Note N:**` label is bold.
An update note must tell users what to do: how to keep the previous behavior, what to migrate to, or which version to upgrade or roll back to.

```md
**Update Note 1:** <components or features>: the default value of `-flagName` command-line flag has changed from `false` to `true`. Description of how this affects users. If you rely on the previous behavior, pass `-flagName=false`. See [#11384](https://github.com/VictoriaMetrics/VictoriaMetrics/issues/11384).

**Update Note 2:** <components or features>: the `-oldFlag` command-line flag is deprecated. Use `-newFlag` instead. See [#11384](https://github.com/VictoriaMetrics/VictoriaMetrics/issues/11384).

**Update Note 3:** <components or features>: description of the issue and its impact. The bug was introduced in [#11000](https://github.com/VictoriaMetrics/VictoriaMetrics/pull/11000). Upgrade to [v1.2.4](https://github.com/VictoriaMetrics/VictoriaMetrics/releases/tag/v1.2.4) or roll back to [v1.2.2](https://github.com/VictoriaMetrics/VictoriaMetrics/releases/tag/v1.2.2). See [#11384](https://github.com/VictoriaMetrics/VictoriaMetrics/issues/11384).
```

## Components or features

An entry can list several components or features. If the change is part of the enterprise offering, prefix the component with `[enterprise](https://docs.victoriametrics.com/victoriametrics/enterprise/)`.

Pick components from the file for the repository being changed:

- [VictoriaMetrics](https://github.com/VictoriaMetrics/VictoriaMetrics/): [components-victoriametrics.md](components-victoriametrics.md)
- [vmestimator](https://github.com/VictoriaMetrics/vmestimator): [components-vmestimator.md](components-vmestimator.md)
- [operator](https://github.com/VictoriaMetrics/operator): [components-operator.md](components-operator.md)
