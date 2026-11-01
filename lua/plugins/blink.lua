require("blink.cmp").setup({
	snippets = { preset = "luasnip" },
	signature = { enabled = true },
	appearance = {
		use_nvim_cmp_as_default = false,
		nerd_font_variant = "mono",
	},
	sources = {
		default = { "lsp", "path", "snippets", "buffer" },
		providers = {
			lazydev = {
				name = "LazyDev",
				module = "lazydev.integrations.blink",
				-- make lazydev completions top priority (see `:h blink.cmp`)
				score_offset = 100,
			},
		},
	},
	keymap = {
		preset = "enter",
		["<C-f>"] = {},
		["<cr>"] = { "accept", "fallback" },
		["<tab>"] = { "select_next", "fallback" },
		["<S-tab>"] = { "select_prev", "fallback" },
		["<C-space>"] = {
			function(cmp)
				cmp.show({ providers = { "snippets" } })
			end,
		},
	},
	cmdline = {},
	completion = {
		list = { selection = { preselect = false, auto_insert = true } },
		menu = {
			border = nil,
			scrolloff = 1,
			scrollbar = false,
			draw = {
				components = {
					kind_icon = {
						ellipsis = false,
						text = function(ctx)
							local icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
							return icon
						end,
					},
					kind = {
						ellipsis = false,
						text = function(ctx)
							return "‹" .. ctx.kind .. "›"
						end,
					},
				},
				columns = {
					{ "kind_icon" },
					{ "label", "label_description", gap = 2 },
					{ "kind" },
					--              { "source_name" },
				},
			},
		},
		documentation = {
			window = {
				border = nil,
				scrollbar = false,
				winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,EndOfBuffer:BlinkCmpDoc",
			},
			auto_show = true,
			auto_show_delay_ms = 500,
		},
	},
})

require("luasnip.loaders.from_vscode").lazy_load()
