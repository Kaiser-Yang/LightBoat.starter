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

## How to remove plugins?

For example, if you want to remove `neovim/nvim-lspconfig`,
you just need to create a file `lua/plugin/<name>.lua` with the following content:

```lua
return {
  "neovim/nvim-lspconfig",
  enabled = false,
}
```

The filename can be any one except `init`.
We recommend you to name it with the plugin name for better readability.

## How to add new plugins?

You just need to create a new file `lua/plugin/<name>.lua`,
and the name can be any one except `init`.

And add the plugin into the file with `return` statement, you can see `lua/plugin/colorscheme.lua`
for a example. Actually, you can return an array of plugins in the `return` statement,
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

## How to change the configuration of plugins?

For example, I can create `lua/plugin/blink_cmp.lua`
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
which means if the old field is an array for which configure will be replaced wholely.

## How to install executables such as formatters, LSPs?

You just need configure `vim.g.lightboat_opt.mason_ensure_installed`,
then `LightBoat` will install them when they are not installed
(`mason-org/mason.nvim` must be installed first).

By default, `LightBoat` will only install `stylua` and `lua-language-server`.

Or you can use `:Mason` to open the `mason-org/mason.nvim` menu to install one manually.
We recommend you to install by setting `vim.g.lightboat_opt.mason_ensure_installed`,
which will install them even if you switch a new machine.

## How to install treesitter parsers?

You just need configure `vim.g.lightboat_opt.treesitter_ensure_installed`,
then `LightBoat` will install them when they are not installed
(`nvim-treesitter/nvim-treesitter` must be installed first).

By default, `LightBoat` will only install `lua` treesitter parser.

Or you can use `:TSInstall <name>` to install the parser for your language.
We recommend you to install by setting `vim.g.lightboat_opt.treesitter_ensure_installed`,
which will install them even if you switch a new machine.

## Why does my code not formatted after saving?

The main reason for this is that you do not have a formmatter available for current buffer.
You can run `:ConformInfo` to check if there is a formmatter available for the buffer.

And if you want to add a new formatter for a filetype, you can follow up those below:

* Install a formatter, you can do this manually or use `vim.g.lightboat_opt.mason_ensure_installed`
to install automatically.
* Configure the formatter for your filetype in `stevearc/conform.nvim`, for example:

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

## How to enable a nwe LSP?

In most case, you just need to make sure your LSP command is installed
(you can install them with `vim.g.lightboat_opt.mason_ensure_installed` automatically).
Then you just create a file under `after/lsp/<name>.lua`.
And if you have `neovim/nvim-lspconfig` installed,
you should make sure the filename is same with the one in `neovim/nvim-lspconfig`.
You can make it an empty file, it's OK.
Because neovim will merge it with the one in `neovim/neovim-lspconfig`

If you have disabled `neovim/neovim-lspconfig`,
you just need to copy a configuration file from the repository.

That's all, the LSPs defined under `after/lsp` will be enabled by `LightBoat` automatically.
And folders are supported too, which means you can defined multi LSPs in one same fold.

## Plugins

### `folke/lazy.nvim.git`

Requirements:

* `git`

This is the plugin manager for `LightBoat`.

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

* `path`, `buffer` and `cmdline` completion sources.
* Automatically load the `friendly-snippets` into `vim.snippet` module when available.
* You can trigger the completion menu by just typing some characters (not only triggers such as `.`).
* Fuzzy matching and sorting make it possible to use `bn` find the completion item `buffer_name`.
* The community has created many extensions for `blink.cmp` to support more completion sources.
* Documentation in insert mode.

**NOTE**: We notice that `nvim 0.12` may support ability
to add some completion sources to the built-in completion menu, see
[completion: plugins can define completion sources](https://github.com/neovim/neovim/issues/32123)

We provide those default key mappings for this plugin,
you can configure the in `lua/plugin/maplayer.lua`


Known issues:

* [scroll functions always return true](https://github.com/saghen/blink.cmp/issues/2381)

### `lewis6991/gitsigns.nvim`

Requirements:

* `git` (used to get the status of files)

This plugin provides some git related signs in the sign column,
and some commands to control those signs and do some git related operations.
### `/resolve.nvim`

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


### `NMAC427/guess-indent.nvim`

This plugin is used to automatically detect the indentation of the current buffer
and set some options such as `shiftwidth`, `tabstop` and `expandtab` accordingly.

### `Kaiser-Yang/maplayer.nvim`

This plugin is a global key mapping manager,
it makes it easies to bind the same key with different functionalities.

### `nvim-treesitter/nvim-treesitter`

Requirements:

* `curl` (used to download packages)
* `tar` (used to unpack packages)
* `tree-sitter` (used to generate a parser)

`indentexpr`

This plugin provides some query files for nvim treesitter, and some commands to install, update
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

## Requirements

- `rg`
- `curl`
- `unzip`
- `make`
- `npm`
- `node`
- `pngpaste`: `macOS` only, for image pasting in markdown files
- `xclip` or `wl-paste`: `Linux` only, for image pasting in markdown files

## Java Development

- `java`
- `python3`

Executables which may be installed automatically by `mason.nvim`:

- `google-java-format`: when `java` and `python3` are executable, this will be installed automatically
- `java-debug-adapter`: when `java`, `python3`, and `unzip` are executable, this will be installed automatically
- `java-test`: when `java`, `python3`, and `unzip` are executable, this will be installed automatically
- `jdtls`: when `java` and `python3` are executable, this will be installed automatically

## Shell Scripting

Executables which may be installed automatically by `mason.nvim`:

- `shellcheck`: when `bash` is executable, this will be installed automatically
- `bash-language-server`: when `bash` and `npm` are executable, this will be installed automatically

## Lua Development

Executables which may be installed automatically by `mason.nvim`:

- `lua-language-server`: this will be installed automatically
- `stylua`: when `unzip` is executable, this will be installed automatically

## C/C++ Development

Executables which may be installed automatically by `mason.nvim`:

- `bazelrc-lsp`: when `bazel` is executable, this will be installed automatically
- `buildifier`: when `bazel` is executable, this will be installed automatically
- `clangd`: when `unzip` is executable, this will be installed automatically
- `codelldb`: when `unzip` is executable, this will be installed automatically
- `neocmakelsp`: when `cmake` is executable, this will be installed automatically
- `clang-format`: when `python3` is executable, this will be installed automatically

## Go Development

- `go`

Executables which may be installed automatically by `mason.nvim`:

- `gopls`: when `go` is executable, this will be installed automatically
- `goimports`: when `go` is executable, this will be installed automatically

## Python Development

- `python3`

Executables which may be installed automatically by `mason.nvim`:

- `pyright`: when `python3` and `npm` are executable, this will be installed automatically
- `autopep8`: when `python3` is executable, this will be installed automatically

## Others

Executables which may be installed automatically by `mason.nvim`:

- `eslint-lsp`: when `npm` is executable, this will be installed automatically
- `json-lsp`: when `npm` is executable, this will be installed automatically
- `typescript-language-server`: when `npm` is executable, this will be installed automatically
- `prettier`: when `npm` is executable, this will be installed automatically
- `yaml-language-server`: when `npm` is executable, this will be installed automatically
- `tailwindcss-language-server`: when `npm` is executable, this will be installed automatically
- `vue-language-server`: when `npm` is executable, this will be installed automatically
- `lemminx`: when `unzip` is executable, this will be installed automatically
- `markdown-oxide`: this will be installed automatically

---

You may not want to install all of the above executables.
You can configure `vim.g.lightboat_opts.mason.ensure_installed` in
[lua/core/lazy.lua](https://github.com/Kaiser-Yang/LightBoat.starter/blob/master/lua/core/lazy.lua#L16)
to disable some of them.

For example, You can use those below to not install some executables:

```lua
vim.g.lightboat_opts = {
  mason = {
    ensure_installed = {
      ['lemminx'] = false,
      ['json-lsp'] = false,
      ['eslint-lsp'] = false,
      ['vue-language-server'] = false,
      ['yaml-language-server'] = false,
      ['typescript-language-server'] = false,
    }
  }
}
```

# Quick Start

1. Backup your old configuration:

```bash
# run in bash
mv ~/.config/nvim{,.bak}
mv ~/.local/share/nvim{,.bak}
mv ~/.local/state/nvim{,.bak}
mv ~/.cache/nvim{,.bak}
```

2. Clone the repository:

```bash
git clone https://github.com/Kaiser-Yang/LightBoat.starter.git ~/.config/nvim
```

3. Run `nvim` to download the plugins.

4. You can remove the `.git` directory in the repository so that you can create your own
   git repository.

**NOTE**: When running `nvim` at the first time, you may encounter many errors. You just
need to restart `nvim` many times, and wait for the plugins intallation.

Or you can use the `Dockerfile` to build a docker image with everything set up:

```bash
docker build -t lightboat-starter .
docker run -it --rm lightboat-starter
nvim
```

**NOTE**: The first time you run `nvim`, it will download the plugins. When all plugins are downloaded, you should restart `nvim`.

**NOTE**: `Mason` may not install executables automatically, and you just need to restart `nvim` and run `:Mason` in `nvim`.

Check [LightBoat](https://github.com/Kaiser-Yang/LightBoat) to learn how to customize.
