local function enable_debugger(bufnr)
	require("jdtls").setup_dap({ hotcodereplace = "auto" })

	local opts = { buffer = bufnr }
	vim.keymap.set("n", "<leader>dnc", "<cmd>lua require('jdtls').test_class()<cr>", opts)
	vim.keymap.set("n", "<leader>dnt", "<cmd>lua require('jdtls').test_nearest_method()<cr>", opts)
	vim.keymap.set("n", "<F2>", "<cmd>lua require('jdtls.dap').setup_dap_main_class_configs()<CR>", opts)
end

local function jdtls_on_attach(_, bufnr)
	on_attach()
	enable_debugger(bufnr)
end

return {
	"mfussenegger/nvim-jdtls",
	lazy = false,
	config = function()
		jdtls_on_attach()
	end,
}
