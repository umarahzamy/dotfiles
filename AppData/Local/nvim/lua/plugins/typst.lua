return {
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "tinymist" })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tinymist = {
          settings = {
            formatterMode = "typstyle",
            exportPdf = "onSave",
            semanticTokens = "enable",
            completion = {
              postfix = true,
              triggerOnSnippetPlaceholders = true,
            },
            lint = {
              enabled = true,
              when = "onSave",
            },
          },
          on_attach = function(client, bufnr)
            -- Toggle typst preview terminal
            vim.keymap.set("n", "<leader>tp", function()
              local pdf_path = vim.fn.expand("%:p:r") .. ".pdf"
              if vim.fn.filereadable(pdf_path) == 1 then
                Snacks.terminal.toggle("clear && sumatrapdf " .. pdf_path, {
                  win = { style = "terminal" },
                })
              else
                vim.notify("PDF not found. Save the file first.", vim.log.levels.WARN)
              end
            end, { desc = "Typst Preview", buffer = bufnr })
          end,
        },
      },
    },
  },
}
