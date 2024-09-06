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
  use { "nvim-tree/nvim-tree.lua" }
  use { "nvim-tree/nvim-web-devicons"}

	-- Colorschemes
  use { "folke/tokyonight.nvim", commit = "66bfc2e8f754869c7b651f3f47a2ee56ae557764" }
  use { "morhetz/gruvbox"}
        -- Telescope
  use { "nvim-telescope/telescope.nvim", tag = "0.1.5",  requires = { {"nvim-lua/plenary.nvim"}, {'BurntSushi/ripgrep'},{'sharkdp/fd'}, }}
  use { "princejoogie/dir-telescope.nvim", requires = {"nvim-telescope/telescope.nvim"}, config = function()
    require("dir-telescope").setup({
      -- these are the default options set
      hidden = false,
      no_ignore = true,
      show_preview = true,
    })
  end,}
        -- Treesitter
  use { "nvim-treesitter/nvim-treesitter", commit = "226c1475a46a2ef6d840af9caa0117a439465500",}
        -- Airplane
  use { "vim-airline/vim-airline" }
	-- Git
  use { "lewis6991/gitsigns.nvim" }
        -- Comment
  use { "numToStr/Comment.nvim" }

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
