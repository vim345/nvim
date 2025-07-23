local work = vim.env.WORK or ""

return {
	"Exafunction/windsurf.vim",
	disable = (work ~= "1"),
	event = "BufEnter",
}
