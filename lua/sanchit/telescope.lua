-- require('telescope').setup()
-- require("telescope").load_extension("dir")
local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
  return
end

local builtin = require("telescope.builtin")

local ts_select_dir_for_grep = function(picker_fn)
  return function(prompt_bufnr)
    local action_state = require("telescope.actions.state")
    local fb = require("telescope").extensions.file_browser
    local live_grep = require("telescope.builtin").live_grep
    local current_line = action_state.get_current_line()

    fb.file_browser({
      files = false,
      depth = false,
      attach_mappings = function(prompt_bufnr)
        require("telescope.actions").select_default:replace(function()
        local entry_path = action_state.get_selected_entry().Path
        if not entry_path then
          vim.notify("No valid directory selected!", vim.log.levels.WARN)
          return
        end

        local dir = entry_path:is_dir() and entry_path or entry_path:parent()
        local relative = dir:make_relative(vim.fn.getcwd())
        local absolute = dir:absolute()

        picker_fn({
          results_title = absolute .. "/",
          cwd = absolute,
          default_text = current_line,
        })
        end)
        return true
      end,
    })
  end
end

local actions = require "telescope.actions"

telescope.setup {
  defaults = {

    prompt_prefix = " ",
    selection_caret = " ",

    mappings = {
      i = {
        ["<C-n>"] = actions.cycle_history_next,
        ["<C-p>"] = actions.cycle_history_prev,

        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,

        ["<C-c>"] = actions.close,

        ["<Down>"] = actions.move_selection_next,
        ["<Up>"] = actions.move_selection_previous,

        ["<CR>"] = actions.select_default,
        ["<C-x>"] = actions.select_horizontal,
        ["<C-v>"] = actions.select_vertical,
        ["<C-t>"] = actions.select_tab,

        ["<C-u>"] = actions.preview_scrolling_up,
        ["<C-d>"] = actions.preview_scrolling_down,

        ["<PageUp>"] = actions.results_scrolling_up,
        ["<PageDown>"] = actions.results_scrolling_down,

        ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
        ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
        ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
        ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
        ["<C-l>"] = actions.complete_tag,
        ["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
      },

      n = {
        ["<esc>"] = actions.close,
        ["<CR>"] = actions.select_default,
        ["<C-x>"] = actions.select_horizontal,
        ["<C-v>"] = actions.select_vertical,
        ["<C-t>"] = actions.select_tab,

        ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
        ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
        ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
        ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,

        ["j"] = actions.move_selection_next,
        ["k"] = actions.move_selection_previous,
        ["H"] = actions.move_to_top,
        ["M"] = actions.move_to_middle,
        ["L"] = actions.move_to_bottom,

        ["<Down>"] = actions.move_selection_next,
        ["<Up>"] = actions.move_selection_previous,
        ["gg"] = actions.move_to_top,
        ["G"] = actions.move_to_bottom,

        ["<C-u>"] = actions.preview_scrolling_up,
        ["<C-d>"] = actions.preview_scrolling_down,

        ["<PageUp>"] = actions.results_scrolling_up,
        ["<PageDown>"] = actions.results_scrolling_down,

        ["?"] = actions.which_key,
      },
    },
  },
  pickers = {
    -- Default configuration for builtin pickers goes here:
    -- picker_name = {
    --   picker_config_key = value,
    --   ...
    -- }
    -- Now the picker_config_key will be applied every time you call this
    -- builtin picker
    planets = {
      show_pluto = true,
    },
    live_grep = {
      -- Custom function to search in a particular dir.
      mappings = {
        i = {
          ["<C-f>"] = ts_select_dir_for_grep(builtin.live_grep),
        },
        n = {
          ["<C-f>"] = ts_select_dir_for_grep(builtin.find_files),
        },
      },
    },
    find_files = {
      -- Custom function to search in a particular dir.
      mappings = {
        i = {
          ["<C-f>"] = ts_select_dir_for_grep(builtin.find_files),
        },
        n = {
          ["<C-f>"] = ts_select_dir_for_grep(builtin.find_files),
        },
      },
    },
  },
  extensions = {
    -- Your extension configuration goes here:
    -- extension_name = {
    --   extension_config_key = value,
    -- }
    -- please take a look at the readme of the extension you want to configure
  },
}

-- Load extensions
telescope.load_extension("file_browser")
