# Agent Instructions

## General style

- Answer concisely.
- Read relevant files before you make codebase claims.
- Ask a clarifying question when ambiguity prevents safe progress.
- State the desired behavior directly. Do not add defensive warnings when the positive instruction already covers them.

## Clear technical writing

- Use one consistent term for each concept. Do not change terms for stylistic variety.
- Prefer familiar words, direct statements, and active voice.
- Put one action in each instruction or numbered step.
- State a condition before its action. Example: “If validation fails, stop the workflow.”
- Target 20 words or fewer for instructions and 25 words or fewer for descriptions.
- Give each paragraph one topic. Use headings and vertical lists to show structure.
- Keep notes informational. Do not hide required actions in notes or explanations.
- Identify each hazard, its possible consequence, and the action that prevents it.
- Preserve exact commands, identifiers, API names, and quotations.
- Preserve required domain terms.

## Existing ticket and PR streams

For Jira or PR questions, including comment assessment, check for existing watcher sockets in the relevant worktree:

- Jira: `/tmp/<worktree-name>-jira-stream.sock`
- GitHub: `/tmp/<worktree-name>-github-stream.sock`

Use `ticket-watch` or `pr-watch` for connection and replay instructions.
Existing sockets replay recorded events, then stream live events.
For one-time questions, read with a bounded wait and close only your connection.
Verify the stream matches the requested ticket or PR.
Fetch missing evidence through the appropriate Jira or GitHub tools.
