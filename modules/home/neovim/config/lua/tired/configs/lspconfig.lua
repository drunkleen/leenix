local M = {}
local map = vim.keymap.set

-- export on_attach & capabilities
M.on_attach = function(_, bufnr)
  local function opts(desc)
    return { buffer = bufnr, desc = "LSP " .. desc }
  end

  map("n", "gD", vim.lsp.buf.declaration, opts "Go to declaration")
  map("n", "gd", vim.lsp.buf.definition, opts "Go to definition")
  map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts "Add workspace folder")
  map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts "Remove workspace folder")

  map("n", "<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, opts "List workspace folders")

  map("n", "<leader>D", vim.lsp.buf.type_definition, opts "Go to type definition")
  map("n", "<leader>ra", require "tired.lsp.renamer", opts "TiredRenamer")
end

-- disable semanticTokens
M.on_init = function(client, _)
  if vim.fn.has "nvim-0.11" ~= 1 then
    if client.supports_method "textDocument/semanticTokens" then
      client.server_capabilities.semanticTokensProvider = nil
    end
  else
    if client:supports_method "textDocument/semanticTokens" then
      client.server_capabilities.semanticTokensProvider = nil
    end
  end
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()

M.capabilities.textDocument.completion.completionItem = {
  documentationFormat = { "markdown", "plaintext" },
  snippetSupport = true,
  preselectSupport = true,
  insertReplaceSupport = true,
  labelDetailsSupport = true,
  deprecatedSupport = true,
  commitCharactersSupport = true,
  tagSupport = { valueSet = { 1 } },
  resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  },
}

M.defaults = function()
  dofile(vim.g.base46_cache .. "lsp")
  require("tired.lsp").diagnostic_config()

  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      M.on_attach(_, args.buf)
    end,
  })

  local lua_lsp_settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      diagnostics = { globals = { "vim" } },
      workspace = {
        library = {
          vim.fn.expand "$VIMRUNTIME/lua",
          "${3rd}/luv/library",
        },
      },
    },
  }

  local function enable(server, opts)
    opts = vim.tbl_deep_extend("force", {
      capabilities = M.capabilities,
      on_init = M.on_init,
    }, opts or {})

    vim.lsp.config(server, opts)
    vim.lsp.enable(server)
  end

  -- Use new vim.lsp.config API for Neovim 0.11+
  enable("lua_ls", { settings = lua_lsp_settings })
  enable("rust_analyzer", {
    settings = {
      ["rust-analyzer"] = {
        cargo = { allFeatures = true },
        checkOnSave = { command = "clippy" },
      },
    },
  })
  enable("gopls", {
    settings = {
      gopls = {
        staticcheck = true,
        analyses = {
          unusedparams = true,
          unreachable = true,
        },
      },
    },
  })
  enable("html", {
    filetypes = { "html", "templ", "htmldjango", "gohtml", "gohtmltmpl" },
  })
  -- Template and HTML-family servers are split so each filetype gets a sane default.
  enable("htmx")
  enable("jinja_lsp", {
    filetypes = { "jinja" },
  })
  enable("templ", {
    filetypes = { "templ" },
  })
  enable("cssls")
  enable("ts_ls")
  enable("jsonls", { filetypes = { "json", "jsonc" } })
  enable("yamlls", { filetypes = { "yaml", "yml" } })
  enable("dockerls")
  enable("docker_compose_language_service", {
    filetypes = { "yaml.docker-compose" },
  })
  enable("pyright", {
    settings = {
      pyright = { disableOrganizeImports = false },
      python = {
        analysis = {
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
          typeCheckingMode = "basic",
        },
      },
    },
  })
  enable("jdtls")
  enable("clangd")
  enable("hls")
  enable("marksman")
  enable("lemminx")
  enable("zls")
  enable("sqls")
end

return M
