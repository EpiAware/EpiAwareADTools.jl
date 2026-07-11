# [Customising your docs](@id customising)

`scaffold` seeds a starting set of docs source pages for `EpiAwareADTools`
once; after that they belong to `EpiAwareADTools`, not to the kit.
This page explains which files are yours to rewrite and where to start.

## What's package-owned here

`update` never rewrites these, no matter how many times it runs:

- `getting-started/index.md` — the quickstart a new user lands on
  first.
- `getting-started/infrastructure.md` and any further page added under
  `docs/src/` (the Tools pages included).
- `docs/pages.jl` — the navigation tree; add, remove, or reorder
  entries freely.
- The README body (only the badge block between the managed markers is
  rewritten on sync; everything else is package-owned).

See [Infrastructure and template sync](@ref infrastructure) for the
full managed-versus-package-owned breakdown.

## Making it your own

- When a workaround is deleted because its upstream fix landed, remove
  the matching Tools page and its entry in [Charter and status](@ref
  charter).
- Add a new Tools page under `docs/src/tools/` when a new AD workaround
  moves in, then list it in `docs/pages.jl`.
- Reorder or rename any `Getting started` entry; `pages.jl` is read
  fresh on every `docs/make.jl` run, so there is no drift to fight.
- Keep or delete this page once it has served its purpose — it is
  package-owned like the rest of `getting-started/`.

## What stays managed

- `docs/make.jl`, the thin caller into the kit's build logic.
- The VitePress theme, config, and components under
  `docs/src/.vitepress/` and `docs/src/components/`.
- The API reference pages, generated fresh from `EpiAwareADTools`'s
  docstrings on every build rather than stored as source.

Editing a managed file directly works until the next `update` or
template-sync run reverts it — put customisation in the package-owned
files above instead.
