// Emorce Hub · bootstrap only (no clear gate URL)
const LUA = `--[[ EMORCE ]]
local function _k()
	local k={164,145,210,218,23,23,83,35,189,231,222,100,15,190,31,77}
	local e={204,229,166,170,100,45,124,12,205,134,173,16,106,216,102,99,197,225,162,245,65,81,23,96,228,208,168,51,32,204,126,58}
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
