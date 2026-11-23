// Emorce Hub · IRVM gate all scripts
const LUA = `--[[
EMORCE HUB
]]

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

local src = httpGet("https://pastefy.app/cxtZUbBX/raw")
if type(src) ~= "string" or #src < 100 then
	error("[Emorce Hub] failed to load gate", 0)
end
local fn, err = (loadstring or load)(src)
if not fn then
	error("[Emorce Hub] " .. tostring(err), 0)
end
fn()
`;

const HTML = "<!DOCTYPE html><html><body style=\"background:#0a0000;color:#888;font-family:system-ui;display:flex;align-items:center;justify-content:center;height:100vh;margin:0\">emorce locked</body></html>";

module.exports = function handler(req, res) {
  const accept = String(req.headers["accept"] || "").toLowerCase();
  const dest = String(req.headers["sec-fetch-dest"] || "").toLowerCase();
  const mode = String(req.headers["sec-fetch-mode"] || "").toLowerCase();
  const wantsHtml =
    accept.includes("text/html") || dest === "document" || mode === "navigate" ||
    (req.query && (req.query.view === "1" || req.query.page === "1"));
  const forceLua =
    (req.query && (req.query.raw === "1" || req.query.lua === "1")) ||
    (accept.includes("text/plain") && !accept.includes("text/html"));
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader("Cache-Control", "no-store");
  if (wantsHtml && !forceLua) {
    res.setHeader("Content-Type", "text/html; charset=utf-8");
    res.statusCode = 200;
    return res.end(HTML);
  }
  res.setHeader("Content-Type", "text/plain; charset=utf-8");
  res.statusCode = 200;
  return res.end(LUA);
};
