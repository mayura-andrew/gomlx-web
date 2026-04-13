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

## Contributing

This site is a community contribution to GoMLX. If you find a documentation error:

- **In a synced page** — open a PR on [gomlx/gomlx](https://github.com/gomlx/gomlx) (the sync will pick it up)
- **In a hand-written page or the site itself** — open a PR on this repo

