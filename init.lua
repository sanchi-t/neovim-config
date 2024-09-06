vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.cmd('autocmd BufRead,BufNewFile *.hbs set filetype=html')

require "sanchit.options"
require "sanchit.colorscheme"
require "sanchit.plugins"
require "sanchit.gitsigns"
require "sanchit.keymaps"
require "sanchit.nvim-tree"
require "sanchit.telescope"
require "sanchit.comment"
require "sanchit.treesitter"
