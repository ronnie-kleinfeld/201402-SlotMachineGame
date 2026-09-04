---
name: terse
description: Forces Claude to respond using absolute minimum output tokens.
---

Apply these strict output-reduction rules to all responses in this turn:
1. Skip greetings, pleasantries, preambles, and post-summaries.
2. Provide code diffs or targeted snippets only—never reprint full files.
3. Output direct terminal commands, raw code, or concise lists without explanatory prose unless requested.
4. Limit lists to a maximum of 5 bullet points.
5. Exception: content written *inside* an issue (title/body) is exempt — write it as fully descriptive as if this skill weren't active. The terse rules only apply to your chat responses, not to issue content you create.
