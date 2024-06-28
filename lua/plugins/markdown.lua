return {
  { -- emphasized headers & code blocks in markdown
    "lukas-reineke/headlines.nvim",
    event = "VeryLazy",
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
      -- PERF: schedule to prevent headlines slowing down opening a file
      vim.schedule(function()
        local hl = require("headlines")
        hl.setup(opts)
        local md = hl.config.markdown
        hl.refresh()

        -- Toggle markdown headlines on insert enter/leave
        vim.api.nvim_create_autocmd({ "InsertEnter", "InsertLeave" }, {
          callback = function(data)
            if vim.bo.filetype == "markdown" then
              hl.config.markdown = data.event == "InsertLeave" and md or nil
              hl.refresh()
            end
          end,
        })
      end)
      -- require("headlines").setup(opts)
    end,
  },
  {
    "MeanderingProgrammer/markdown.nvim",
    -- name = "render-markdown", -- Only needed if you have another plugin named markdown.nvim
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    ft = { "markdown", "norg", "rmd", "org" },
    config = function()
      require("render-markdown").setup({})
    end,
  },
}
