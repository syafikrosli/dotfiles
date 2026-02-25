require("config.lazy")

vim.opt.background = "dark"
vim.opt.breakindent = true
vim.opt.expandtab = true
vim.opt.ignorecase = true
vim.opt.linebreak = true
vim.opt.modelines = 0
vim.opt.mouse = "a"
vim.opt.number = true
vim.opt.scrolloff = 0
vim.opt.showmode = false
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.cmd("colorscheme everforest")

require("lualine").setup({
  options = { theme = "everforest" }
})
