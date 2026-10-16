--[[ Emorce Hub Loader v1.4 ]]
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

local MIRRORS = {
	[142823291] = {
		"https://pastefy.app/wZLWmV0n/raw",
		"https://pastefy.app/guVxEdP6/raw",
	},
}

local VALID_KEY = "demorce22"
local placeId = game.PlaceId

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

local function fetchScript(id)
	local urls = {}
	local mirrors = mapGet(MIRRORS, id)
	if type(mirrors) == "table" then
		for _, u in ipairs(mirrors) do urls[#urls+1] = u end
	end
	local primary = mapGet(PLACE_MAP, id)
	if primary then urls[#urls+1] = primary end
	urls[#urls+1] = "https://emorce-hub.vercel.app/scripts/" .. tostring(id) .. ".lua"
	for _, url in ipairs(urls) do
		local body = httpGet(url)
		if isLua(body) then
			return body, url
		end
	end
	return nil, nil
end

local preBody, preUrl = fetchScript(placeId)

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
frame.Size = UDim2.fromOffset(380, 210)
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
status.Size = UDim2.new(1, -24, 0, 48)
status.Position = UDim2.fromOffset(12, 42)
status.Font = Enum.Font.Gotham
status.TextSize = 12
status.TextWrapped = true
status.TextXAlignment = Enum.TextXAlignment.Left
status.TextYAlignment = Enum.TextYAlignment.Top
status.TextColor3 = Color3.fromRGB(180, 160, 165)
if preBody then
	status.Text = "Script ready · place " .. tostring(placeId) .. "\nEnter key and press Unlock"
else
	status.Text = "No script found for place " .. tostring(placeId)
end
status.Parent = frame

local box = Instance.new("TextBox")
box.Size = UDim2.new(1, -24, 0, 34)
box.Position = UDim2.fromOffset(12, 98)
box.BackgroundColor3 = Color3.fromRGB(20, 10, 10)
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
btn.Size = UDim2.new(1, -24, 0, 40)
btn.Position = UDim2.fromOffset(12, 144)
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
	if key ~= VALID_KEY:upper() then
		status.Text = "Wrong key"
		status.TextColor3 = Color3.fromRGB(255, 120, 140)
		return
	end
	status.Text = "Fetching script for place " .. tostring(placeId) .. "..."
	status.TextColor3 = Color3.fromRGB(200, 200, 210)
	btn.Text = "Loading..."
	task.spawn(function()
		local body, url = fetchScript(placeId)
		if not body then
			status.Text = "Key ok — script missing for place " .. tostring(placeId)
			status.TextColor3 = Color3.fromRGB(255, 200, 120)
			btn.Text = "Unlock"
			return
		end
		status.Text = "Running script..."
		status.TextColor3 = Color3.fromRGB(120, 220, 160)
		local ok, err = pcall(function()
			local fn, compileErr = loadstring(body)
			if not fn then
				error(compileErr or "compile failed")
			end
			fn()
		end)
		if not ok then
			status.Text = "Script error: " .. tostring(err):sub(1, 140)
			status.TextColor3 = Color3.fromRGB(255, 120, 140)
			btn.Text = "Unlock"
			warn("[Emorce Hub] load failed from", url, err)
			return
		end
		task.delay(0.2, function()
			if gui then gui:Destroy() end
		end)
	end)
end

btn.MouseButton1Click:Connect(unlock)
box.FocusLost:Connect(function(enter)
	if enter then unlock() end
end)
