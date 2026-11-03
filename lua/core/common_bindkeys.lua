local bind = require("utils.util").bind_noremap

bind("n", "<esc><cr>", "<cmd>noh<cr>", "No search hl")
bind("n", "<C-h>", "<C-w>h", "Move left panel")
bind("n", "<C-j>", "<C-w>j", "Move bottom panel")
bind("n", "<C-k>", "<C-w>k", "Move upper panel")
bind("n", "<C-l>", "<C-w>l", "Move right panel")
bind("n", "<C-\\>", "<cmd>vsplit<cr>", "Verical split")
bind("n", "<C-S-\\>", "<cmd>split<cr>", "Horizontal split")
bind({ "n", "v" }, "<S-j>", "5j", "Move fast down")
bind({ "n", "v" }, "<S-k>", "5k", "Move fast up")
bind({ "n", "v" }, "<Leader>ee", "<cmd>Explore<cr>", "Open explorer")
bind({ "n", "v" }, "<Leader>ec", "<cmd>Rex<cr>", "Close explorer")
