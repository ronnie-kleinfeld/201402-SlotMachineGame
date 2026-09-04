---
name: save-then-clear
description: Save key decisions/status from this session to memory, then tell the user it's safe to /clear. Use when the user asks to save session context before clearing, wrap up before /clear, or checkpoint progress before ending the session.
---

Review this entire session (not just the last topic) and save whatever is durable to memory: decisions made, current status of any in-progress work, open questions, and anything the user explicitly confirmed or corrected. Follow the normal memory rules (types, exclusions, dedup against existing memory files, update MEMORY.md).

Do not save things already covered by an existing up-to-date memory file - update that file instead of duplicating it.

When done, reply with a short list of what was saved (or updated), and end with: "Safe to /clear now."
