---
name: find-todo-markers
description: Finds all inline TODO-style marker comments across the codebase - a personal pre-delivery checklist convention, not urgent day-to-day bugs. Use when the user asks to list, review, or clean up these marker comments, or before a delivery/release milestone.
---

Some codebases use an inline comment marker like:

```csharp
// TODO: uncomment next line, some error there
```

to flag things that need attention before delivery. These appear in several comment syntaxes across a codebase - `//`/`///` (C-family), `@* ... *@` (Razor), `<!-- ... -->` (XML/HTML), `#` (Python/shell), `'` (VB), etc. They are not urgent bugs to fix reactively - they're a pre-delivery checklist that accumulates over time and needs a final sweep before shipping.

## Steps

1. Search the repo for the marker, covering all comment syntaxes in use in this codebase. A single regex covering most cases: `TODO\??:` - grep for this across the repo, excluding build output directories (`bin/`, `obj/`, `node_modules/`, `dist/`, etc.) and this skill's own file.
2. For each match, capture: file path (relative), line number, and the full comment text (including any code it's commented out around, e.g. the disabled line directly below/above it, since the comment usually refers to adjacent code).
3. Present results grouped by file, as a checklist - not auto-fixed. For each item, quote the comment and the line(s) it's about, so it's reviewable at a glance without opening every file.
4. Do not fix, remove, or uncomment anything automatically - this skill only surfaces the list. Fixing is a separate, explicit task the user picks from the list, typically at a delivery/milestone pass.
5. If the count is large, still list all of them (no silent truncation) - this is meant to be the authoritative pre-delivery list.
