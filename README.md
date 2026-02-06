# Apex Uppercase Filter (Lua, Pandoc JSON)

This repository contains a simple **Lua-based AST filter** for
[Apex](https://github.com/ApexMarkdown/apex) that uppercases all plain text
(`Str` inlines) in the document.

It uses the same **Pandoc JSON filter** protocol described in the
[Pandoc filter documentation](https://pandoc.org/filters.html#summary), so it
can also be used directly with Pandoc.

## Installation (Apex)

You can install this filter automatically from the central filters directory:

```bash
apex --install-filter uppercase
```

This will clone the repository into your user filters directory:

- `$XOWNS_CONFIG_HOME/apex/filters/uppercase` or
- `~/.config/apex/filters/uppercase`

After installation, you can enable the filter with:

```bash
apex --filter uppercase input.md > output.html
```

You can also run the Lua script directly from anywhere using the `--lua-filter`
flag:

```bash
apex --lua-filter /path/to/uppercase.lua input.md > output.html
```

## Manual installation

If you prefer to install manually:

1. Ensure you have a Lua interpreter and the `dkjson` JSON library
   available. On macOS with Homebrew Lua, a typical setup is:

   ```bash
   brew install luarocks
   luarocks install dkjson
   ```
2. Copy `uppercase.lua` into your filters directory:

   ```bash
   mkdir -p ~/.config/apex/filters
   cp uppercase.lua ~/.config/apex/filters/uppercase
   chmod +x ~/.config/apex/filters/uppercase
   ```

3. Run Apex with the filter:

   ```bash
   apex --filter uppercase input.md > output.html
   ```

## Usage (Pandoc)

Because this is a standard Pandoc JSON filter, you can also use it with Pandoc:

```bash
pandoc input.md -t json \
  | lua uppercase.lua \
  | pandoc -f json -t html -o output.html
```

## How it works

The filter:

1. Reads the entire Pandoc JSON document from `stdin`.
2. Walks the `blocks` and `inlines`, looking for elements of the form:

   ```json
   { "t": "Str", "c": "some text" }
   ```

3. Replaces the `c` string with its `string.upper` equivalent.
4. Writes the modified JSON document to `stdout`.

