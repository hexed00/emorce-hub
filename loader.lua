--[[
	Emorce Hub Loader
	loadstring(game:HttpGet("https://emorce-hub.vercel.app/loader.lua"))()
]]

local PLACE_MAP = {
	[142823291] = "https://pastefy.app/Pcs2bHJ1/raw",
	[286090429] = "https://pastefy.app/xyFVtiLw/raw",
	[443406476] = "https://pastefy.app/ycXDjtP7/raw",
	[3039388345] = "https://pastefy.app/kZdwtnDg/raw",
	[4581966615] = "https://pastefy.app/c5PU0J0x/raw",
	[6961824067] = "https://pastefy.app/o2DHqeze/raw",
	[9872472334] = "https://pastefy.app/LKJu0oE4/raw",
	[16116270224] = "https://pastefy.app/EGrVlSk3/raw",
	[18687417158] = "https://pastefy.app/96YhN5Cc/raw",
	[72169370437173] = "https://pastefy.app/Wg9c2C3y/raw",
	[78515283254292] = "https://pastefy.app/Qqc7JDP7/raw",
	[79546208627805] = "https://pastefy.app/JTObpz5h/raw",
	[93978595733734] = "https://pastefy.app/Jam9PaKr/raw",
	[94217045453265] = "https://pastefy.app/AoOaosRa/raw",
	[99409088950210] = "https://pastefy.app/jzmszac3/raw",
	[107535308163741] = "https://pastefy.app/SGrUamvR/raw",
	[107778070777162] = "https://pastefy.app/bjuph9bP/raw",
	[114574503491412] = "https://pastefy.app/g9pTru53/raw",
	[118418618261207] = "https://pastefy.app/hCxamXEd/raw",
	[121165298854655] = "https://pastefy.app/AaoPFFZ7/raw",
	[126987974021910] = "https://pastefy.app/lhfSSVfK/raw",
	[128541381932893] = "https://pastefy.app/8tA29hF0/raw",
	[134728380684025] = "https://pastefy.app/vho0C1bT/raw",
}

local function mapGet(map, id)
	if map[id] then return map[id] end
	local s = tostring(id)
	for k, v in pairs(map) do
		if tostring(k) == s then return v end
	end
	return nil
end

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

local placeId = game.PlaceId
local url = mapGet(PLACE_MAP, placeId)
if not url then
	warn("[Emorce Hub] no script for place " .. tostring(placeId))
	pcall(function()
		game:GetService("StarterGui"):SetCore("SendNotification", {
			Title = "Emorce Hub",
			Text = "No payload for this game (" .. tostring(placeId) .. ")",
			Duration = 6,
		})
	end)
	return
end

local src = httpGet(url)
if type(src) ~= "string" or #src < 50 then
	error("[Emorce Hub] failed to fetch game payload", 0)
end

local fn, err = (loadstring or load)(src)
if not fn then
	error("[Emorce Hub] compile failed: " .. tostring(err), 0)
end
fn()
