---
name: commit-and-pr-instructions
description: Use when writing commit messages or pull request titles and descriptions; apply the user's Conventional Commit types, scope rules, and title/body format.
---

# Commit Message and Pull Request Description Generation Instructions

## Summary

Both commit messages and pull request descriptions should be structured as follows:

---

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

Scope rules (monorepo):

- In most cases, not needed to specify scopes.
- The scope MUST be the exact package (workspace) name as declared in that package's `package.json`.
- Prefer the short folder alias for brevity unless cross-publishing context matters.
- Do NOT invent new scope names; derive them from existing workspace directories or published package names.

Breaking change example with scope:

```
feat(design)!: drop legacy single-token search fallback

BREAKING CHANGE: search now returns empty list if all tokens are filtered out
```

---

**For Pull Requests:**

- The commit message title becomes the **pull request title**
- The commit message body becomes the **pull request description body**

---

The commit/pull request contains the following structural elements, to communicate intent to the consumers of your library:

1. **fix:** a commit/PR of the _type_ `fix` patches a bug in your codebase (this correlates with [`PATCH`](http://semver.org/#summary) in Semantic Versioning).
2. **feat:** a commit/PR of the _type_ `feat` introduces a new feature to the codebase (this correlates with [`MINOR`](http://semver.org/#summary) in Semantic Versioning).
3. **BREAKING CHANGE:** a commit/PR that has a footer `BREAKING CHANGE:`, or appends a `!` after the type/scope, introduces a breaking API change (correlating with `MAJOR` in Semantic Versioning).
   A BREAKING CHANGE can be part of commits/PRs of any _type_.

### Type

Must be one of the following:

- **build**: Changes that affect the build system or external dependencies (example scopes: gulp, broccoli, npm)
- **ci**: Changes to our CI configuration files and scripts (example scopes: Travis, Circle, BrowserStack, SauceLabs)
- **docs**: Documentation only changes
- **feat**: A new feature
- **fix**: A bug fix
- **perf**: A code change that improves performance
- **refactor**: A code change that neither fixes a bug nor adds a feature
- **style**: Changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)
- **test**: Adding missing tests or correcting existing tests

## Examples

### Commit message with description and breaking change footer

```
feat: allow provided config object to extend other configs

BREAKING CHANGE: `extends` key in config file is now used for extending other config files
```

### Commit message with `!` to draw attention to breaking change

```
feat!: send an email to the customer when a product is shipped
```

### Commit message with scope and `!` to draw attention to breaking change

```
feat(api)!: send an email to the customer when a product is shipped
```

### Commit message with both `!` and BREAKING CHANGE footer

```
chore!: drop support for Node 6

BREAKING CHANGE: use JavaScript features not available in Node 6.
```

### Commit message with no body

```
docs: correct spelling of CHANGELOG
```

### Commit message with scope

```
feat(lang): add Polish language
```

### Commit message with multi-paragraph body and multiple footers

```
fix: prevent racing of requests

Introduce a request id and a reference to latest request. Dismiss
incoming responses other than from latest request.

Remove timeouts which were used to mitigate the racing issue but are
obsolete now.

Reviewed-by: Z
Refs: #123
```
