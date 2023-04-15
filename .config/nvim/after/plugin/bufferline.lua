local bufferline = require("bufferline")
bufferline.setup{
    options = {
        numbers = function(opts)
            return string.format('%s', opts.raise(opts.ordinal))
        end,
        separator_style = "slope",
        show_buffer_icons = true,
        diagnostics = "nvim_lsp"
    }
}

vim.keymap.set('n', '<Tab>', function() bufferline.cycle(1) end, {})
vim.keymap.set('n', '<S-Tab>', function() bufferline.cycle(-1) end, {})
vim.keymap.set('n', '<leader>cb',  function() bufferline.close_buffer_with_pick() end, {})
