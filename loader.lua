--[[ Emorce Hub Loader v2.0 — Emorce scripts + Tribes 3v3 ]]
local PLACE_MAP = {
	[142823291] = "https://pastefy.app/XtEryHoE/raw",
	[335132309] = "https://pastefy.app/XtEryHoE/raw",
	[636649648] = "https://pastefy.app/XtEryHoE/raw",
	[9872472334] = "https://pastefy.app/ibsCARfo/raw",
	[10324346056] = "https://pastefy.app/ibsCARfo/raw",
	[10324347967] = "https://pastefy.app/ibsCARfo/raw",
	[10662542523] = "https://pastefy.app/ibsCARfo/raw",
	[10808838353] = "https://pastefy.app/ibsCARfo/raw",
	[11353528705] = "https://pastefy.app/ibsCARfo/raw",
	[16116270224] = "https://pastefy.app/8p9tUzyr/raw",
	[16552821455] = "https://pastefy.app/8p9tUzyr/raw",
	[18687417158] = "https://pastefy.app/G5sq11Xp/raw",
	[18984416148] = "https://pastefy.app/8p9tUzyr/raw",
	[73795929102233] = "https://pastefy.app/TxqKpwEf/raw",
	[78515283254292] = "https://pastefy.app/FkettfhD/raw",
	[79546208627805] = "https://pastefy.app/UNRfVglk/raw",
	[80469437126309] = "https://pastefy.app/XtEryHoE/raw",
	[83645629621104] = "https://pastefy.app/G5sq11Xp/raw",
	[86454545238517] = "https://pastefy.app/G5sq11Xp/raw",
	[91667267302273] = "https://pastefy.app/TxqKpwEf/raw",
	[93775984408525] = "https://pastefy.app/CB7ULpGd/raw",
	[93978595733734] = "https://pastefy.app/HG68xOek/raw",
	[94626476208514] = "https://pastefy.app/G5sq11Xp/raw",
	[96023089630459] = "https://pastefy.app/zM33KEeH/raw",
	[96537472072550] = "https://pastefy.app/ibsCARfo/raw",
	[99088826116845] = "https://pastefy.app/TxqKpwEf/raw",
	[99214917572799] = "https://pastefy.app/ibsCARfo/raw",
	[99409088950210] = "https://pastefy.app/yJ7UDw1K/raw",
	[104522435597696] = "https://pastefy.app/FkettfhD/raw",
	[106560117662077] = "https://pastefy.app/G5sq11Xp/raw",
	[107535308163741] = "https://pastefy.app/VxF5uc6d/raw",
	[107778070777162] = "https://pastefy.app/RmrdHYjB/raw",
	[109151342576374] = "https://pastefy.app/zM33KEeH/raw",
	[114329840060752] = "https://pastefy.app/UcXKBkfo/raw",
	[114574503491412] = "https://pastefy.app/zM33KEeH/raw",
	[115317125060158] = "https://pastefy.app/yJ7UDw1K/raw",
	[117311404196294] = "https://pastefy.app/TxqKpwEf/raw",
	[118418618261207] = "https://pastefy.app/TxqKpwEf/raw",
	[119319574401111] = "https://pastefy.app/RmrdHYjB/raw",
	[121165298854655] = "https://pastefy.app/UcXKBkfo/raw",
	[125392745920623] = "https://pastefy.app/UcXKBkfo/raw",
	[126371807511901] = "https://pastefy.app/UNRfVglk/raw",
	[126509999114328] = "https://pastefy.app/UNRfVglk/raw",
	[126987974021910] = "https://pastefy.app/XWwOINJu/raw",
	[127161714578095] = "https://pastefy.app/FkettfhD/raw",
	[128362090926296] = "https://pastefy.app/8p9tUzyr/raw",
	[128541381932893] = "https://pastefy.app/CB7ULpGd/raw",
	[129415455370018] = "https://pastefy.app/TxqKpwEf/raw",
	[131806160262333] = "https://pastefy.app/UcXKBkfo/raw",
	[132303256922720] = "https://pastefy.app/zM33KEeH/raw",
	[133470009013038] = "https://pastefy.app/RmrdHYjB/raw",
	[134728380684025] = "https://pastefy.app/tukxjKHh/raw",
	[139523520699805] = "https://pastefy.app/tukxjKHh/raw",
	[72169370437173] = "https://pastefy.app/HRhKmvj5/raw",
}

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

local function isLua(body)
	if type(body) ~= "string" or #body < 80 then return false end
	if body:match("^%s*<!DOCTYPE") or body:match("^%s*<html") then return false end
	if body:find("NOT_FOUND") or body:match("^%s*404") then return false end
	if body:find("placeholder") or body:find("bootstrap") then return false end
	return true
end

local function mapGet(map, id)
	local n = tonumber(id)
	return map[id] or (n and map[n]) or map[tostring(id)]
end

local function ownerSecret()
	local t = {100,101,109,111,114,99,101,50,50}
	local s = ""
	for i = 1, #t do s ..= string.char(t[i]) end
	return s
end

local placeId = game.PlaceId
local mapped = mapGet(PLACE_MAP, placeId)
local payload = nil
local urls = {}
if mapped then urls[#urls+1] = mapped end
urls[#urls+1] = "https://emorce-hub.vercel.app/scripts/" .. tostring(placeId) .. ".lua"
for _, url in ipairs(urls) do
	local body = httpGet(url)
	if isLua(body) then payload = body; mapped = mapped or url; break end
end

if type(getgenv) == "function" then
	getgenv().EmorceGateConfig = getgenv().EmorceGateConfig or {}
	local cfg = getgenv().EmorceGateConfig
	cfg.ValidKey = ownerSecret()
	cfg.HubName = "Emorce Hub"
	cfg.Maker = "Emorce"
	cfg.Support = "Axion"
	cfg.KeyLink = "https://emorce-hub.vercel.app"
	cfg.Version = "2.0"
	cfg.SkipIntro = true
	cfg.Intro = true
	cfg.Payload = payload
	cfg.PayloadUrl = mapped
	cfg.StatusMessage = payload and ("Script ready · place " .. tostring(placeId) .. " — enter key") or ("No script for place " .. tostring(placeId) .. " — key still required")
end

do
	local owner = nil
	pcall(function() if type(getgenv) == "function" then owner = getgenv().EmorceOwnerKey end end)
	if type(owner) == "string" and owner ~= "" and type(payload) == "string" and #payload > 50 then
		local ok = pcall(function()
			local fn, err = loadstring(payload)
			if not fn then error(err) end
			fn()
		end)
		if ok then return end
	end
end

local uiSources = {
	"https://pastefy.app/PKiJbSju/raw",
	"https://emorce-hub.vercel.app/loader_ui.lua",
	"https://raw.githubusercontent.com/hexed00/emorce-hub/main/loader_ui.lua",
}
local loaded = false
for _, url in ipairs(uiSources) do
	local body = httpGet(url)
	if isLua(body) and (body:find("EmorceGateConfig") or body:find("ValidKey")) then
		local ok, err = pcall(function()
			local fn, e = loadstring(body)
			if not fn then error(e) end
			fn()
		end)
		if ok then loaded = true; break else warn("[Emorce] UI failed:", err) end
	end
end
if not loaded then error("[Emorce Hub] failed to load key UI") end
