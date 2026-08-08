pcall(function()
  dofile(vim.g.base46_cache .. "syntax")
  dofile(vim.g.base46_cache .. "treesitter")
end)

return {
  ensure_installed = {
    "lua",
    "luadoc",
    "printf",
    "vim",
    "vimdoc",
    "c",
    "cpp",
    "java",
    "rust",
    "go",
    "haskell",
    "javascript",
    "typescript",
    "tsx",
    "html",
    "css",
    "json",
    "jsonc",
    "yaml",
    "dockerfile",
    "gotmpl",
    "htmldjango",
    "jinja",
    "jinja_inline",
    "templ",
    "twig",
    "markdown",
    "markdown_inline",
    "xml",
    "sql",
    "zig",
  },
}
