local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    PACKER_BOOTSTRAP = fn.system({
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
    })
    print("Installing packer close and reopen Neovim...")
    vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
    return
end

-- Have packer use a popup window
packer.init({
    display = {
        open_fn = function()
            return require("packer.util").float({ border = "rounded" })
        end,
    },
})

-- Install your plugins here
return packer.startup(function(use)
    use { "wbthomason/packer.nvim", commit = "6afb67460283f0e990d35d229fd38fdc04063e0a" } -- Have packer manage itself
    use { "windwp/nvim-autopairs", commit = "4fc96c8f3df89b6d23e5092d31c866c53a346347" } -- Autopairs, integrates with both cmp and treesitter
    use { "ahmedkhalf/project.nvim", commit = "628de7e433dd503e782831fe150bb750e56e55d6" }
    use { "goolord/alpha-nvim", commit = "0bb6fc0646bcd1cdb4639737a1cee8d6e08bcc31" }
    use { "nvim-tree/nvim-tree.lua", commit = "c7639482a1598f4756798df1b2d72f79fe5bb34f" }
    use { "nvim-tree/nvim-web-devicons" }

    -- Colorschemes
    use { "folke/tokyonight.nvim", commit = "66bfc2e8f754869c7b651f3f47a2ee56ae557764" }
    use { "morhetz/gruvbox" }
    -- Cmp
    use { "hrsh7th/nvim-cmp", commit = "b5311ab3ed9c846b585c0c15b7559be131ec4be9" }           -- The completion plugin
    use { "hrsh7th/cmp-nvim-lsp", commit = "a8912b88ce488f411177fc8aed358b04dc246d7b" }
    use { "hrsh7th/cmp-buffer", commit = "b74fab3656eea9de20a9b8116afa3cfc4ec09657" }         -- buffer completions
    use { "hrsh7th/cmp-path", commit = "e52e640b7befd8113b3350f46e8cfcfe98fcf730" }           -- path completions
    use { "saadparwaiz1/cmp_luasnip", commit = "98d9cb5c2c38532bd9bdb481067b20fea8f32e90" }   -- snippet completion
    -- Snippets
    use { "L3MON4D3/LuaSnip", commit = "eda5be8f0ce9816278671f0b578cdbb8b762c701" }           --snippet engine
    use { "rafamadriz/friendly-snippets", commit = "572f5660cf05f8cd8834e096d7b4c921ba18e175" } -- a bunch of snippets to use
    -- Telescope
    use { "nvim-telescope/telescope.nvim", tag = "0.1.5", requires = { { "nvim-lua/plenary.nvim" }, { 'BurntSushi/ripgrep' }, { 'sharkdp/fd' }, } }
    use { "nvim-telescope/telescope-file-browser.nvim", requires = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" } }
    -- Treesitter
    use { "nvim-treesitter/nvim-treesitter", commit = "e1e3108cd23d7f967842261bd66126b6734d8907" }
    -- Airplane
    use { "vim-airline/vim-airline" }
    -- Git
    use { "lewis6991/gitsigns.nvim", commit = "1ef74b546732f185d0f806860fa5404df7614f28" }
    -- Comment
    use { "numToStr/Comment.nvim" }

    -- AutoCompetion
    use { "saghen/blink.cmp", version = "1.*", dependencies = { "rafamadriz/friendly-snippets" } }

    -- LSP config
    use { "neovim/nvim-lspconfig", commit = "6bba673aa8993eceec233be17b42ddfb9540794b" } -- enable LSP
    use { "williamboman/mason.nvim", commit = "8024d64e1330b86044fed4c8494ef3dcd483a67c" } -- simple to use language server installer
    use { "williamboman/mason-lspconfig.nvim", commit = "0051870dd728f4988110a1b2d47f4a4510213e31" }
    use { "RRethy/vim-illuminate", commit = "0d1e93684da00ab7c057410fecfc24f434698898" }

    -- Tmux-Neovim Navigation
    use {"christoomey/vim-tmux-navigator", commit = "c45243dc1f32ac6bcf6068e5300f3b2b237e576a" }

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if PACKER_BOOTSTRAP then
        require("packer").sync()
    end
end)
