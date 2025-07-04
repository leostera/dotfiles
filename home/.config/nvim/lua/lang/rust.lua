return {
  "mrcjkb/rustaceanvim",
  version = "^3",
  dependencies = {
    {
      "Saecki/crates.nvim",
      opts = {
        null_ls = {
          enabled = true,
          name = "crates.nvim",
        },
      },
    },
  },
  ft = "rust",
  event = "BufEnter Cargo.toml",
  opts = {
    tools = {},
    server = {
      settings = {
        ["rust-analyzer"] = {
          checkOnSave = {
            allFeatures = true,
            overrideCommand = {
              "cargo",
              "clippy",
              "--workspace",
              "--message-format=json",
              "--all-features",
            },
          },
          procMacro = {
            enable = true,
          },
        },
      },
    },
  },
  config = function(_, opts)
    vim.g.rustaceanvim = opts
  end,
}
