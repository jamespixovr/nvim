return {
  { -- emphasized headers & code blocks in markdown
    "lukas-reineke/headlines.nvim",
    ft = { "markdown", "yaml" },
    dependencies = "nvim-treesitter/nvim-treesitter",
    opts = {
      markdown = {
        fat_headlines = false,
        bullets = false,
      },
      yaml = { codeblock_highlight = "CodeBlock" },
    },
    config = function(_, opts)
      -- add background to injections, see `ftplugin/yaml/injections.scm`
      -- related BUG https://github.com/lukas-reineke/headlines.nvim/issues/85
      opts.yaml.query = vim.treesitter.query.parse(
        "yaml",
        [[
					(block_mapping_pair
						key: (flow_node) @_run
						(#any-of? @_run "run" "shell_command" "cmd")
						value: (block_node
							(block_scalar) @codeblock
							(#offset! @codeblock 1 1 1 0)))
				]]
      )
      require("headlines").setup(opts)
    end,
  },
}
