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

-- original Emorce loader (protected payload) runs only in executor
local function httpGet(url)
	local body
	local ok = pcall(function()
		if type(syn) == "table" and type(syn.request) == "function" then
			body = syn.request({ Url = url, Method = "GET" }).Body
		elseif type(http_request) == "function" then
			body = http_request({ Url = url, Method = "GET" }).Body
		elseif type(request) == "function" then
			body = request({ Url = url, Method = "GET" }).Body
		else
			body = game:HttpGet(url)
		end
	end)
	if not ok then return nil end
	return body
end

local function b64decode(data)
	local b = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
	data = tostring(data or ""):gsub("%s+", "")
	return (data:gsub(".", function(x)
		if x == "=" then return "" end
		local r, f = "", (b:find(x) - 1)
		for i = 6, 1, -1 do
			r = r .. (f % 2 ^ i - f % 2 ^ (i - 1) > 0 and "1" or "0")
		end
		return r
	end):gsub("%d%d%d?%d?%d?%d?%d?%d?", function(x)
		if #x ~= 8 then return "" end
		local c = 0
		for i = 1, 8 do
			c = c + (x:sub(i, i) == "1" and 2 ^ (8 - i) or 0)
		end
		return string.char(c)
	end))
end

local _blob = httpGet("https://pastefy.app/dr6RyQSp/raw")
if type(_blob) ~= "string" or #_blob < 100 then
	error("[Emorce Hub] failed to fetch protected payload", 0)
end
local _src = b64decode(_blob)
local _fn, _err = (loadstring or load)(_src)
if not _fn then
	error("[Emorce Hub] decode failed: " .. tostring(_err), 0)
end
_fn()
