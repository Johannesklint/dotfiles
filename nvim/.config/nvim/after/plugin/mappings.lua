local default_opt = { noremap = true, silent = true }
local gitsigns = require("gitsigns")

local status, telescope = pcall(require, "telescope")
if (not status) then return end
local actions = require('telescope.actions')
-- telescope-file-browser.actions.createocal builtin = require("telescope.builtin")


local function telescope_buffer_dir()
  return vim.fn.expand('%:p:h')
end

local fb_actions = require "telescope".extensions.file_browser.actions

telescope.setup {
  defaults = {
    mappings = {
      n = {
        ["q"] = actions.close
      },
    },
  },
  extensions = {
    file_browser = {
      theme = "dropdown",
      -- disables netrw and use telescope-file-browser in its place
      hijack_netrw = true,
      mappings = {
        -- your custom insert mode mappings
        ["i"] = {
          ["<C-w>"] = function() vim.cmd('normal vbd') end,
        },
        ["n"] = {
          -- your custom normal mode mappings
          ["N"] = fb_actions.create,
          ["h"] = fb_actions.goto_parent_dir,
          ["/"] = function()
            vim.cmd('startinsert')
          end
        },
      },
    },
  },
}

telescope.load_extension("file_browser")

vim.keymap.set('n', ';f',
  function()
    builtin.find_files({
      no_ignore = false,
      hidden = true
    })
  end)
vim.keymap.set('n', ';r', function()
  builtin.live_grep()
end)
vim.keymap.set('n', '\\\\', function()
  builtin.buffers()
end)
vim.keymap.set('n', ';t', function()
  builtin.help_tags()
end)
vim.keymap.set('n', ';;', function()
  builtin.resume()
end)
vim.keymap.set('n', ';e', function()
  builtin.diagnostics()
end)
vim.keymap.set("n", "sf", function()
  telescope.extensions.file_browser.file_browser({
    path = "%:p:h",
    cwd = telescope_buffer_dir(),
    respect_gitignore = false,
    hidden = true,
    grouped = true,
    previewer = false,
    initial_mode = "normal",
    layout_config = { height = 40, width = 160 }
  })
end)


-- Go over wrapped lines
vim.keymap.set("n", "j", "gj", default_opt)
vim.keymap.set("n", "k", "gk", default_opt)

-- Keep selection in visual mode when indenting
vim.keymap.set("v", "<", "<gv", default_opt)
vim.keymap.set("v", ">", ">gv", default_opt)

-- Move lines in visual mode
vim.keymap.set("v", "<C-j>", ":m '>+1<CR>gv=gv", default_opt)
vim.keymap.set("v", "<C-k>", ":m '<-2<CR>gv=gv", default_opt)

-- Previous and Next: Quickfix
vim.keymap.set("n", "[c", ":cprevious<CR>", default_opt)
vim.keymap.set("n", "]c", ":cnext<CR>", default_opt)
vim.keymap.set("n", "[C", ":cfirst<CR>", default_opt)
vim.keymap.set("n", "]C", ":clast<CR>", default_opt)

-- Previous and Next: Loclist
vim.keymap.set("n", "[l", ":lprevious<CR>", default_opt)
vim.keymap.set("n", "]l", ":lnext<CR>", default_opt)
vim.keymap.set("n", "[L", ":lfirst<CR>", default_opt)
vim.keymap.set("n", "]L", ":llast<CR>", default_opt)

-- Previous and Next: Diagnostics
vim.keymap.set("n", "[d", vim.diagnostic.goto_next, default_opt)
vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, default_opt)

-- Diagnostics
vim.keymap.set("n", "<leader>dc", ":Diagnostics<CR>", default_opt)

-- Previous and Next: Buffer
vim.keymap.set("n", "[b", ":bprevious<CR>", default_opt)
vim.keymap.set("n", "]b", ":bnext<CR>", default_opt)

-- Previous and Next: Hunk
vim.keymap.set("n", "[h", gitsigns.prev_hunk, default_opt)
vim.keymap.set("n", "]h", gitsigns.next_hunk, default_opt)

-- Search
vim.keymap.set("n", "<leader>sb", ":Buffers<CR>", default_opt)
vim.keymap.set("n", "<leader>sc", ":Commands<CR>", default_opt)
vim.keymap.set("n", "<leader>sf", ":Files<CR>", default_opt)
vim.keymap.set("n", "<leader>sg", ":GitFiles<CR>", default_opt)

-- Telescope
vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>", default_opt)
vim.keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>", default_opt)
vim.keymap.set("n", "<leader>fb", ":Telescope buffers<CR>", default_opt)
vim.keymap.set("n", "<leader>fh", ":Telescope help_tags<CR>", default_opt)
vim.keymap.set("n", "<leader>fu", ":Telescope lsp_references<CR>", default_opt)

-- Neotree
vim.keymap.set("n", "<leader>fp", ":Neotree position=left dir=%:p:h:h reveal_file=%:p<CR>", default_opt)
vim.keymap.set("n", "<leader>b", ":Neotree position=left<CR>", default_opt)

-- Edit
vim.keymap.set("n", "<leader>ea", vim.lsp.buf.code_action, default_opt)
vim.keymap.set("n", "<leader>ef", vim.lsp.buf.formatting, default_opt)
vim.keymap.set("n", "<leader>f", vim.lsp.buf.formatting, default_opt)
vim.keymap.set("n", "<leader>er", vim.lsp.buf.rename, default_opt)
vim.keymap.set("v", "<leader>es", ":'<,'>sort<CR>", default_opt)

-- Goto
vim.keymap.set("n", "<leader>gf", "gf", default_opt)
vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, default_opt)
vim.keymap.set("n", "<leader>gh", vim.lsp.buf.hover, default_opt)
vim.keymap.set("n", "<leader>gi", vim.lsp.buf.implementation, default_opt)
vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, default_opt)
vim.keymap.set("n", "<leader>gs", vim.lsp.buf.signature_help, default_opt)
vim.keymap.set("n", "<leader>gt", vim.lsp.buf.type_definition, default_opt)


-- Errors 
vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<cr>", default_opt)
vim.keymap.set("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", default_opt)
vim.keymap.set("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>", default_opt)
vim.keymap.set("n", "<leader>xl", "<cmd>TroubleToggle loclist<cr>", default_opt)
vim.keymap.set("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", default_opt)
vim.keymap.set("n", "gR", "<cmd>TroubleToggle lsp_references<cr>", default_opt)

-- Toggle
vim.keymap.set("n", "<leader>tl", ":set list!<CR>", default_opt)
vim.keymap.set("n", "<leader>tp", ":set invpaste<CR>", default_opt)
vim.keymap.set("n", "<leader>ts", ":nohlsearch<CR>", default_opt)


-- Bindings
vim.keymap.set("n", "<C-ä", "0i//", default_opt)
vim.keymap.set('n', '<C-a>', 'gg<S-v>G')
vim.keymap.set('n', 'pp', '"0p')

-- Split window
vim.keymap.set('n', 'ss', ':split<Return><C-w>w')
vim.keymap.set('n', 'sv', ':vsplit<Return><C-w>w')
-- Move window
vim.keymap.set('n', '<Space>', '<C-w>w')
vim.keymap.set('', 'sh', '<C-w>h')
vim.keymap.set('', 'sk', '<C-w>k')
vim.keymap.set('', 'sj', '<C-w>j')
vim.keymap.set('', 'sl', '<C-w>l')

-- Resize window
vim.keymap.set('n', '<C-w><left>', '<C-w><')
vim.keymap.set('n', '<C-w><right>', '<C-w>>')
vim.keymap.set('n', '<C-w><up>', '<C-w>+')
vim.keymap.set('n', '<C-w><down>', '<C-w>-')

-- TODO: DAP keymaps
-- dc  require('dap').continue()
-- dsO require('dap').step_out() "Debug: Step out" },
-- dso require('dap').step_over()
-- dsi require('dap').step_into()
-- bt require('dap').toggle_breakpoint()
-- bc require('dap').clear_breakpoints()
-- dr require('dap').repl.toggle()
