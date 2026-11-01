local bind = require("utils.util").bind_noremap

bind("n", "<ESC><CR>", "<CMD>noh<CR>", "No search hl")
bind("n", "<C-h>", "<C-w>h", "Move left panel")
bind("n", "<C-j>", "<C-w>j", "Move bottom panel")
bind("n", "<C-k>", "<C-w>k", "Move upper panel")
bind("n", "<C-l>", "<C-w>l", "Move right panel")
bind("n", "<C-\\>", "<CMD>vsplit<CR>", "Verical split")
bind({ "n", "v" }, "<S-j>", "5j", "Move fast down")
bind({ "n", "v" }, "<S-k>", "5k", "Move fast up")
bind({ "n", "v" }, "<Leader>ee", "<Cmd>Explore<Cr>", "Open explorer")
bind({ "n", "v" }, "<Leader>ec", "<Cmd>Rex<Cr>", "Close explorer")
