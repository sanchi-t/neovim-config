vim.opt.termguicolors = true
require("nvim-tree").setup({
  sort = {
    sorter = "case_sensitive",
  },
  view = {
    width = 30,
    side = "left",
     -- Disable toggling of number and relativenumber
    number = true,
    relativenumber = true,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})

-- Ensure line numbers are always on
vim.opt.number = true
vim.opt.relativenumber = true
