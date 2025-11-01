return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/neodev.nvim", opts = {} },
		"williamboman/mason-lspconfig.nvim",
	},
	config = function()
		-- import lspconfig plugin
		local lspconfig = require("lspconfig")

		-- import mason_lspconfig plugin
		local mason_lspconfig = require("mason-lspconfig")

		-- import cmp-nvim-lsp plugin
		local cmp_nvim_lsp = require("cmp_nvim_lsp")

		local keymap = vim.keymap -- for conciseness

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				-- Buffer local mappings.
				-- See `:help vim.lsp.*` for documentation on any of the below functions
				local opts = { buffer = ev.buf, silent = true }

				-- Enable inlay hints if supported by the server
				local client = vim.lsp.get_client_by_id(ev.data.client_id)
				if client and client.server_capabilities.inlayHintProvider then
					vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
				end

				-- set keybinds
				opts.desc = "Show LSP references"
				keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

				opts.desc = "Go to declaration"
				keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

				opts.desc = "Show LSP definitions"
				keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

				opts.desc = "Show LSP implementations"
				keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

				opts.desc = "Show LSP type definitions"
				keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

				opts.desc = "See available code actions"
				keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

				opts.desc = "Smart rename"
				keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

				opts.desc = "Show buffer diagnostics"
				keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

				opts.desc = "Show line diagnostics"
				keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

				opts.desc = "Go to previous diagnostic"
				keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

				opts.desc = "Go to next diagnostic"
				keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

				opts.desc = "Show documentation for what is under cursor"
				keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

				opts.desc = "Restart LSP"
				keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary

				-- Toggle inlay hints (Neovim 0.10+)
				opts.desc = "Toggle Inlay Hints"
				keymap.set("n", "<leader>ih", function()
					vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf }), { bufnr = ev.buf })
				end, opts)
			end,
		})

		-- used to enable autocompletion (assign to every lsp server config)
		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- Change the Diagnostic symbols in the sign column (gutter)
		-- (not in youtube nvim video)
		vim.diagnostic.config({
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = " ",
					[vim.diagnostic.severity.WARN] = " ",
					[vim.diagnostic.severity.HINT] = "󰠠 ",
					[vim.diagnostic.severity.INFO] = " ",
				},
			},
		})

		-- configure individual servers manually since mason-lspconfig no longer uses setup_handlers
		-- configure graphql language server
		lspconfig["graphql"].setup({
			capabilities = capabilities,
			filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
		})

		-- configure emmet language server
		lspconfig["emmet_ls"].setup({
			capabilities = capabilities,
			filetypes = {
				"html",
				"typescriptreact",
				"javascriptreact",
				"css",
				"sass",
				"scss",
				"less",
				"svelte",
			},
		})

		-- configure lua server (with special settings)
		lspconfig["lua_ls"].setup({
			capabilities = capabilities,
			settings = {
				Lua = {
					-- make the language server recognize "vim" global
					diagnostics = {
						globals = { "vim" },
					},
					completion = {
						callSnippet = "Replace",
					},
				},
			},
		})

		-- configure rust analyzer with comprehensive settings
		lspconfig["rust_analyzer"].setup({
			capabilities = capabilities,
			settings = {
				["rust-analyzer"] = {
					-- Enable inlay hints for type annotations
					inlayHints = {
						enable = true,
						-- Show inlay hints for parameter names
						parameterHints = {
							enable = true,
						},
						-- Show inlay hints for type annotations
						typeHints = {
							enable = true,
							hideClosureInitialization = false,
							hideNamedConstructor = false,
						},
						-- Show inlay hints for chaining
						chainingHints = {
							enable = true,
						},
						-- Maximum length for inlay hints
						maxLength = 25,
					},

					-- Cargo configuration
					cargo = {
						-- Load out-of-date workspaces
						-- loadOutDirsFromCheck = true,
						-- Run cargo check on save
						-- buildScripts = {
						-- 	enable = true,
						-- },
						-- All features
						allFeatures = true,
						-- Specify features to activate
						-- features = {},
					},

					-- Proc macro support
					procMacro = {
						enable = true,
						-- attributes = {
						-- 	enable = true,
						-- },
					},

					-- Check configuration (runs on save)
					check = {
						-- Use clippy for checking instead of cargo check
						command = "clippy",
						-- Extra args to pass to the check command
						-- extraArgs = { "--all", "--", "-W", "clippy::all" },
					},

					-- Diagnostics configuration
					diagnostics = {
						enable = true,
						-- Disable specific diagnostics
						-- disabled = { "unresolved-proc-macro" },
						-- Enable experimental diagnostics
						-- experimental = {
						-- 	enable = true,
						-- },
					},

					-- Completion configuration
					completion = {
						-- Enable autoimport on completion
						autoimport = {
							enable = true,
						},
						-- Enable postfix completions like .if, .match
						postfix = {
							enable = true,
						},
						-- Show full function signatures in completion
						callable = {
							snippets = "fill_arguments",
						},
					},

					-- Code lens configuration
					lens = {
						enable = true,
						-- Show references
						references = {
							adt = { enable = true },
							enumVariant = { enable = true },
							method = { enable = true },
							trait = { enable = true },
						},
						-- Show implementations
						implementations = {
							enable = true,
						},
						-- Show run and debug lens
						run = {
							enable = true,
						},
						debug = {
							enable = true,
						},
					},

					-- Hover actions configuration
					hover = {
						actions = {
							enable = true,
							-- Show implementations
							implementations = {
								enable = true,
							},
							-- Show references
							references = {
								enable = true,
							},
							-- Show run and debug
							run = {
								enable = true,
							},
							debug = {
								enable = true,
							},
						},
						-- Documentation configuration
						documentation = {
							enable = true,
						},
					},

					-- Assist configuration (code actions)
					assist = {
						-- Import granularity (crate, module, item)
						importGranularity = "module",
						-- Import prefix (by_self, by_crate, plain)
						importPrefix = "by_self",
						-- Import enforcement
						-- importEnforceGranularity = true,
					},

					-- Formatting configuration
					-- rustfmt = {
					-- 	extraArgs = {},
					-- 	overrideCommand = nil,
					-- 	rangeFormatting = {
					-- 		enable = false,
					-- 	},
					-- },

					-- Workspace symbol search configuration
					workspace = {
						symbol = {
							search = {
								-- Search scope: workspace, workspace_and_dependencies
								scope = "workspace",
								-- Search kind: only_types, all_symbols
								kind = "all_symbols",
								-- Limit number of results
								limit = 128,
							},
						},
					},

					-- Notifications configuration
					-- notifications = {
					-- 	cargoTomlNotFound = true,
					-- },
				},
			},
		})
	end,
}
