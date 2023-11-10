---@diagnostic disable: missing-fields
return {
  {
    "dnlhc/glance.nvim",
    cmd = { "Glance" },
    config = function()
      local glance = require "glance"
      local actions = glance.actions

      glance.setup {
        height = 20,
        zindex = 45,
        preview_win_opts = {
          cursorline = true,
          number = true,
          wrap = true,
        },
        border = {
          enable = true,
          top_char = "―",
          bottom_char = "―",
        },
        list = {
          position = "right",
          width = 0.33,
        },
        theme = {
          enable = true,
          mode = "auto",
        },
        mappings = {
          list = {
            ["j"] = actions.next,
            ["k"] = actions.previous,
            ["<Down>"] = actions.next,
            ["<Up>"] = actions.previous,
            ["<Tab>"] = actions.next_location,
            ["<S-Tab>"] = actions.previous_location,
            ["<C-u>"] = actions.preview_scroll_win(5),
            ["<C-d>"] = actions.preview_scroll_win(-5),
            ["v"] = actions.jump_vsplit,
            ["s"] = actions.jump_split,
            ["t"] = actions.jump_tab,
            ["<CR>"] = actions.jump,
            ["o"] = actions.jump,
            ["<leader>l"] = actions.enter_win "preview",
            ["q"] = actions.close,
            ["Q"] = actions.close,
            ["<Esc>"] = actions.close,
          },
          preview = {
            ["Q"] = actions.close,
            ["<Tab>"] = actions.next_location,
            ["<S-Tab>"] = actions.previous_location,
            ["<leader>l"] = actions.enter_win "list",
          },
        },
        hooks = {
          before_open = function(results, open, jump, method)
            local uri = vim.uri_from_bufnr(0)
            if #results == 1 then
              local target_uri = results[1].uri or results[1].targetUri

              if target_uri == uri then
                jump(results[1])
              else
                open(results)
              end
            else
              open(results)
            end
          end,
        },
        folds = {
          fold_closed = "",
          fold_open = "",
          folded = true,
        },
        indent_lines = {
          enable = true,
          icon = "│",
        },
        winbar = {
          enable = true,
        },
      }
    end,
  },
}
