#!/usr/bin/env lua

-- Simple Pandoc JSON filter that uppercases all Str inlines
-- JSON dependency: dkjson
-- This filter expects the Lua JSON module "dkjson" to be available.
-- On macOS/Homebrew Lua, you can typically install it with:
--   brew install luarocks
--   luarocks install dkjson

local ok, json = pcall(require, "dkjson")
if not ok then
  io.stderr:write(
    "apex-filter-uppercase: missing Lua dependency 'dkjson'.\n",
    "Install it, for example:\n",
    "  brew install luarocks\n",
    "  luarocks install dkjson\n"
  )
  os.exit(1)
end

local function uppercase_str(node)
  if type(node) == "table" and node.t == "Str" and type(node.c) == "string" then
    node.c = string.upper(node.c)
  end
  return node
end

local function walk(x)
  if type(x) == "table" then
    -- element object?
    if x.t ~= nil then
      x = uppercase_str(x) or x
    end
    -- recurse into fields
    for k, v in pairs(x) do
      x[k] = walk(v)
    end
  elseif type(x) == "table" then
    for i, v in ipairs(x) do
      x[i] = walk(v)
    end
  end
  return x
end

-- Read full JSON document from stdin
local input = io.read("*a")
if not input or input == "" then
  os.exit(0)
end

local doc, pos, err = json.decode(input, 1, nil)
if err then
  io.stderr:write("uppercase.lua: JSON decode error: ", err, "\n")
  os.exit(1)
end

doc = walk(doc)

local out = json.encode(doc, { indent = false })
io.write(out)
io.output():flush()