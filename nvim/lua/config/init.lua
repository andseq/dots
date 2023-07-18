local M = {}

function M.init()
	require("config.options")
	require("config.autocmds")
	require("config.keymaps")
	require("config.lazy").init()
end

return M
