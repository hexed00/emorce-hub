--[[ Emorce Hub Loader ]]
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
local VALID_KEY = "demorce22"

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
	if body:find("NOT_FOUND") then return false end
	if body:match("^%s*404") then return false end
	if body:find("placeholder") then return false end
	if body:find("Emorce Hub bootstrap") then return false end
	if body:find("pending full upload") then return false end
	return true
end

local urls = {}
if PLACE_MAP[PlaceId] then
	urls[#urls + 1] = PLACE_MAP[PlaceId]
end
urls[#urls + 1] = string.format("%s/scripts/%s.lua", SITE_BASE, tostring(PlaceId))
urls[#urls + 1] = "https://raw.githubusercontent.com/hexed00/emorce-hub/main/scripts/" .. tostring(PlaceId) .. ".lua"

local payload = nil
for _, url in ipairs(urls) do
	local body = httpGet(url)
	if isLua(body) then
		payload = body
		break
	end
end

local Players = game:GetService("Players")
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
frame.Size = UDim2.fromOffset(360, 190)
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
status.Size = UDim2.new(1, -24, 0, 36)
status.Position = UDim2.fromOffset(12, 42)
status.Font = Enum.Font.Gotham
status.TextSize = 12
status.TextXAlignment = Enum.TextXAlignment.Left
status.TextYAlignment = Enum.TextYAlignment.Top
status.TextWrapped = true
status.TextColor3 = Color3.fromRGB(180, 170, 190)
status.Text = payload and ("Script ready · place " .. tostring(PlaceId)) or ("No script for place " .. tostring(PlaceId))
status.Parent = frame

local box = Instance.new("TextBox")
box.Size = UDim2.new(1, -24, 0, 34)
box.Position = UDim2.fromOffset(12, 84)
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
btn.Position = UDim2.fromOffset(12, 130)
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
	if not payload then
		status.Text = "Key ok — no script for this place yet"
		status.TextColor3 = Color3.fromRGB(255, 200, 120)
		return
	end
	status.Text = "Loading..."
	status.TextColor3 = Color3.fromRGB(120, 255, 160)
	local ok, err = pcall(function()
		local fn, compileErr = loadstring(payload)
		if not fn then error(compileErr or "compile failed") end
		fn()
	end)
	if not ok then
		status.Text = "Script error: " .. tostring(err):sub(1, 120)
		status.TextColor3 = Color3.fromRGB(255, 90, 90)
		return
	end
	task.delay(0.15, function()
		if gui then gui:Destroy() end
	end)
end

btn.MouseButton1Click:Connect(unlock)
box.FocusLost:Connect(function(enter)
	if enter then unlock() end
end)
