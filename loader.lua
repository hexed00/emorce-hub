--[[
EMORCE HUB · GET KEY TO SHOW CODE
demorce tamper activated · fully locked for browsers
]]

-- browser / raw-view trap (no Roblox executor APIs)
do
	local function locked()
		local lines = {
			"-- ============================================",
			"--   demorce tamper activated",
			"--   source locked · get key to view scripts",
			"--   https://emorce-hub.vercel.app",
			"-- ============================================",
		}
		return table.concat(lines, "\n")
	end
	local function isExecutor()
		local g = rawget(_G, "game") or (getfenv and getfenv().game)
		if g == nil then return false end
		if type(loadstring) ~= "function" and type(load) ~= "function" then return false end
		local ok = pcall(function()
			local _ = g.PlaceId
		end)
		return ok
	end
	if not isExecutor() then
		local msg = locked()
		if type(print) == "function" then pcall(print, msg) end
		return (loadstring or load)(msg)
	end
end

local _p = [[
