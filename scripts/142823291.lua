-- Emorce Hub bootstrap for place 142823291
local SITE = "https://raw.githubusercontent.com/hexed00/emorce-hub/main/"
local n = 3
local buf = {}
for i = 0, n - 1 do
  local url = SITE .. "scripts/parts/142823291." .. i .. ".txt"
  local body
  local ok = pcall(function()
    if type(syn) == "table" and syn.request then
      body = syn.request({Url=url,Method="GET"}).Body
    elseif type(http_request) == "function" then
      body = http_request({Url=url,Method="GET"}).Body
    else
      body = game:HttpGet(url)
    end
  end)
  if not ok or type(body) ~= "string" then error("part fail "..tostring(i)) end
  buf[#buf+1] = body
end
local src = table.concat(buf)
local fn, err = loadstring(src)
if not fn then error(err) end
fn()
