return {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
        require('copilot').setup({
            panel = {
                enabled = true,
                auto_refresh = false,
                keymap = {
                    jump_prev = "[[",
                    jump_next = "]]",
                    accept = "<cr>",
                    refresh = "gr",
                    open = "<m-cr>"
                },
                layout = {
                    position = "bottom", -- | top | left | right | horizontal | vertical
                    ratio = 0.4
                },
            },
            suggestion = {
                enabled = true,
                auto_trigger = true,
                hide_during_completion = true,
                debounce = 75,
                keymap = {
                    accept = "<m-y>",
                    accept_word = false,
                    accept_line = false,
                    next = "<m-]>",
                    prev = "<m-[>",
                    dismiss = "<c-]>",
                },
            },
            filetypes = {
                yaml = false,
                markdown = false,
                help = false,
                gitcommit = false,
                gitrebase = false,
                hgcommit = false,
                svn = false,
                cvs = false,
                ["."] = false,
            },
            copilot_node_command = 'node', -- node.js version must be > 18.x
            server_opts_overrides = {},
        })
    end,
}
