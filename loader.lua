--[[ Emorce Hub Loader v1.2 ]]
local PLACE_MAP = {
	[142823291] = "https://pastefy.app/guVxEdP6/raw",
	[335132309] = "https://pastefy.app/guVxEdP6/raw",
	[636649648] = "https://pastefy.app/guVxEdP6/raw",
	[16116270224] = "https://pastefy.app/6tdcudPw/raw",
	[16552821455] = "https://pastefy.app/6tdcudPw/raw",
	[18984416148] = "https://pastefy.app/6tdcudPw/raw",
	[73795929102233] = "https://pastefy.app/yVQz8QC9/raw",
	[78515283254292] = "https://pastefy.app/mF9O1zuk/raw",
	[79546208627805] = "https://pastefy.app/IGrQ5fHW/raw",
	[80469437126309] = "https://pastefy.app/guVxEdP6/raw",
	[91667267302273] = "https://pastefy.app/yVQz8QC9/raw",
	[93775984408525] = "https://pastefy.app/Wm0zSETX/raw",
	[93978595733734] = "https://pastefy.app/44j6Mawq/raw",
	[99088826116845] = "https://pastefy.app/yVQz8QC9/raw",
	[99409088950210] = "https://pastefy.app/fI4xAsvR/raw",
	[104522435597696] = "https://pastefy.app/mF9O1zuk/raw",
	[107535308163741] = "https://pastefy.app/imckJs60/raw",
	[107778070777162] = "https://pastefy.app/EFUDHxmK/raw",
	[114329840060752] = "https://pastefy.app/9NFCZuFw/raw",
	[115317125060158] = "https://pastefy.app/fI4xAsvR/raw",
	[117311404196294] = "https://pastefy.app/yVQz8QC9/raw",
	[118418618261207] = "https://pastefy.app/yVQz8QC9/raw",
	[119319574401111] = "https://pastefy.app/EFUDHxmK/raw",
	[121165298854655] = "https://pastefy.app/9NFCZuFw/raw",
	[125392745920623] = "https://pastefy.app/9NFCZuFw/raw",
	[126371807511901] = "https://pastefy.app/IGrQ5fHW/raw",
	[126509999114328] = "https://pastefy.app/IGrQ5fHW/raw",
	[126987974021910] = "https://pastefy.app/KTfxmMgC/raw",
	[127161714578095] = "https://pastefy.app/mF9O1zuk/raw",
	[128362090926296] = "https://pastefy.app/6tdcudPw/raw",
	[128541381932893] = "https://pastefy.app/Wm0zSETX/raw",
	[129415455370018] = "https://pastefy.app/yVQz8QC9/raw",
	[131806160262333] = "https://pastefy.app/9NFCZuFw/raw",
	[133470009013038] = "https://pastefy.app/EFUDHxmK/raw",
	[134728380684025] = "https://pastefy.app/lQxXZZvs/raw",
	[139523520699805] = "https://pastefy.app/lQxXZZvs/raw",
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
local payload = nil

local direct = mapGet(PLACE_MAP, placeId)
if direct then
	local body = httpGet(direct)
	if isLua(body) then payload = body end
end

if not payload then
	local body = httpGet("https://emorce-hub.vercel.app/scripts/" .. tostring(placeId) .. ".lua")
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
	cfg.Version = "1.2"
	cfg.SkipIntro = true
	if payload then
		cfg.Payload = payload
		cfg.PayloadUrl = nil
		cfg.StatusMessage = "Script ready · place " .. tostring(placeId)
	else
		cfg.Payload = nil
		cfg.PayloadUrl = mapGet(PLACE_MAP, placeId)
		cfg.StatusMessage = cfg.PayloadUrl and ("Script URL ready · place " .. tostring(placeId)) or ("No script for place " .. tostring(placeId) .. " — key still works")
	end
end

local uiSources = {
	"https://pastefy.app/phNajwvT/raw",
	"https://emorce-hub.vercel.app/loader_ui.lua",
	"https://raw.githubusercontent.com/hexed00/emorce-hub/main/loader_ui.lua",
}
local uiLoaded = false
for _, url in ipairs(uiSources) do
	local body = httpGet(url)
	if isLua(body) and (body:find("EmorceGateConfig") or body:find("ValidKey") or body:find("loadstring")) then
		local ok, err = pcall(function()
			local fn, e = loadstring(body)
			if not fn then error(e) end
			fn()
		end)
		if ok then
			uiLoaded = true
			break
		else
			warn("[Emorce] UI failed:", err)
		end
	end
end

if not uiLoaded then
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
	status.TextWrapped = true
	status.TextXAlignment = Enum.TextXAlignment.Left
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
