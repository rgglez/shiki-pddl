# shiki-pddl

[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
![GitHub all releases](https://img.shields.io/github/downloads/rgglez/shiki-pddl/total)
![GitHub issues](https://img.shields.io/github/issues/rgglez/shiki-pddl)
![GitHub commit activity](https://img.shields.io/github/commit-activity/y/rgglez/shiki-pddl)
![GitHub stars](https://img.shields.io/github/stars/rgglez/shiki-pddl?style=social)
![GitHub forks](https://img.shields.io/github/forks/rgglez/shiki-pddl?style=social)

**@rgglez/shiki-pddl** is a PDDL (Planning Domain Definition Language) TextMate
grammar for [Shiki](https://shiki.style/), [Expressive Code](https://expressive-code.com/)
and any Markdown / MDX pipeline that accepts a `LanguageRegistration`-shaped grammar
object.

Zero runtime dependencies. Ships the grammar JSON plus a typed ESM default export.

## Install

```bash
npm i @rgglez/shiki-pddl
# or
bun add @rgglez/shiki-pddl
# or
pnpm add @rgglez/shiki-pddl
```

## Usage

### Shiki

```ts
import { createHighlighter } from "shiki";
import pddl from "@rgglez/shiki-pddl";

const hl = await createHighlighter({
  themes: ["github-dark"],
  langs: [pddl],
});

const html = hl.codeToHtml(src, { lang: "pddl", theme: "github-dark" });
```

### Astro + `astro-expressive-code`

Works also with [**AstroPaper**](https://astro.build/themes/details/astropaper/),
since it uses expressive-code under the hood:

```ts
// astro.config.ts
import { defineConfig } from "astro/config";
import expressiveCode from "astro-expressive-code";
import pddl from "@rgglez/shiki-pddl";

export default defineConfig({
  integrations: [
    expressiveCode({
      themes: ["dracula", "github-light"],
      shiki: { langs: [pddl] },
    }),
  ],
});
```

Then in any `.md` / `.mdx`:

````md
```pddl
(define (domain blocksworld)
  (:requirements :strips)
  (:predicates (on ?x ?y) (clear ?x) (ontable ?x) (handempty))
  (:action stack
    :parameters (?x ?y)
    :precondition (and (clear ?y) (holding ?x))
    :effect (and (not (holding ?x)) (not (clear ?y))
                 (clear ?x) (handempty) (on ?x ?y))))
```
````

### Astro `markdown.shikiConfig`

```ts
import pddl from "@rgglez/shiki-pddl";

export default defineConfig({
  markdown: {
    shikiConfig: { langs: [pddl] },
  },
});
```

### Raw grammar (no JS wrapper)

If you want the JSON directly (for build tools, editors, etc.):

```ts
import grammar from "@rgglez/shiki-pddl/grammar.json";
```

## What gets highlighted

The grammar covers PDDL 3.1 (the variant used by IPC and most current planners), including:

- Section headers (`:requirements`, `:types`, `:predicates`, `:functions`, `:constants`, `:init`, `:goal`, `:metric`, …)
- Action / durative-action declarations (`:action`, `:durative-action`, `:parameters`, `:precondition`, `:effect`, `:condition`, `:duration`)
- Variables (`?x`, `?y`)
- Logical operators (`and`, `or`, `not`, `imply`, `forall`, `exists`, `when`)
- Numeric fluents and arithmetic
- Comments (`;`)
- Numbers and strings

## Release (Makefile)

Semver release flow via [`Makefile`](./Makefile). Requires `npm login`.

| Target           | Description                                                                  |
|------------------|------------------------------------------------------------------------------|
| `make help`      | List available targets.                                                      |
| `make latest-tag`| Print latest semver git tag (`vX.Y.Z`). Empty if none.                       |
| `make next-patch`| Print next patch tag without writing anything. Falls back to `v0.0.1`.       |
| `make tag-patch` | Bump `package.json` patch, commit, create git tag, and push (tree must be clean). |
| `make build`     | Build `dist/` via `tsup`.                                                    |
| `make publish`   | Build then `npm publish --access public` (scoped package).                   |
| `make release`   | Full flow: `tag-patch` + `publish`.                                          |
| `make clean`     | Remove `dist/`.                                                              |

## Maintenance

The grammar is adapted from [`jan-dolejsi/vscode-pddl`](https://github.com/jan-dolejsi/vscode-pddl).
Upstream may evolve over time; periodically diff `syntaxes/pddl.tmLanguage.json`
from the upstream repo against `src/pddl.tmLanguage.json` here and resync as
needed.

## Credits & License

- Original grammar: [Jan Dolejsi — vscode-pddl](https://github.com/jan-dolejsi/vscode-pddl) (MIT).
- This package: MIT, copyright © 2026 Rodolfo González González.

See [NOTICE](./NOTICE) for the full attribution and [LICENSE](./LICENSE) for the
MIT terms.
