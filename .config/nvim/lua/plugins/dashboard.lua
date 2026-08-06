return {
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      local util = require("snacks.picker.util")
      local orig = util.truncpath

      util.truncpath = function(path, len, o)
        local full = orig(path, math.huge, o)
        if vim.api.nvim_strwidth(full) <= len then
          return full
        end
        local dir, base = full:match("^(.*)/(.+)$")
        if not dir then
          return orig(path, len, o)
        end
        local budget = len - vim.api.nvim_strwidth(base) - 1
        if budget < 4 then
          return orig(path, len, o)
        end
        return util.truncate(dir, budget, false) .. "/" .. base
      end

      return vim.tbl_deep_extend("force", opts or {}, {
        dashboard = { enabled = false },
        picker = {
          formatters = { file = { min_width = 60 } },
          sources = {
            grep = { format = "filename" },
            grep_word = { format = "filename" },
            grep_buffers = { format = "filename" },
            git_grep = { format = "filename" },
          },
        },
      })
    end,
  },
}
