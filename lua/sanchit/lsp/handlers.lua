local M = {}

-- Setup LSP capabilities
local status_cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_cmp_ok then
    return
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities.textDocument.completion.completionItem.snippetSupport = true
M.capabilities = cmp_nvim_lsp.default_capabilities(M.capabilities)

-- Set diagnostic signs
M.setup = function()
    local signs = {
        { name = "DiagnosticSignError", text = "" },
        { name = "DiagnosticSignWarn", text = "" },
        { name = "DiagnosticSignHint", text = "" },
        { name = "DiagnosticSignInfo", text = "" },
    }

    for _, sign in ipairs(signs) do
        vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
    end

    local config = {
        virtual_text = false,
        signs = { active = signs },
        update_in_insert = true,
        underline = true,
        severity_sort = true,
        float = {
            focusable = true,
            style = "minimal",
            border = "rounded",
            source = "always",
            header = "",
            prefix = "",
        },
    }
    vim.diagnostic.config(config)

    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "rounded",
    })
end

local function lsp_keymaps(bufnr)
    local opts = { noremap = true, silent = true, buffer = bufnr }

    local map = function(mode, key, cmd, desc)
        vim.keymap.set(mode, key, cmd, vim.tbl_extend("force", opts, { desc = desc }))
    end

    local telescope = require("telescope.builtin")

    -- LSP navigation (via Telescope)
    -- map("n", "gd", telescope.lsp_definitions, "Go to definition (Telescope)")
    -- map("n", "gI", telescope.lsp_implementations, "Go to implementation (Telescope)")
    -- map("n", "gD", telescope.lsp_type_definitions, "Go to type definition (Telescope)")

    map("n", "gd", function()
      telescope.lsp_definitions({ jump_type = "tab" })
    end, "Go to definition in new tab (Telescope)")

    map("n", "gD", function()
      telescope.lsp_type_definitions({ jump_type = "tab" })
    end, "Go to type definition in new tab (Telescope)")

    map("n", "gI", function()
      telescope.lsp_implementations({ jump_type = "tab" })
    end, "Go to implementation in new tab (Telescope)")

    map("n", "gr", telescope.lsp_references, "Find references (Telescope)")
    map("n", "<leader>ls", vim.lsp.buf.signature_help, "Signature help")
    map("n", "K", function()
        vim.lsp.buf.hover({ border = "single", max_height = 25 })
    end, "Show hover documentation with border")


    -- Code actions and refactoring
    map("n", "<leader>la", vim.lsp.buf.code_action, "Code actions")
    map("n", "<leader>lr", vim.lsp.buf.rename, "Rename symbol")
    map("n", "<leader>lf", function() vim.lsp.buf.format { async = true } end, "Format document")
    map("n", "<leader>ds", telescope.lsp_document_symbols, "Document symbols (Telescope)")

    -- Diagnostics
    map("n", "gl", vim.diagnostic.open_float, "Show diagnostic float")
    map("n", "<leader>lj", function()
        vim.diagnostic.jump({ count = 1, float = true })
    end, "Next diagnostic")
    map("n", "<leader>lk", function()
        vim.diagnostic.jump({ count = -1, float = true })
    end, "Previous diagnostic")
    map("n", "<leader>lq", vim.diagnostic.setloclist, "Diagnostics to loclist")
end


-- Called when LSP server attaches to a buffer
M.on_attach = function(client, bufnr)
    if client.name == "tsserver" or client.name == "sumneko_lua" then
        client.server_capabilities.documentFormattingProvider = false
    end

    lsp_keymaps(bufnr)

    local status_ok, illuminate = pcall(require, "illuminate")
    if status_ok then
        illuminate.on_attach(client)
    end
end

return M
