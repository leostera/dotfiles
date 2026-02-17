-- LSP keybindings on attach
local on_attach = function(client, bufnr)
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
  vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set("n", "<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
  vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
  vim.keymap.set("n", "<leader>F", function()
    vim.lsp.buf.format({ async = true })
  end, bufopts)

  -- Format on save
  if client.server_capabilities.documentFormattingProvider then
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = vim.api.nvim_create_augroup("LspFormat", { clear = true }),
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format({ async = false })
      end,
    })
  end

  -- Enable inlay hints
  if client.server_capabilities.inlayHintProvider then
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  end
end

-- Use the modern vim.lsp.config API if available (nvim 0.11+), otherwise fall back to lspconfig
local has_modern_lsp = vim.fn.has("nvim-0.11") == 1 and vim.lsp.config ~= nil

if has_modern_lsp then
  -- Modern API (nvim 0.11+)
  vim.lsp.config("*", {
    on_attach = on_attach,
  })
  
  -- Configure rust_analyzer with inlay hints
  vim.lsp.config("rust_analyzer", {
    on_attach = on_attach,
    settings = {
      ["rust-analyzer"] = {
        inlayHints = {
          bindingModeHints = { enable = false },
          chainingHints = { enable = true },
          closingBraceHints = { enable = true, minLines = 25 },
          closureReturnTypeHints = { enable = "never" },
          lifetimeElisionHints = { enable = "never", useParameterNames = false },
          maxLength = 25,
          parameterHints = { enable = true },
          reborrowHints = { enable = "never" },
          renderColons = true,
          typeHints = {
            enable = true,
            hideClosureInitialization = false,
            hideNamedConstructor = false,
          },
        },
      },
    },
  })

  -- Ruff LSP (formatter/linter)
  vim.lsp.config("ruff", {
    cmd = { "uv", "tool", "run", "ruff", "server" },
  })

  -- Ty LSP (type checker)
  vim.lsp.config("ty", {
    cmd = { "uv", "tool", "run", "ty", "server" },
    settings = {
      ty = {},
    },
  })
  
  vim.lsp.enable("rust_analyzer")
  vim.lsp.enable("zls")
  vim.lsp.enable("ocamllsp")
  vim.lsp.enable("denols")
  vim.lsp.enable("elixirls")
  vim.lsp.enable("phpactor")
  vim.lsp.enable("lua_ls")
  vim.lsp.enable("ruff")
  vim.lsp.enable("ty")
  vim.lsp.enable("pyright")
else
  -- Legacy lspconfig approach (nvim < 0.11)
  local lspconfig = require("lspconfig")
  
  lspconfig.rust_analyzer.setup({
    on_attach = on_attach,
    settings = {
      ["rust-analyzer"] = {
        inlayHints = {
          bindingModeHints = { enable = false },
          chainingHints = { enable = true },
          closingBraceHints = { enable = true, minLines = 25 },
          closureReturnTypeHints = { enable = "never" },
          lifetimeElisionHints = { enable = "never", useParameterNames = false },
          maxLength = 25,
          parameterHints = { enable = true },
          reborrowHints = { enable = "never" },
          renderColons = true,
          typeHints = {
            enable = true,
            hideClosureInitialization = false,
            hideNamedConstructor = false,
          },
        },
      },
    },
  })
  lspconfig.zls.setup({ on_attach = on_attach })
  lspconfig.denolds.setup({ on_attach = on_attach, filetypes = { "typescript", "typescriptreact", "typescript.tsx" } })
  lspconfig.elixirls.setup({ on_attach = on_attach, cmd = { vim.fn.system("brew --prefix elixir-ls"):gsub("%s+$", "") .. "/bin/elixir-ls" } })
  lspconfig.ruff.setup({
    on_attach = on_attach,
    cmd = { "uv", "tool", "run", "ruff", "server" },
  })
  lspconfig.ty.setup({
    on_attach = on_attach,
    cmd = { "uv", "tool", "run", "ty", "server" },
    settings = { ty = {} },
  })
  lspconfig.pyright.setup({ on_attach = on_attach })
  
  lspconfig.lua_ls.setup({
    on_attach = on_attach,
    settings = {
      Lua = {
        diagnostics = { globals = { "vim" } },
        workspace = { library = vim.api.nvim_get_runtime_file("", true), checkThirdParty = false },
        telemetry = { enable = false },
      },
    },
  })
end

-- Enable inlay hints for Rust files
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.name == "rust_analyzer" then
      vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
    end
  end,
})

-- Zig-specific formatting and code actions
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.zig", "*.zon" },
  callback = function()
    vim.lsp.buf.format()
    vim.lsp.buf.code_action({
      context = { only = { "source.fixAll" } },
      apply = true,
    })
    vim.lsp.buf.code_action({
      context = { only = { "source.organizeImports" } },
      apply = true,
    })
  end,
})
