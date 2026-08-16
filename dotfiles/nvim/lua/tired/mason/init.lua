local M = {}
local masonames = require "tired.mason.names"
local pkgs = require("tiredconfig").mason.pkgs
local skipped = vim.deepcopy(require("tiredconfig").mason.skip)

-- LEENIX ownership reconciliation: LSPs/linters owned by LEENIX development
-- policy are Nix-installed. Mason must not install them again, so the
-- generated lua/leenix/mason-skip.lua (built from enabled development.lsp.* /
-- development.linters.* leaves) is merged into the explicit skip list.
local leenix_ok, leenix_skip = pcall(require, "leenix.mason-skip")
if leenix_ok and type(leenix_skip) == "table" and type(leenix_skip.skip) == "table" then
  vim.list_extend(skipped, leenix_skip.skip)
end

M.get_pkgs = function()
  local tools = {}

  local native_lsps = vim.tbl_keys(vim.lsp._enabled_configs or {})
  local lspconfig_lsps = require("lspconfig.util").available_servers()
  vim.list_extend(tools, lspconfig_lsps)
  vim.list_extend(tools, native_lsps)

  local conform_exists, conform = pcall(require, "conform")

  if conform_exists then
    for _, v in ipairs(conform.list_all_formatters()) do
      local fmts = vim.split(v.name:gsub(",", ""), "%s+")
      vim.list_extend(tools, fmts)
    end
  end

  -- nvim-lint
  local lint_exists, lint = pcall(require, "lint")

  if lint_exists then
    local linters = lint.linters_by_ft

    for _, v in pairs(linters) do
      vim.list_extend(tools, v)
    end
  end

  -- rm duplicates
  for _, v in pairs(tools) do
    if not vim.tbl_contains(pkgs, masonames[v]) and not vim.tbl_contains(skipped, masonames[v]) then
      table.insert(pkgs, masonames[v])
    end
  end

  return pkgs
end

local function parse_package(package_name)
  local name, version = package_name:match "^([^@]+)@?(.*)$"
  return {
    name = name,
    version = version ~= "" and version or nil,
  }
end

M.install_all = function()
  vim.cmd "Mason"

  local mr = require "mason-registry"

  mr.refresh(function()
    for _, tool in ipairs(M.get_pkgs()) do
      local pkg = parse_package(tool)
      local p = mr.get_package(pkg.name)

      if not p:is_installed() then
        p:install { version = pkg.version }
      end
    end
  end)
end

return M
