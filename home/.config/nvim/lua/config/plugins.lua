return {
  -- Comments
  { "tpope/vim-commentary" },

  -- FZF fuzzy finder
  {
    "junegunn/fzf",
    build = "./install --all",
  },
  { "junegunn/fzf.vim" },

  -- Status line
  { "itchyny/lightline.vim" },

  -- Zen mode
  { "junegunn/goyo.vim" },

  -- Git integration
  { "tpope/vim-fugitive" },
  { "airblade/vim-gitgutter" },

  -- Editing enhancements
  { "tpope/vim-surround" },

  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("config.lsp")
    end,
  },

  -- Mason for LSP server management
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          -- rust_analyzer is managed by rustaceanvim
          "lua_ls",
          "elixirls",
          "denols",
          "zls",
        },
        automatic_installation = true,
        handlers = {
          -- Default handler for all servers
          function(server_name)
            require("lspconfig")[server_name].setup({})
          end,
          -- Disable rust_analyzer - managed by rustaceanvim
          ["rust_analyzer"] = function() end,
        },
      })
    end,
  },

  -- Rust tools
  {
    "mrcjkb/rustaceanvim",
    version = "^5",
    lazy = false,
    ft = "rust",
    init = function()
      -- Get the on_attach function from lsp config
      local on_attach = function(client, bufnr)
        local bufopts = { noremap = true, silent = true, buffer = bufnr }
        
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
        vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
        vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, bufopts)
        vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
        vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, bufopts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
        vim.keymap.set("n", "<leader>F", function()
          vim.lsp.buf.format({ async = true })
        end, bufopts)
      end

      vim.g.rustaceanvim = {
        server = {
          on_attach = on_attach,
          settings = {
            ["rust-analyzer"] = {
              check = {
                command = "clippy",
              },
            },
          },
        },
      }
    end,
  },

  -- Treesitter for syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "lua",
          "vim",
          "vimdoc",
          "rust",
          "elixir",
          "erlang",
          "ocaml",
          "ocaml_interface",
          "typescript",
          "javascript",
          "html",
          "css",
          "json",
          "yaml",
          "toml",
          "markdown",
          "bash",
        },
        highlight = { enable = true },
        indent = { enable = true },
        auto_install = true,
      })
    end,
  },

  -- Language support plugins
  { "vim-scripts/applescript.vim", ft = "applescript" },
  { "ekalinin/Dockerfile.vim", ft = "dockerfile" },
  { "keith/swift.vim", ft = "swift" },
  { "tpope/vim-markdown", ft = "markdown" },
  { "wuelnerdotexe/vim-astro", ft = "astro" },
  { "rust-lang/rust.vim", ft = "rust" },
  { "qnighy/lalrpop.vim", ft = "lalrpop" },
  { "wlangstroth/vim-racket", ft = "racket" },
  { "fasiha/pollen.vim", ft = "pollen" },
  { "mxw/vim-jsx", ft = { "javascript", "javascriptreact" } },
  { "pangloss/vim-javascript", ft = "javascript" },
  { "leafgarland/typescript-vim", ft = "typescript" },
  { "kchmck/vim-coffee-script", ft = "coffee" },
  { "elixir-editors/vim-elixir", ft = "elixir" },
  { "idris-hackers/idris-vim", ft = "idris" },
  { "derekwyatt/vim-scala", ft = "scala" },
  { "jparise/vim-graphql", ft = "graphql" },
  { "cespare/vim-toml", ft = "toml" },
  { "hwayne/tla.vim", ft = "tla" },
  { "rhysd/vim-wasm", ft = "wasm" },
  { "hashivim/vim-terraform", ft = "terraform" },
  { "martinda/Jenkinsfile-vim-syntax", ft = "Jenkinsfile" },
  { "lervag/vimtex", ft = "tex" },
  { "LnL7/vim-nix", ft = "nix" },
  { "vim-scripts/n3.vim", ft = "n3" },
  { "whybin/alloy.vim", ft = "alloy" },
  { "vim-scripts/ebnf.vim", ft = "ebnf" },
  { "dart-lang/dart-vim-plugin", ft = "dart" },
  { "thosakwe/vim-flutter", ft = "dart" },
  { "chrisbra/csv.vim", ft = "csv" },
  { "rvesse/vim-sparql", ft = "sparql" },
  { "tikhomirov/vim-glsl", ft = "glsl" },
  { "rescript-lang/vim-rescript", ft = "rescript" },
  { "gleam-lang/gleam.vim", ft = "gleam" },

  -- Colorschemes
  { "flazz/vim-colorschemes" },
  { "felixhummel/setcolors.vim" },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha", -- latte, frappe, macchiato, mocha
      })
      vim.cmd("colorscheme catppuccin")
    end,
  },
}
