local default_opt = { noremap = true, silent = true }
local gitsigns = require("gitsigns")

-- Go over wrapped lines
vim.keymap.set("n", "j", "gj", default_opt)
vim.keymap.set("n", "k", "gk", default_opt)

-- Keep selection in visual mode when indenting
vim.keymap.set("v", "<", "<gv", default_opt)
vim.keymap.set("v", ">", ">gv", default_opt)

-- Move lines in visual mode
vim.keymap.set("v", "<C-j>", ":m '>+1<CR>gv=gv", default_opt)
vim.keymap.set("v", "<C-k>", ":m '<-2<CR>gv=gv", default_opt)

-- Previous and Next: Hunk
vim.keymap.set("n", "[h", gitsigns.prev_hunk, default_opt)
vim.keymap.set("n", "]h", gitsigns.next_hunk, default_opt)

-- Git
vim.keymap.set("n", "<leader>gl", ":diffget //2<CR>", default_opt) -- Move diff from left side to middle
vim.keymap.set("n", "<leader>gh", ":diffget //3<CR>", default_opt) -- Move diff from right side to middle

-- Search
vim.keymap.set("n", "<leader>sb", ":Buffers<CR>", default_opt)
vim.keymap.set("n", "<leader>sc", ":Commands<CR>", default_opt)
vim.keymap.set("n", "<leader>sf", ":Files<CR>", default_opt)
vim.keymap.set("n", "<leader>sg", ":GitFiles<CR>", default_opt)

-- Telescope
vim.keymap.set("n", "<leader>ff", ":lua require('telescope.builtin').find_files({ prompt_prefix=' 🔭 ' })<CR>", default_opt)
vim.keymap.set("n", "<leader>fg", ":lua require('telescope.builtin').live_grep({ prompt_prefix=' 🔎 ' })<CR>", default_opt)
vim.keymap.set('n', '<leader>fs', require("telescope").extensions.live_grep_args.live_grep_args, default_opt)
vim.keymap.set("n", "<leader>fb", ":lua require('telescope.builtin').buffers({ path_display='smart', prompt_prefix=' 📦 ' })<CR>", default_opt)
vim.keymap.set("n", "<leader>fh", ":Telescope help_tags<CR>", default_opt)
vim.keymap.set("n", "<leader>fu", ":Telescope lsp_references<CR>", default_opt)

-- File explorer
vim.keymap.set("n", "<leader>fp", ":NvimTreeFindFile<CR>zz", default_opt)
vim.keymap.set("n", "<leader>b", ":NvimTreeToggle<CR>", default_opt)
-- Edit
vim.keymap.set("n", "<leader>ea", vim.lsp.buf.code_action, default_opt)
vim.keymap.set("n", "<leader>ef", vim.lsp.buf.format, default_opt)
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, default_opt)
vim.keymap.set("n", "<leader>er", vim.lsp.buf.rename, default_opt)
vim.keymap.set("v", "<leader>es", ":'<,'>sort<CR>", default_opt)
vim.keymap.set("n", "<leader>move", ":TSLspRenameFile<CR>", default_opt)

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
vim.keymap.set("n", "<C-a>", "gg<S-v>G", default_opt) -- mark entire, similar to cmd + a
vim.keymap.set("n", "pp", '"0p', default_opt) -- paste the latest yank
vim.keymap.set("n", "aa", "$", default_opt) -- go to end of line
vim.keymap.set("v", "aa", "$", default_opt) -- go to end of line in visual mode
vim.keymap.set('n', '<leader>s', ":wa<CR>", default_opt) -- save all
vim.keymap.set('n', 'x', '"_x') -- delete but not save in yank
vim.keymap.set('v', 'x', '"_d') -- delete but not save in yank in visual mode
vim.keymap.set('x', '<leader>p',"\"_dP") -- delete but not save in yank when pasting over in visual mode
vim.keymap.set('n', "<C-d>", "<C-d>zz", default_opt) -- Keep cursor in the middle when jumping half page
vim.keymap.set('n', "<C-u>", "<C-u>zz", default_opt) -- Keep cursor in the middle when jumping half page
vim.keymap.set('n', "n", "nzzzv", default_opt) -- Keep cursor in the middle when searching
vim.keymap.set('n', "N", "Nzzzv", default_opt) -- Keep cursor in the middle when searching

-- Split window
vim.keymap.set("n", "ss", ":split<Return><C-w>w", default_opt)
vim.keymap.set("n", 'sv', ":vsplit<Return><C-w>w", default_opt)

-- Move window
vim.keymap.set("n", "<Space>", '<C-w>w', default_opt)
vim.keymap.set('', 'sh', '<C-w>h', default_opt)
vim.keymap.set('', 'sk', '<C-w>k', default_opt)
vim.keymap.set('', 'sj', '<C-w>j', default_opt)
vim.keymap.set('', 'sl', '<C-w>l', default_opt)

-- Resize window
vim.keymap.set('n', '<C-w><left>', '<C-w><', default_opt)
vim.keymap.set('n', '<C-w><right>', '<C-w>>', default_opt)
vim.keymap.set('n', '<C-w><up>', '<C-w>+', default_opt)
vim.keymap.set('n', '<C-w><down>', '<C-w>-', default_opt)

-- Close buffer
vim.keymap.set("n", "<leader>o", ":BufferClose<CR>", default_opt)
vim.keymap.set("n", "<leader>O", ":w | %bd | e#<CR>", default_opt) -- close all buffer but current one
vim.keymap.set("n", "<C-p>", ":BufferPick<CR>", default_opt) -- choose buffer by entering C-9 followed by a letter

-- remap to open the Telescope refactoring menu in visual mode
vim.api.nvim_set_keymap(
  "v",
  "<leader>rr",
  "<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>",
  { noremap = true }
)

