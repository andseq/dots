local M = {}

function M.init()
	require("config.options")
	require("config.autocmds")
	require("config.keymaps")
	require("lazy").setup("plugins")
end

return M
