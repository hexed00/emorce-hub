--[[
  Emorce Hub — site loader
  Uses Emorce Bunny-style key gate + per-place payload from Pastefy
]]

local PLACE_MAP = {
	[107535308163741] = "https://pastefy.app/imckJs60/raw",
	[121165298854655] = "https://pastefy.app/9NFCZuFw/raw",
	[93978595733734] = "https://pastefy.app/44j6Mawq/raw",
	[16116270224] = "https://pastefy.app/6tdcudPw/raw",
	[126987974021910] = "https://pastefy.app/KTfxmMgC/raw",
	[78515283254292] = "https://pastefy.app/mF9O1zuk/raw",
	[79546208627805] = "https://pastefy.app/IGrQ5fHW/raw",
	[107778070777162] = "https://pastefy.app/EFUDHxmK/raw",
	[99409088950210] = "https://pastefy.app/fI4xAsvR/raw",
	[142823291] = "https://pastefy.app/guVxEdP6/raw",
	[134728380684025] = "https://pastefy.app/lQxXZZvs/raw",
	[118418618261207] = "https://pastefy.app/yVQz8QC9/raw",
	[128541381932893] = "https://pastefy.app/Wm0zSETX/raw",
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
	if type(body) ~= "string" or #body < 100 then return false end
	if body:match("^%s*<!DOCTYPE") or body:match("^%s*<html") then return false end
	if body:find("NOT_FOUND") or body:match("^%s*404") then return false end
	if body:find("placeholder") or body:find("bootstrap") then return false end
	return true
end

local placeId = game.PlaceId
local function mapGet(map, id)
	return map[id] or map[tonumber(id)] or map[tostring(id)]
end

local payload = nil
local direct = mapGet(PLACE_MAP, placeId)
if direct then
	local body = httpGet(direct)
	if isLua(body) then payload = body end
end

if not payload then
	local body = httpGet(string.format("https://emorce-hub.vercel.app/scripts/%s.lua", tostring(placeId)))
	if isLua(body) then payload = body end
end

if not payload then
	local body = httpGet("https://raw.githubusercontent.com/hexed00/emorce-hub/main/scripts/" .. tostring(placeId) .. ".lua")
	if isLua(body) then payload = body end
end

if type(getgenv) == "function" then
	getgenv().EmorceGateConfig = getgenv().EmorceGateConfig or {}
	local cfg = getgenv().EmorceGateConfig
	cfg.ValidKey = "demorce22"
	cfg.HubName = "Emorce Hub"
	cfg.Maker = "Emorce"
	cfg.Support = "Axion"
	cfg.KeyLink = "https://emorce-hub.vercel.app"
	cfg.Version = "1.1"
	cfg.SkipIntro = true
	if payload then
		cfg.Payload = payload
		cfg.StatusMessage = "Script ready for this game · place " .. tostring(placeId)
	else
		cfg.Payload = nil
		cfg.StatusMessage = "No script mapped for place " .. tostring(placeId) .. " — key still works"
	end
end

-- Inline compact gate if full UI missing from this push; full Bunny UI loaded from site when available
local function runCompactGate()
	local Players = game:GetService("Players")
	local LocalPlayer = Players.LocalPlayer
	local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
	local old = PlayerGui:FindFirstChild("EmorceHubGate")
	if old then old:Destroy() end
	local gui = Instance.new("ScreenGui")
	gui.Name = "EmorceHubGate"
	gui.ResetOnSpawn = false
	gui.Parent = PlayerGui
	local frame = Instance.new("Frame")
	frame.Size = UDim2.fromOffset(360, 190)
	frame.Position = UDim2.fromScale(0.5, 0.5)
	frame.AnchorPoint = Vector2.new(0.5, 0.5)
	frame.BackgroundColor3 = Color3.fromRGB(14, 10, 12)
	frame.BorderSizePixel = 0
	frame.Parent = gui
	Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 14)
	local title = Instance.new("TextLabel")
	title.BackgroundTransparency = 1
	title.Size = UDim2.new(1, -24, 0, 28)
	title.Position = UDim2.fromOffset(12, 12)
	title.Font = Enum.Font.GothamBold
	title.TextSize = 18
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.TextColor3 = Color3.fromRGB(255, 50, 70)
	title.Text = "Emorce Hub"
	title.Parent = frame
	local status = Instance.new("TextLabel")
	status.BackgroundTransparency = 1
	status.Size = UDim2.new(1, -24, 0, 40)
	status.Position = UDim2.fromOffset(12, 42)
	status.Font = Enum.Font.Gotham
	status.TextSize = 12
	status.TextXAlignment = Enum.TextXAlignment.Left
	status.TextYAlignment = Enum.TextYAlignment.Top
	status.TextWrapped = true
	status.TextColor3 = Color3.fromRGB(180, 160, 165)
	status.Text = payload and ("Script ready · place " .. tostring(placeId)) or ("No script for place " .. tostring(placeId))
	status.Parent = frame
	local box = Instance.new("TextBox")
	box.Size = UDim2.new(1, -24, 0, 34)
	box.Position = UDim2.fromOffset(12, 88)
	box.BackgroundColor3 = Color3.fromRGB(20, 10, 10)
	box.BorderSizePixel = 0
	box.Font = Enum.Font.Gotham
	box.TextSize = 14
	box.TextColor3 = Color3.fromRGB(255, 255, 255)
	box.PlaceholderText = "key"
	box.Text = ""
	box.Parent = frame
	Instance.new("UICorner", box).CornerRadius = UDim.new(0, 8)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -24, 0, 36)
	btn.Position = UDim2.fromOffset(12, 132)
	btn.BackgroundColor3 = Color3.fromRGB(220, 20, 40)
	btn.BorderSizePixel = 0
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Text = "Unlock"
	btn.Parent = frame
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
	local function unlock()
		local key = tostring(box.Text or ""):gsub("^%s+", ""):gsub("%s+$", ""):upper()
		if key ~= "DEMORCE22" then
			status.Text = "Wrong key"
			status.TextColor3 = Color3.fromRGB(255, 120, 140)
			return
		end
		if not payload then
			status.Text = "Key ok — no script for place " .. tostring(placeId)
			status.TextColor3 = Color3.fromRGB(255, 200, 120)
			return
		end
		status.Text = "Loading..."
		status.TextColor3 = Color3.fromRGB(120, 220, 160)
		local ok, err = pcall(function()
			local fn, e = loadstring(payload)
			if not fn then error(e) end
			fn()
		end)
		if not ok then
			status.Text = "Script error: " .. tostring(err):sub(1, 100)
			status.TextColor3 = Color3.fromRGB(255, 120, 140)
			return
		end
		task.delay(0.15, function() if gui then gui:Destroy() end end)
	end
	btn.MouseButton1Click:Connect(unlock)
	box.FocusLost:Connect(function(enter) if enter then unlock() end end)
end

-- Prefer full Bunny UI from site if present as separate module; else compact
local uiUrl = "https://emorce-hub.vercel.app/loader_ui.lua"
local uiBody = httpGet(uiUrl)
if isLua(uiBody) and uiBody:find("EmorceGateConfig") then
	-- UI will read getgenv().EmorceGateConfig set above
	local ok, err = pcall(function()
		local fn, e = loadstring(uiBody)
		if not fn then error(e) end
		fn()
	end)
	if not ok then
		warn("[Emorce] UI load failed, compact gate:", err)
		runCompactGate()
	end
else
	runCompactGate()
end
