--[[ Emorce Hub Loader v1.5 — Bunny UI ]]
local PLACE_MAP = {
	[142823291] = "https://pastefy.app/wZLWmV0n/raw",
	[335132309] = "https://pastefy.app/wZLWmV0n/raw",
	[636649648] = "https://pastefy.app/wZLWmV0n/raw",
	[80469437126309] = "https://pastefy.app/wZLWmV0n/raw",
	[16116270224] = "https://pastefy.app/6tdcudPw/raw",
	[16552821455] = "https://pastefy.app/6tdcudPw/raw",
	[18984416148] = "https://pastefy.app/6tdcudPw/raw",
	[128362090926296] = "https://pastefy.app/6tdcudPw/raw",
	[128541381932893] = "https://pastefy.app/Wm0zSETX/raw",
	[93775984408525] = "https://pastefy.app/Wm0zSETX/raw",
	[107535308163741] = "https://pastefy.app/imckJs60/raw",
	[121165298854655] = "https://pastefy.app/9NFCZuFw/raw",
	[114329840060752] = "https://pastefy.app/9NFCZuFw/raw",
	[125392745920623] = "https://pastefy.app/9NFCZuFw/raw",
	[131806160262333] = "https://pastefy.app/9NFCZuFw/raw",
	[93978595733734] = "https://pastefy.app/44j6Mawq/raw",
	[126987974021910] = "https://pastefy.app/KTfxmMgC/raw",
	[78515283254292] = "https://pastefy.app/mF9O1zuk/raw",
	[104522435597696] = "https://pastefy.app/mF9O1zuk/raw",
	[127161714578095] = "https://pastefy.app/mF9O1zuk/raw",
	[79546208627805] = "https://pastefy.app/IGrQ5fHW/raw",
	[126371807511901] = "https://pastefy.app/IGrQ5fHW/raw",
	[126509999114328] = "https://pastefy.app/IGrQ5fHW/raw",
	[107778070777162] = "https://pastefy.app/EFUDHxmK/raw",
	[119319574401111] = "https://pastefy.app/EFUDHxmK/raw",
	[133470009013038] = "https://pastefy.app/EFUDHxmK/raw",
	[99409088950210] = "https://pastefy.app/fI4xAsvR/raw",
	[115317125060158] = "https://pastefy.app/fI4xAsvR/raw",
	[134728380684025] = "https://pastefy.app/lQxXZZvs/raw",
	[139523520699805] = "https://pastefy.app/lQxXZZvs/raw",
	[118418618261207] = "https://pastefy.app/yVQz8QC9/raw",
	[73795929102233] = "https://pastefy.app/yVQz8QC9/raw",
	[91667267302273] = "https://pastefy.app/yVQz8QC9/raw",
	[99088826116845] = "https://pastefy.app/yVQz8QC9/raw",
	[117311404196294] = "https://pastefy.app/yVQz8QC9/raw",
	[129415455370018] = "https://pastefy.app/yVQz8QC9/raw",
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

local placeId = game.PlaceId
local mapped = mapGet(PLACE_MAP, placeId)
local payload = nil

local urls = {}
if mapped then urls[#urls+1] = mapped end
if placeId == 142823291 or placeId == 335132309 or placeId == 636649648 or placeId == 80469437126309 then
	urls[#urls+1] = "https://pastefy.app/guVxEdP6/raw"
	urls[#urls+1] = "https://pastefy.app/wZLWmV0n/raw"
end
urls[#urls+1] = "https://emorce-hub.vercel.app/scripts/" .. tostring(placeId) .. ".lua"

for _, url in ipairs(urls) do
	local body = httpGet(url)
	if isLua(body) then
		payload = body
		mapped = mapped or url
		break
	end
end

if type(getgenv) == "function" then
	getgenv().EmorceGateConfig = getgenv().EmorceGateConfig or {}
	local cfg = getgenv().EmorceGateConfig
	cfg.ValidKey = "demorce22"
	cfg.HubName = "Emorce Hub"
	cfg.Maker = "Emorce"
	cfg.Support = "Axion"
	cfg.KeyLink = "https://emorce-hub.vercel.app"
	cfg.Version = "1.5"
	cfg.SkipIntro = true
	cfg.Intro = true
	cfg.Payload = payload
	cfg.PayloadUrl = mapped
	if payload then
		cfg.StatusMessage = "Script ready · place " .. tostring(placeId) .. " — enter key"
	else
		cfg.StatusMessage = "No script for place " .. tostring(placeId) .. " — key still required"
	end
end

local uiSources = {
	"https://pastefy.app/xl5b1IqT/raw",
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
		if ok then
			loaded = true
			break
		else
			warn("[Emorce] Bunny UI failed:", err)
		end
	end
end

if not loaded then
	error("[Emorce Hub] failed to load key UI")
end
