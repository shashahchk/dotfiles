local opt = vim.opt

-- ===== UI =====
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.termguicolors = true
opt.signcolumn = "yes"
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.wrap = false

-- Better splits
opt.splitright = true
opt.splitbelow = true

-- ===== Indentation (4 spaces) =====
opt.tabstop = 4 -- number of visual spaces per TAB
opt.shiftwidth = 4 -- spaces used for autoindent
opt.softtabstop = 4
opt.expandtab = true -- convert tabs to spaces
opt.smartindent = true

-- ===== Misc =====
opt.updatetime = 250
opt.timeoutlen = 400

-- Force 2-space indentation for common filetypes
-- vim.api.nvim_create_autocmd("FileType", {
-- 	pattern = "*",
-- 	callback = function()
-- 		vim.opt_local.tabstop = 2
-- 		vim.opt_local.shiftwidth = 2
-- 		vim.opt_local.softtabstop = 2
-- 		vim.opt_local.expandtab = true
-- 	end,
-- })
