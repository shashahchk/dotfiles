vim.g.mapleader = " "

local keymap = vim.keymap.set
local opts = { silent = true }

-- Quick quit
keymap("n", "<leader>q", ":qa<CR>", opts)

-- Clear search highlight
keymap("n", "<leader>h", ":nohlsearch<CR>", opts)
