--[[
  Emorce Hub Loader
  Key: demorce22
  Loads /scripts/<PlaceId>.lua from SITE_BASE after unlock
]]

local SITE_BASE = (function()
	local ok, custom = pcall(function()
		return type(getgenv) == "function" and getgenv().EmorceSiteBase or nil
	end)
	if ok and type(custom) == "string" and custom ~= "" then
		return custom:gsub("/+$", "")
	end
	return "https://emorce-hub.vercel.app"
end)()

local PlaceId = game.PlaceId

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
	return type(body) == "string" and #body > 80
		and not body:match("^%s*<!DOCTYPE")
		and not body:match("^%s*<html")
		and not body:match("NOT_FOUND")
end

local scriptUrl = string.format("%s/scripts/%s.lua", SITE_BASE, tostring(PlaceId))
local githubRaw = "https://raw.githubusercontent.com/hexed00/emorce-hub/main/scripts/" .. tostring(PlaceId) .. ".lua"
local jsdelivr = "https://cdn.jsdelivr.net/gh/hexed00/emorce-hub@main/scripts/" .. tostring(PlaceId) .. ".lua"

local payload = nil
for _, url in ipairs({ scriptUrl, githubRaw, jsdelivr }) do
	local body = httpGet(url)
	if isLua(body) then
		payload = body
		break
	end
end

local VALID_KEY = "demorce22"

if type(getgenv) == "function" then
	getgenv().EmorceGateConfig = getgenv().EmorceGateConfig or {}
	local cfg = getgenv().EmorceGateConfig
	cfg.ValidKey = VALID_KEY
	cfg.HubName = "Emorce Hub"
	cfg.Maker = "Emorce"
	cfg.Support = "Axion"
	cfg.KeyLink = SITE_BASE .. "/"
	cfg.Payload = payload
	if not payload then
		cfg.StatusMessage = "No script for this place yet — key still works"
	else
		cfg.StatusMessage = "Key unlocks the script for this game"
	end
end

-- Minimal gate UI
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local old = PlayerGui:FindFirstChild("EmorceHubGate")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "EmorceHubGate"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(340, 180)
frame.Position = UDim2.fromScale(0.5, 0.5)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(20, 16, 28)
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
title.TextColor3 = Color3.fromRGB(255, 143, 214)
title.Text = "Emorce Hub"
title.Parent = frame

local status = Instance.new("TextLabel")
status.BackgroundTransparency = 1
status.Size = UDim2.new(1, -24, 0, 20)
status.Position = UDim2.fromOffset(12, 42)
status.Font = Enum.Font.Gotham
status.TextSize = 12
status.TextXAlignment = Enum.TextXAlignment.Left
status.TextColor3 = Color3.fromRGB(180, 170, 190)
status.Text = payload and "Enter key to load this game's script" or "No script for this PlaceId yet"
status.Parent = frame

local box = Instance.new("TextBox")
box.Size = UDim2.new(1, -24, 0, 34)
box.Position = UDim2.fromOffset(12, 72)
box.BackgroundColor3 = Color3.fromRGB(32, 26, 44)
box.BorderSizePixel = 0
box.Font = Enum.Font.Gotham
box.TextSize = 14
box.TextColor3 = Color3.fromRGB(255, 255, 255)
box.PlaceholderText = "key"
box.Text = ""
box.ClearTextOnFocus = false
box.Parent = frame
Instance.new("UICorner", box).CornerRadius = UDim.new(0, 8)

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(1, -24, 0, 36)
btn.Position = UDim2.fromOffset(12, 118)
btn.BackgroundColor3 = Color3.fromRGB(255, 112, 188)
btn.BorderSizePixel = 0
btn.Font = Enum.Font.GothamBold
btn.TextSize = 14
btn.TextColor3 = Color3.fromRGB(40, 10, 28)
btn.Text = "Unlock"
btn.Parent = frame
Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

local function unlock()
	local key = tostring(box.Text or ""):gsub("^%s+", ""):gsub("%s+$", "")
	if key ~= VALID_KEY then
		status.Text = "Wrong key"
		status.TextColor3 = Color3.fromRGB(255, 90, 90)
		return
	end
	status.Text = "Unlocked"
	status.TextColor3 = Color3.fromRGB(120, 255, 160)
	if type(payload) == "string" and #payload > 80 then
		local ok, err = pcall(function()
			local fn, compileErr = loadstring(payload)
			if not fn then error(compileErr or "compile failed") end
			fn()
		end)
		if not ok then
			status.Text = "Script error: " .. tostring(err):sub(1, 80)
			status.TextColor3 = Color3.fromRGB(255, 90, 90)
			return
		end
	end
	task.delay(0.35, function()
		if gui then gui:Destroy() end
	end)
end

btn.MouseButton1Click:Connect(unlock)
box.FocusLost:Connect(function(enter)
	if enter then unlock() end
end)
