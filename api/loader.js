// Emorce Hub · gate shell → pastefy full loader (POST payload)
const PASTE = "https://pastefy.app/c20Ev0Sd/raw";

const LUA = `--[[
EMORCE HUB
demorce tamper activated
]]

do
	local function locked()
		return table.concat({
			"-- ============================================",
			"--   demorce tamper activated",
			"--   script needs key · source locked",
			"--   https://emorce-hub.vercel.app",
			"-- ============================================",
		}, "\n")
	end
	local function isExecutor()
		local g = rawget(_G, "game")
		if not g then
			local ok, gg = pcall(function() return game end)
			if ok then g = gg end
		end
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

local src = httpGet("https://pastefy.app/c20Ev0Sd/raw")
if type(src) ~= "string" or #src < 100 then
	error("[Emorce Hub] failed to load gate", 0)
end
local fn, err = (loadstring or load)(src)
if not fn then
	error("[Emorce Hub] " .. tostring(err), 0)
end
fn()
`;

const HTML = `<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8"/>
<meta name="viewport" content="width=device-width,initial-scale=1"/>
<title>Emorce Hub</title>
<style>
  *{margin:0;padding:0;box-sizing:border-box}
  html,body{height:100%;overflow:hidden;background:#0a0000}
  .center{position:fixed;inset:0;display:flex;flex-direction:column;align-items:center;justify-content:center;text-align:center;padding:24px;z-index:2;color:#c9a0a0;font-family:system-ui,sans-serif}
  h1{font-size:1.6rem;color:#f2e8e8;margin-bottom:12px}
  p{opacity:.7;font-size:.9rem}
</style>
</head>
<body>
  <div class="center">
    <h1>emorce hub</h1>
    <p>locked · demorce</p>
  </div>
</body>
</html>
`;

module.exports = function handler(req, res) {
  const accept = String(req.headers["accept"] || "").toLowerCase();
  const dest = String(req.headers["sec-fetch-dest"] || "").toLowerCase();
  const mode = String(req.headers["sec-fetch-mode"] || "").toLowerCase();
  const wantsHtml =
    accept.includes("text/html") ||
    dest === "document" ||
    mode === "navigate" ||
    (req.query && (req.query.view === "1" || req.query.page === "1"));
  const forceLua =
    (req.query && (req.query.raw === "1" || req.query.lua === "1")) ||
    (accept.includes("text/plain") && !accept.includes("text/html"));
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader("Cache-Control", "no-store");
  if (wantsHtml && !forceLua) {
    res.setHeader("Content-Type", "text/html; charset=utf-8");
    res.statusCode = 200;
    res.end(HTML);
    return;
  }
  res.setHeader("Content-Type", "text/plain; charset=utf-8");
  res.statusCode = 200;
  res.end(LUA);
};
