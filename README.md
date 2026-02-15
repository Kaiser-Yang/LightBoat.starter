# LightBoat.starter

The starter for [LightBoat](https://github.com/Kaiser-Yang/LightBoat).

## Requirements

* `git`
* `curl`
* `unzip`
* `tar`
* `gzip`
* `tree-sitter`
## How to remove one plugin?

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

## How to add a new plugin?

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

## How to change the configuration of a plugin?

If the plugin is not installed by `LightBoat`,
you just need to create a new file `lua/plugin/<name>.lua`,
and the name can be any except `init`.
You just put your configuration in the `opts` field, and in most cases,
you need to see the repository page of the plugin to learn how to configure.

For example, i can create `lua/plugin/blink_cmp.lua`
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
