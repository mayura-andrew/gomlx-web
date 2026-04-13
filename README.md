# GoMLX Official Documentation Site

The official documentation website for [GoMLX](https://github.com/gomlx/gomlx) — an XLA-accelerated machine learning framework for Go.

Built with [Hugo](https://gohugo.io) and a custom theme. Docs content is automatically synced from the upstream `gomlx/gomlx` repository.

---

## Quick start

```bash
# 1. Clone this repo
git clone https://github.com/gomlx/gomlx-site
cd gomlx-site

# 2. Install Hugo (extended version required)
#    macOS:  brew install hugo
#    Linux:  snap install hugo --channel=extended
#    Win:    choco install hugo-extended

# 3. Pull the latest docs from the upstream repo
make sync

# 4. Start the local dev server
make dev
# → open http://localhost:1313
```

---

## How docs syncing works

The site does **not** store the documentation markdown directly. Instead, a sync script pulls the latest `.md` files from `github.com/gomlx/gomlx/docs/` and writes them into `content/docs/` with Hugo front matter automatically added.

```
gomlx/gomlx (upstream)
  └── docs/
      ├── context.md
      ├── graph.md
      ├── training.md
      └── ...
          │
          │  scripts/sync-docs.sh
          ▼
gomlx-site (this repo)
  └── content/docs/
      ├── context.md      ← front matter injected
      ├── graph.md
      ├── training.md
      └── overview.md     ← generated from root README
```

### Sync commands

```bash
# Sync from main branch (default)
make sync

# Sync from a specific release tag
make sync-tag TAG=v0.17.0

# Or run the script directly
./scripts/sync-docs.sh v0.17.0
```

### What the sync script does

1. Calls the GitHub API to list all `.md` files in `gomlx/gomlx/docs/`
2. Downloads each file with `curl`
3. Strips any leading `# Title` heading (Hugo renders the title itself)
4. Prepends Hugo front matter (`title`, `section`, `weight`, `source`)
5. Writes to `content/docs/<slug>.md`
6. Also pulls the root `README.md` and creates `content/docs/overview.md`

### Automatic sync (GitHub Actions)

A GitHub Actions workflow (`.github/workflows/sync-and-deploy.yml`) runs daily and on every push. It:

1. Syncs the latest docs from `gomlx/gomlx@main`
2. Commits any changed files back to this repo
3. Builds the Hugo site
4. Deploys to GitHub Pages

---

## Site structure

```
gomlx-site/
├── hugo.toml                   # site config
├── Makefile                    # dev commands
├── scripts/
│   └── sync-docs.sh            # upstream doc sync script
├── .github/workflows/
│   └── sync-and-deploy.yml     # CI/CD pipeline
├── content/
│   ├── _index.md               # homepage
│   ├── docs/                   # synced from upstream + hand-written
│   └── examples/               # example pages
├── data/
│   └── docsnav.yaml            # sidebar navigation order
└── themes/gomlx/
    ├── assets/css/
    │   ├── main.css            # design system
    │   └── docs.css            # three-column docs layout
    ├── assets/js/
    │   └── main.js             # theme toggle, tabs, copy, TOC scroll spy
    └── layouts/
        ├── index.html          # homepage template
        ├── _default/
        │   ├── baseof.html     # base shell
        │   └── single.html     # doc page (sidebar + content + TOC)
        ├── partials/           # homepage sections
        └── shortcodes/         # {{< callout >}}, {{< colab-badge >}}
```

---

## Customizing the sidebar order

The sidebar is driven by `data/docsnav.yaml`. Any synced page not listed there automatically appears under an "From upstream" section at the bottom.

To promote a synced page into the curated nav, add it to `data/docsnav.yaml`:

```yaml
- title: Reference
  pages:
    - name: Graph execution
      url: /docs/graph/          # matches the synced slug
    - name: Context & variables
      url: /docs/context/
```

---

## Contributing

This site is a community contribution to GoMLX. If you find a documentation error:

- **In a synced page** — open a PR on [gomlx/gomlx](https://github.com/gomlx/gomlx) (the sync will pick it up)
- **In a hand-written page or the site itself** — open a PR on this repo

Questions? Join `#gomlx` on the [Gophers Slack](https://gophers.slack.com).
