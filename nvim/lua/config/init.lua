local M = {}

function M.init()
	require("config.options")
	require("config.autocmds")
	require("config.keymaps")
end

return M
