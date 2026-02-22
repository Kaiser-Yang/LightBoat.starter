# LightBoat.starter

The starter for [LightBoat](https://github.com/Kaiser-Yang/LightBoat).

## Requirements

For UNIX-like systems:

* `git`
* `curl`
* `unzip`
* `tar`
* `gzip`
* `tree-sitter`

## Quick Start

1. Clone the repository:

```bash
git clone https://github.com/Kaiser-Yang/LightBoat.starter.git ~/.config/light-boat
```

2. Run `nvim` to download the plugins.

```bash
NVIM_APPNAME=light-boat nvim
```

Or you can use the `Dockerfile` to build a docker image with everything set up:

```bash
docker build -t lightboat-starter .
docker run -it --rm lightboat-starter
nvim
```

These methods above will not break your own configuration.
If you want use this distro instead of your own configuration,
you just need to clone this repository into `~/.config/nvim`.
After this, every time you use `nvim` to start will use this distro.

We recommend you update the `origin` of the git repository to your own repository.
Therefore you can customise it and update easily.

```bash
git remote set-url origin <repo-url>
```

## FAQs

### How to install executables such as formatters, LSPs?

You just need configure `vim.g.lightboat_opt.mason_ensure_installed`,
then `LightBoat` will install them if they are not installed
(Requirements for `mason-org/mason.nvim` must be met).

By default, `LightBoat` will only install `stylua` and `lua-language-server`.

Or you can use `:Mason` to open the `mason-org/mason.nvim` menu to install one manually.
We recommend you to install by setting `vim.g.lightboat_opt.mason_ensure_installed`,
which will install them even if you switch a new machine.

**NOTE**: For LSPs, you still need to enable it by creating files,
see [Hot to enable a new LSP](#how-to-enable-a-new-lsp) to learn more.

### How to enable a new LSP?

In most cases, you just need to make sure your LSP command is installed
(you can install them with `vim.g.lightboat_opt.mason_ensure_installed` automatically).
Then you just need to create a file under `after/lsp/<name>.lua`.

And if you have `neovim/nvim-lspconfig` installed,
you should make sure the filename is same with the one in `neovim/nvim-lspconfig`.
You can make it an empty file, it's OK.
Because `nvim` will merge it with the one in `neovim/neovim-lspconfig`.

If you have disabled `neovim/neovim-lspconfig`,
you just need to copy a configuration file from the repository.

That's all, the LSPs defined under `after/lsp` will be enabled by `LightBoat` automatically.
And folders are supported too, which means you can defined multi LSPs in one fold.

### How to install treesitter parsers?

You just need configure `vim.g.lightboat_opt.treesitter_ensure_installed`,
then `LightBoat` will install them when they are not installed
(Requirements for `nvim-treesitter/nvim-treesitter` must be met).

By default, `LightBoat` will not install any parsers.
Don't worry,
parsers for `C`, `Lua`, `Markdown`, `Vimscript`, `Vimdoc` and `Treesitter query files`
are included by `nvim`.

Or you can use `:TSInstall <name>` to install the parser for your language.
We recommend you to install by setting `vim.g.lightboat_opt.treesitter_ensure_installed`,
which will install them even if you switch a new machine.

### How to update?

`LightBoat` is now on rapid development, I am still trying improve this distro.
Therefore, there maybe some new features added to this starter directly.
You can create a new git remote named `upstream` and update the starter by merging:

```bash
git remote add upstream https://github.com/Kaiser-Yang/LightBoat.starter.git
git fetch upstream
git merge upstream/master
```
You may need to resolve conflicts if there are.

If you want to update plugins:

1. Run `nvim` to start up `nvim`.
2. Run `:Lazy` in `nvim` to open the plugin manager window.
3. Press `U` to update all plugins.

### How to customise key mappings?

Most key mappings are placed in `lua/plugin/maplayer.lua`
you just change the this file to customise key mappings.

Some buffer level key mappings are placed in the related plugin files.
For example,
`nvim-telescope/telescope.nvim` related key mappings are placed in `lua/plugin/telescope.lua`

### How to remove plugins?

For example, if you want to remove `neovim/nvim-lspconfig`,
you just need to create a file `lua/plugin/<name>.lua` with the following content:

```lua
return {
  "neovim/nvim-lspconfig",
  enabled = false,
}
```

The filename can be any one except `init`.
We recommend you to name it with the plugin's name for better readability.

### How to add new plugins?

You just need to create a new file `lua/plugin/<name>.lua`,
and the name can be any one except `init`.

And add the plugin into the file with `return` statement, you can see `lua/plugin/colorscheme.lua`
for an example. Actually, you can return an array of plugins in the `return` statement,
which means those below are OK:

```lua
return {
  {
    -- plugin A goes here
  },
  {
    -- plugin B goes here
  },
  -- Maybe there are some more
}
```

This is helpful for you to manage a bunch of related plugins.

### How to change the configuration of plugins?

For example, I can create a file named `lua/plugin/blink_cmp.lua`
and add those below to disable documentation auto show:

```lua
return {
  'saghen/blink.cmp',
  opts = {
    completion = { documentation = { auto_show = false } }
  }
}
```

**NOTE**: All your configuration will override the old ones,
which means if the old field is an array for which configuration will be replaced wholly.

### Why does my code not formatted after saving?

The main reason for this is that you do not have a formatter available for current buffer
(You will see the message reporting it).
You can run `:ConformInfo` to check if there is a formatter available for the buffer.

And if you want to add a new formatter for a filetype, you can follow up those below:

* Install a formatter, you can do this manually or use `vim.g.lightboat_opt.mason_ensure_installed` to install automatically.
* Configure the formatter for your filetype for `stevearc/conform.nvim`, for example:

```lua
-- In "lua/plugin/conform.lua"
return {
  'stevearc/conform.nvim',
  opts = {
    formatters_by_ft = { go = { 'goimports' } },
  },
}
```

By default, `LightBoat` only configures `stylua` for `lua` files.

## Plugins

### `folke/lazy.nvim.git`

Requirements:

* `git`

This is the plugin manager for `LightBoat`.

Known issues:

* [Weird border behavior when `vim.o.border` is set](https://github.com/folke/lazy.nvim/pull/2072)

### `neovim/nvim-lspconfig`

As to `nvim 0.11`,
this plugin only provides the default configuration for LSP servers
and some commands to control LSP clients.

This plugin can be removed as to `nvim 0.12`,
because `nvim 0.12` will have built-in `lsp start`, `lsp stop` and `lsp restart` commands
to control the LSP clients.
And you can just copy a few LSP configuration files you used to `after/lsp/`
(you can remain file names) from this plugin's repository,
after which you can remove this plugin.

The URL for LSP configuration files:
[neovim/nvim-lspconfig](https://github.com/neovim/nvim-lspconfig/tree/master/lsp).

### `mason-org/mason.nvim`

Requirements:

UNIX-like systems:

* `git`
* `curl` or `wget`
* `unzip`
* `tar` or `gtar`
* `gzip`

Windows:

* `pwsh` or `powershell`
* `git`
* `tar`
* One of the following:
  * `7zip`
  * `peazip`
  * `archiver`
  * `winzip`
  * `WinRAR`

This is a plugin to install LSPs, linters, formatters and DAPs,
which make it easy to install executables.
This plugin can be removed if you prefer installing executables manually.

### `saghen/blink.cmp`

Requirements:

* `curl` (optional)
* `git` (optional)

As to `nvim 0.11`, `nvim` has a built-in completion menu,
but it can not satisfy the needs of most users:

* The built-in completion menu will not show the completion items when you type some characters, and you need to press `<C-X><C-O>` to trigger the completion menu. Even if you have use `vim.lsp.completion.enable` to enable the auto completion, it will only show the menu after you type triggers such as `.`.
* It seems to be difficult to add some completion sources to the built-in completion menu.

`blink.cmp` provides a more powerful completion menu,
those below are some features that can not be achieved by the built-in completion menu:

* `path`, `buffer`, `snippets` and `cmdline` completion sources.
* Automatically load the `rafamadriz/friendly-snippets` into `vim.snippet` module when available.
* You can trigger the completion menu by just typing some characters (not only triggers).
* Fuzzy matching and sorting make it possible to use `bn` find the completion item `buffer_name`.
* The community has created many extensions for `blink.cmp` to support more completion sources.
* Documentation in insert mode.

**NOTE**: We notice that `nvim 0.12` may support ability
to add some completion sources to the built-in completion menu, see
[completion: plugins can define completion sources](https://github.com/neovim/neovim/issues/32123)

We provide those default key mappings for this plugin,
you can configure the in `lua/plugin/maplayer.lua`

| Key          | Function                        |
|--------------|---------------------------------|
| `<C-J>`      | Select Next Completion Item     |
| `<C-K>`      | Select Previous Completion Item |
| `<Tab>`      | Snippet Forward                 |
| `<S-Tab>`    | Snippet Backward                |
| `<C-X>`      | Show Completion                 |
| `<C-Y>`      | Accept Completion Item          |
| `<C-E>`      | Cancel Completion               |
| `<C-U>`      | Scroll Documentation Up         |
| `<C-U>`      | Scroll Signature Up             |
| `<C-D>`      | Scroll Documentation Down       |
| `<C-D>`      | Scroll Signature Down           |
| `<C-S>`      | Toggle Signature                |

Those plugin will install some useful sources and snippets:

* `rafamadriz/friendly-snippets`: This plugin provides a lot of snippets for many languages.
* `Kaiser-Yang/blink-cmp-dictionary`: dictionary source, we have provide an English dictionary file.
* `mikavilpas/blink-ripgrep.nvim` (When `rg` is executable): will be enabled when in a git repository.

**NOTE**: Snippets are something that you can insert into your code by just typing some triggers.

Known issues:

* [scroll functions always return true](https://github.com/saghen/blink.cmp/issues/2381)

### `mikavilpas/blink.pairs`, `altermo/ultimate-autopair.nvim` and `abecodes/tabout.nvim`

Those three plugins provide the abilities related with pairs.
At first, I only use `altermo/ultimate-autopair.nvim`,
but I find there are some performance problems,
especially when I hold the space key or backspace key in a pair.
Then I switch to `mikavilpas/blink.pairs`,
but in this plugin fly mode is not implemented yet.
Therefore I use these two together by only mapping right brackets and enter for
`mikavilpas/blink.pairs` others for `altermo/ultimate-autopair.nvim`.

`altermo/ultimate-autopair.nvim` provides tab out, but we can not do reverse tab out.
Therefore I added `abecodes/tabout.nvim`.

You do not need to care about it, `LightBoat` has hidden the implementations.

**NOTE**: Fly mode makes you can fly over pairs, for example, in `([{|}])`
(`|` is your cursor position), you can press `)` to get `([{}])|`.

**NOTE**: Tab out makes you can jump over some information in a pair, for example,
in `test(|param1)`, you can press `<Tab>` to get `test(param1|)`,
press `<Tab>` again, you will get `test(param1)|`.

We provide those mappings by default, you can configure them in `lua/plugin/maplayer.lua`:

| Key          | Function |
|--------------|----------|
| `(`          | Autopair |
| `)`          | Autopair |
| `[`          | Autopair |
| `]`          | Autopair |
| `{`          | Autopair |
| `}`          | Autopair |
| `<`          | Autopair |
| `>`          | Autopair |
| `!`          | Autopair |
| `-`          | Autopair |
| `_`          | Autopair |
| `*`          | Autopair |
| `$`          | Autopair |
| `"`          | Autopair |
| `'`          | Autopair |
| `` ` ``      | Autopair |
| `<BS>`       | Delete Pair |
| `<Space>`    | Add Space in Pair |
| `<M-e>`      | Fastwarp      |
| `<M-E>`      | Reverse Fastwarp |
| `<M-s>`      | Auto Close Unclosed Pairs |
| `<CR>`       | Autopair CR            |
| `<Tab>`      | Tabout        |
| `<S-Tab>`    | Reverse Tabout |

**NOTE**: Fart wrap is something that can move contents after a pair into the pair,
for example, in `(|)a`, if you press `<M-e>`, you will get `(a|)`.
Reverse fast wrap will do this reversely, from `(a|)` to `(|)a`.

**NOTE**: We only mappings them in insert mode.
If you want use them in command mode,
you just need to update the `mode = 'i'` to `mode = 'ic'` of these mappings.

### `mikavilpas/blink.indent`

This is a indent line plugin, give you guide for indent lines.
We choose this one is because that it can be used even in very large files.

We provide those mappings, you can configure them in `lua/plugin/maplayer.lua`

| Key             | Function       |
|-----------------|----------------|
| `[\|`            | Indent Start   |
| `]\|`            | Indent End     |
| `i\|`            | Inside Indent Line |
| `a\|`            | Around Indent Line |
| `<leader>tI`    | Toggle Indent Line |

### `lewis6991/gitsigns.nvim`

Requirements:

* `git` (used to get the status of files)

This plugin provides some git related signs in the sign column,
and some commands to control those signs and do some git related operations.

We provide those key mappings, you can configure them in `lua/plugin/git_signs.lua`:

| Key           | Function                     |
|---------------|----------------------------  |
| `[g`          | Previous Git Hunk            |
| `]g`          | Next Git Hunk                |
| `ah`          | Select Git Hunk              |
| `ih`          | Select Git Hunk              |
| `<leader>ga`  | Git Add                      |
| `<leader>gr`  | Git Reset                    |
| `<leader>gA`  | Git Add Buffer               |
| `<leader>gu`  | Undo Add Hunk                |
| `<leader>gU`  | Undo Add Buffer              |
| `<leader>gr`  | Reset Hunk                   |
| `<leader>gR`  | Reset Buffer                 |
| `<leader>gd`  | Diff Hunk                    |
| `<leader>gD`  | Diff Inline                  |
| `<leader>gt`  | Diff This                    |
| `<leader>gb`  | Blame Line                   |
| `<leader>gq`  | Quickfix All Hunk            |
| `<leader>tgb` | Toggle Blame Current Line    |
| `<leader>tgw` | Toggle Word Diff             |
| `<leader>tgs` | Toggle Sign                  |
| `<leader>tgn` | Toggle Line Number Highlight |
| `<leader>tgl` | Toggle Line Highlight        |
| `<leader>tgd` | Toggle Deleted               |

**Skill**: Some operation can be repeated by `.`,
for example, if you do `<leader>ga` in a hunk,
you can repeat it by press `.` on another hunk.

### `spacedentist/resolve.nvim`

Requirements:

* `delta` (optional, used for diff view)

This plugin provides some commands to resolve git conflicts.
And when `delta` is installed, it can also provide some commands to show diff view of conflicts.

To enable the conflict diff view
you need to have `delta` installed and set your conflict style to `diff3`,
You can add those contents below to your `~/.gitconfig`:

```gitconfig
[core]
    pager = delta
[interactive]
    diffFilter = delta --color-only
[delta]
    navigate = true  # use n and N to move between diff sections
    dark = true      # or light = true, or omit for auto-detection
[merge]
    conflictStyle = zdiff3
```

We provide those key mappings below, you can configure them in `lua/plugin/resolve.lua`:

| Key                 | Function                  |
|---------------------|--------------------------|
| `[x`                | Previous Conflict        |
| `]x`                | Next Conflict            |
| `<leader>xc`        | Choose Current           |
| `<leader>xi`        | Choose Incoming          |
| `<leader>xb`        | Choose Both              |
| `<leader>xB`        | Choose Both Reverse      |
| `<leader>xn`        | Choose None              |
| `<leader>xa`        | Choose Ancestor          |
| `<leader>xdi`*      | Show Incoming            |
| `<leader>xdc`*      | Show Current             |
| `<leader>xdb`*      | Show Both                |
| `<leader>xdv`*      | Show Current V.S. Incoming |
| `<leader>xdV`*      | Show Incoming V.S. Current |

\* Only available if `delta` executable is present.

### `NMAC427/guess-indent.nvim`

This plugin is used to automatically detect the indentation of the current buffer
and set some options such as `shiftwidth`, `tabstop` and `expandtab` accordingly.

### `Kaiser-Yang/maplayer.nvim`

This plugin is a global key mapping manager,
it makes it easies to bind the same key with different functionalities.

### `nvim-treesitter/nvim-treesitter`

Requirements:

* `curl`
* `tar`
* `tree-sitter`

This plugin provides some query files for `nvim` treesitter, and some commands to install, update
and remove treesitter parsers. Furthermore,
it also provides treesitter based indentation and folding.

This plugin requires `tree-sitter` (the executable), `tar` and `curl`
to install and update treesitter parsers.

### `nvim-treesitter/nvim-treesitter-context`

This plugin just provides a window at the top of the buffer
to show the context of the current position.
To make it work, you need have a treesitter parser for the filetype of the current buffer.
A treesitter parser can be easily installed by `:TSInstall <name>`
command provided by `nvim-treesitter/nvim-treesitter` plugin.

### `ellisonleao/gruvbox.nvim`

The default color scheme for `LightBoat`. You can change it to any one you like.
See `lua/plugin/colorscheme.lua` to learn how to find a color scheme.

### `Kaiser-Yang/repmove.nvim`

This plugin makes it possible to use `;` and `,` to repeat the last motion you have done.
For example, if you press `]s` to go to next misspelled word,
you can use `;` to go tot the next one, `,` to go to the previous one.

### `MunifTanjim/nui.nvim`

We use this plugin to hack `vim.ui.input` and `vim.ui.select`.

### Others

Those below are dependencies by some plugins, we do not recommend you to disable them:

* `saghen/blink.download`
* `plenary.nvim`
* `nvim-web-devicons`

## Skills

### Markdown Quick Insert

`LightBoat` defined those quick insert aliases for markdown files (they behave like abbreviations):

| Alias | Result |
| ----- | ------ |
| `,1` | `# ` |
| `,2` | `## ` |
| `,3` | `### ` |
| `,4` | `#### ` |

<!-- TODO: Finish the table and add some usage examples -->
<!-- Usage: -->
<!-- Input ",t" in insert mode of a markdown file, the content will be "`|`<++>" ("|" is the cursor position) -->
<!-- and you can type the content of code and then press ",f" to jump to "<++>" and delete it -->
<!-- Example: -->
<!-- Input ",t": `|`<++> -->
<!-- After typing "print('hello world')": `print('hello world')|`<++> -->
<!-- After pressing ",f": `print('hello world')|` -->

### Motion & Text Object

Motion can make you move forward/backward to some specific positions in the buffer.
All motions can be repeated by `;` and `,`.
Motion can also be used in visual mode and operator-pending mode for quick selection,
yanking, deleting or changing.

Text object are used like `aw` (a word),
`iw` (inner word), `as` (a sentence), `is` (inner sentence) and so on.
With text objects,
you can do some things like `das` (delete a sentence), `yis` (yank inner sentence) and so on.
And it is worth noting that
all text objects used in operator-pending mode will make the whole operation repeatable by `.`.

`LightBoat` defined those key bindings for motion and text object:

<!-- TODO: Finish the table -->

### Swap

With `nvim-treesitter-textobjects`, it is easy to swap some `treesitter` nodes.

Those key bindings are defined for swapping:

<!-- TODO: Finish the table-->

### Surround

`nvim-surround` defined those aliases for the surround objects:

```lua
opts.aliases = {
  ["a"] = ">",
  ["b"] = ")",
  ["B"] = "}",
  ["r"] = "]",
  ["q"] = { '"', "'", "`" },
  ["s"] = { "}", "]", ")", ">", '"', "'", "`" },
},
```

With the default key bindings of `LightBoat`, you can do some things like:

<!-- TODO: Add examples -->

### Git Master

<!-- TODO: -->

