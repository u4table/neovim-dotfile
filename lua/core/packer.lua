vim.cmd([[packadd packer.nvim]])
return require("packer").startup(function(use)
	use("wbthomason/packer.nvim")

	use({
		"nvim-neo-tree/neo-tree.nvim",
		requires = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
		},
	})

	-- status line
	use({
		"junegunn/fzf",
		run = function()
			vim.fn["fzf#install"]()
		end,
	})
	use({ "junegunn/fzf.vim" })
	use("nvim-lualine/lualine.nvim")
	use("nvim-mini/mini.tabline")

	-- style
	use({
		"nvim-mini/mini.pairs",
		branch = "stable",
	})
	use({
		"nvim-mini/mini.icons",
		branch = "stable",
	})
	use({ "j-hui/fidget.nvim" })
	use({ "stevearc/conform.nvim" })
	use("lukas-reineke/indent-blankline.nvim")

	-- LSP
	use("mason-org/mason.nvim")
	use({
		"saghen/blink.cmp",
		tag = "v1.9.1",
		requires = {
			"L3MON4D3/LuaSnip",
			"rafamadriz/friendly-snippets",
		},
	})

	-- Debug
	use({
		"rcarriga/nvim-dap-ui",
		requires = {
			"mfussenegger/nvim-dap",
			"nvim-neotest/nvim-nio",
		},
	})
	use({ "theHamsta/nvim-dap-virtual-text" })
	use({ "leoluz/nvim-dap-go" })

	-- Telescope
	use({
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		requires = {
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
			{ "nvim-telescope/telescope-ui-select.nvim" },
		},
	})

	-- Colorscheme
	use({ "ellisonleao/gruvbox.nvim" })
	use({ "doums/darcula" })
	use({ "vishifu/nvim.vscode" })
	use({
		"nvim-treesitter/nvim-treesitter",
		tag = "v0.10.0",
	})
	use("gmr458/vscode_modern_theme.nvim")

	-- Utils
	use({ "rhysd/try-colorscheme.vim" })

	-- Git
	use({ "lewis6991/gitsigns.nvim" })
end)
