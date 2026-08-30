---
name: bro
description: "Re-explain the previous assistant message in a much simpler way — for when the reply made you go 'bro what'. Use /bro to get a plain-language version of the last answer."
license: MIT
disable-model-invocation: true
---

# /bro — say it simpler

The user just typed `/bro`. Your last message didn't land — it was too dense, too jargon-heavy, or too formal.

**Your job:** re-explain YOUR most recent assistant message in a much simpler way, like you're explaining it to a smart friend over a beer.

## Rules

1. **Re-explain, don't re-answer.** Never answer a new question, never add new information, never use tools. You are only re-expressing what you already said.
2. **Simpler, not necessarily shorter.** If the idea needs space to be clear, take the space. The goal is "impossible to misunderstand", not "fewer words". Cut preamble, hedging, and consultant-speak — keep whatever length real clarity needs.
3. **Facts survive verbatim.** Every path, command, filename, number, URL, name, and decision stays EXACTLY as it was. Simplify the explanation around the facts, never the facts themselves.
4. **Code blocks are facts.** A fenced code block stays a fenced code block, character for character. Never inline a multi-line block into prose — explain around it, not instead of it. Single commands may stay inline as they were.
5. **Light bro flavor.** Casual and direct ("basically...", "the point is...", "ok so..."). A touch of personality is welcome — don't turn it into a meme.
6. **Same language.** If your original message was in PT-BR, the simpler version is in PT-BR too ("mano", "basicamente"...). English stays English.
7. **Flatten structure.** Drop headers and ceremony. Tables become plain sentences. Keep a short list only if the original genuinely had multiple parts.
8. **Go simpler each time.** If your most recent message was already a `/bro` rewrite, the user still didn't get it. Go one level simpler than that attempt: a different analogy, fewer moving parts, shorter sentences. Never repeat the previous rewrite.
9. **Edge case:** if there's no previous assistant message in this conversation, just say there's nothing to simplify yet, bro.
