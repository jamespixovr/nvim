-- Completion
return {
	{
		"hrsh7th/nvim-cmp",
		event = { "InsertEnter", "CmdlineEnter" },
		dependencies = {
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-nvim-lsp-signature-help",
			"onsails/lspkind-nvim",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/cmp-nvim-lsp-document-symbol",
			{
				"windwp/nvim-autopairs",
				config = function()
					require("modules.plugins.autopairs")
				end,
			},
			{
				"tzachar/cmp-tabnine",
				build = "./install.sh",
				dependencies = "hrsh7th/nvim-cmp",
				config = function()
					require("modules.plugins.tabnine")
				end,
			},
		},
		config = function()
			require("plugins.completion.cmputils")
		end,
	},

	{
		"L3MON4D3/LuaSnip",
		config = function()
			require("luasnip.loaders.from_lua").lazy_load()
			require("luasnip.loaders.from_vscode").lazy_load()
			require("luasnip.loaders.from_snipmate").lazy_load()
		end,
		event = "InsertEnter",
		dependencies = {
			"rafamadriz/friendly-snippets",
		},
	},
}
