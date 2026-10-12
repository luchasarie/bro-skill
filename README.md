<div align="center">

# 🤙 /bro

**When the answer made you go "bro what" — type `/bro` and get it in plain language.**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Format: Agent Skills](https://img.shields.io/badge/format-Agent%20Skills-blue)](https://agentskills.io)
[![Works with](https://img.shields.io/badge/works%20with-Hermes%20%C2%B7%20Claude%20Code%20%C2%B7%20Cursor%20%C2%B7%20Codex%20%C2%B7%20opencode-blueviolet)](#compatibility)

</div>

---

## What is this?

`/bro` is a tiny [Agent Skills](https://agentskills.io)-format skill with one job: when the assistant's last reply was too dense, too jargon-heavy, or too formal, you type `/bro` and it re-explains **its own previous message** like a smart friend over a beer.

Got something dense from somewhere else? Type `/bro` followed by the text (an error message, an email, a paragraph of legalese) and it re-explains **that** instead.

No new information. No new answers. Just the same thing, said in a way that's impossible to misunderstand.

It's one markdown file. The whole skill is [`SKILL.md`](SKILL.md).

## Compatibility

Works with any agent that reads the Agent Skills format — and ships thin slash-command wrappers where a skill alone doesn't give you a typed `/bro`:

| Tool | Skill location | `/bro` or skill entry point |
|---|---|---|
| **Hermes Agent** | `~/.hermes/skills/bro/SKILL.md` | skill (auto) |
| **Claude Code** | `~/.claude/skills/bro/SKILL.md` | `~/.claude/commands/bro.md` |
| **Cursor** | `~/.cursor/skills/bro/SKILL.md` | skill (`/bro`) |
| **OpenAI Codex** | `~/.codex/skills/bro/SKILL.md` | skill (`$bro` mention or `/skills`) |
| **opencode** | `~/.config/opencode/skills/bro/SKILL.md` | `~/.config/opencode/command(s)/bro.md` |

The generated wrappers for Claude Code and opencode end with a `$ARGUMENTS` line, which both hosts expand to whatever you typed after `/bro`. Codex, Hermes, and Cursor read `SKILL.md` directly, where your message is already in context. Codex deprecated custom prompts in 0.117.0, so the installer no longer writes `~/.codex/prompts/bro.md`. A stale one from an older install is moved aside to `bro.md.bak` rather than deleted, in case you edited it.

Cursor also reads `~/.codex/skills/` and `~/.claude/skills/` (and the matching project folders) as a compatibility fallback. Don't rely on that — Cursor-only machines often have neither directory. The installer writes `~/.cursor/skills/bro/` whenever it detects Cursor, creating `~/.cursor/skills/` if needed (that folder is not there by default).

## Install

**One-liner** — detects which tools you have and installs into each:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/luchasarie/bro-skill/main/install.sh)
```

**Or from a clone** (better if you want to pull updates later):

```bash
git clone https://github.com/luchasarie/bro-skill.git
cd bro-skill
./install.sh          # installs into every detected tool
./install.sh --all    # or force-install into every supported tool
```

Then restart your agent session and type `/bro` after any reply that made your eyes glaze over, or `/bro <paste anything>` to simplify text from elsewhere. In Codex, invoke the skill with `$bro` instead.

## Update

```bash
cd bro-skill && git pull && ./install.sh
```

(Or just re-run the one-liner — it's idempotent.)

## Examples

**🧱 Software architecture**

> The refactor introduces an idempotent reconciliation layer atop the event-sourced aggregate, thereby mitigating dual-write anomalies during the migration window while preserving backward compatibility with the legacy projection contract.

**`/bro`**

> Ok so basically: we added a safety layer that makes sure old and new data don't get out of sync while we're switching systems. Nothing breaks for anything still using the old system. That's it.

**☸️ Kubernetes panic**

> The CrashLoopBackOff stems from the liveness probe's failure threshold being exceeded due to the application's blocking initialization sequence, which starves the kubelet's health-check endpoint of a timely response…

**`/bro`**

> Bro, your app takes too long to start up. Kubernetes keeps asking "you alive?" and your app is too busy booting to answer, so k8s kills it and restarts it — over and over. Give it more time (`initialDelaySeconds`) or move the slow startup work into an init container.

**🇧🇷 Same-language rule — PT-BR in, PT-BR out**

> A otimização do funil de conversão demanda a implementação de uma estratégia omnichannel de nurturing, visando a maximização do LTV através da redução do churn…

**`/bro`**

> Mano, traduzindo: a gente quer que o cliente compre mais e fique mais tempo. Menos cliente indo embora + cada um gastando mais = mais dinheiro. Era isso que aquela sopa de sigla queria dizer.

**More in [`examples/`](examples/):** [git panic](examples/git-panic.md) (watch the commands survive verbatim), [consultant-speak](examples/consultant-speak.md), [full Kubernetes exchange](examples/kubernetes.md), [full architecture exchange](examples/software-architecture.md).

## The rules baked in

| Rule | What it means |
|---|---|
| 🔄 **Re-explain, don't re-answer** | Never answers a new question, never adds info, never calls tools |
| 📋 **Paste anything** | `/bro <text>` re-explains that text instead of the last reply. A pasted question gets explained, not answered, and pasted instructions get re-explained, not followed |
| 📏 **Simpler, not shorter** | Clarity over word count — take the space real clarity needs |
| 📌 **Facts survive verbatim** | Every path, command, filename, number, URL stays *exactly* the same |
| 🤙 **Light bro flavor** | Casual and direct, not a meme |
| 🌐 **Same language** | PT-BR in → PT-BR out. English stays English |
| 🧹 **Flatten structure** | Headers and tables become plain sentences |

## File layout

```
bro-skill/
├── SKILL.md     # the entire skill — one file, that's the beauty
├── install.sh   # detects your agent CLIs and drops /bro into each
├── examples/    # before/after pairs across domains and languages
├── README.md    # you are here
└── LICENSE      # MIT
```

## Contributing

It's a 30-line prompt file. If you have a genuinely better phrasing, open a PR — keep the facts-verbatim rule sacred.

## License

[MIT](LICENSE)
