local get_path = ya.sync(function()
	local h = cx.active.current.hovered
	return h and tostring(h.url) or nil
end)

return {
	entry = function()
		local path = get_path()
		if not path then return end

		local home = os.getenv("HOME")
		if home and path:sub(1, #home) == home then
			path = "~" .. path:sub(#home + 1)
		end

		ya.clipboard(path)
	end,
}
