-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- Temas
    use({
        'rose-pine/neovim',
        as = 'rose-pine',
    })
    use { "ellisonleao/gruvbox.nvim" }
    use { "sainnhe/gruvbox-material" }
    use 'kvrohit/rasmus.nvim'
    use 'savq/melange-nvim'
    use { "catppuccin/nvim", as = "catppuccin" }
    use { "EdenEast/nightfox.nvim" }

    -- Git
    use('tpope/vim-fugitive')
    use { 'akinsho/git-conflict.nvim', tag = "*", config = function()
        require('git-conflict').setup()
    end }
    use({
        "iamcco/markdown-preview.nvim",
        run = "cd app && npm install",
        setup = function()
            vim.g.mkdp_filetypes = { "markdown" }
        end,
        ft = { "markdown" },
    })
    use 'nvim-tree/nvim-web-devicons'
    use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })
    use('nvim-lua/plenary.nvim')
    use('ThePrimeagen/harpoon')
    use('mbbill/undotree')
    use('christoomey/vim-tmux-navigator')
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.0',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }
    use {
        "nvim-telescope/telescope-file-browser.nvim",
        requires = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
    }
    use { 'mhartington/formatter.nvim' }
    use { 'akinsho/bufferline.nvim', tag = "v3.*", requires = 'nvim-tree/nvim-web-devicons' }
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'nvim-tree/nvim-web-devicons', opt = true }
    }
    use { 'CRAG666/code_runner.nvim', requires = 'nvim-lua/plenary.nvim' }
    use {
        "folke/zen-mode.nvim",
        config = function()
            require("zen-mode").setup {
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            }
        end
    }
    use { 'norcalli/nvim-colorizer.lua' }
    use {
        'glepnir/dashboard-nvim',
        event = 'VimEnter',
        config = function()
            require('dashboard').setup {
                theme = 'hyper',
                --preview = {
                --    command = 'lolcat',
                --    file_path = '~/.config/banner/preview',
                --    file_height = 25,
                --    file_width = 58
                --},
                config = {
                   -- header = function ()
                   --     return {
                   --     ' ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗',
                   --     ' ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║',
                   --     ' ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║',
                   --     ' ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║',
                   --     ' ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║',
                   --     ' ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝',
                   --     "N E O V I M - v " .. vim.version().major .. "." .. vim.version().minor,
                   --     ""}
                   -- end,
                   -- week_header = {
                   --     enable = false,
                   -- },
                    shortcut = {
                        { desc = '󰊳 Update', group = '@property', action = 'PackerSync', key = 'u' },
                        {
                            icon = ' ',
                            icon_hl = '@variable',
                            desc = 'Config',
                            group = 'Label',
                            action = 'Telescope find_files',
                            key = 'f',
                        },
                        {
                            icon = ' ',
                            desc = 'Projetos',
                            group = 'DiagnosticHint',
                            action = 'Telescope file_browser path=$HOME/projetos',
                            key = 'p',
                        },
                        {
                            icon = ' ',
                            desc = 'Bookmarks',
                            group = 'Label',
                            action = 'Telescope marks',
                            key = 'b',
                        },
                    },
                    packages = { enable = false },
                    project = { enable = true, limit = 8, icon = '', label = ' mrp', action = 'Telescope find_files cwd=' },
                    mru = { limit = 10, icon = '', label = ' mru', },
                    footer = {}
                },
            }
        end,
        requires = {'nvim-tree/nvim-web-devicons'}
    }

    -- LSP
    use('mfussenegger/nvim-jdtls')
    use('hrsh7th/cmp-nvim-lsp-signature-help')
    use {
        'VonHeikemen/lsp-zero.nvim',
        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-nvim-lua' },

            -- Snippets
            { 'L3MON4D3/LuaSnip' },
            -- Snippet Collection (Optional)
            { 'rafamadriz/friendly-snippets' },
        }
    }
end)
