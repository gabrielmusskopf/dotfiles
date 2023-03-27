
require("formatter").setup {
  logging = true,
  log_level = vim.log.levels.WARN,
  filetype = {
    java = {
      require("formatter.filetypes.java").clangformat,
    },
    go = {
      require("formatter.filetypes.go").gofmt,
      require("formatter.filetypes.go").goimports,
      require("formatter.filetypes.go").golines,
    },
    lua = {
      require("formatter.filetypes.lua").stylua,
    },

    -- Use the special "*" filetype for defining formatter configurations on
    -- any filetype
    ["*"] = {
      -- "formatter.filetypes.any" defines default configurations for any
      -- filetype
      require("formatter.filetypes.any").remove_trailing_whitespace
    }
  }
}

--vim.keymap.set("n", "<leader>f", require("formatter.complete").complete({}), { silent = true })
