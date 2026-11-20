// Emorce Hub · /loader.lua dual response
// browser → vampiric decoy page | executor → real Lua

const LUA = "--[[\nEMORCE HUB · GET KEY TO SHOW CODE\ndemorce tamper activated · fully locked for browsers / .get / deobf\n]]\n\ndo\n\tlocal function locked()\n\t\treturn table.concat({\n\t\t\t\"-- ============================================\",\n\t\t\t\"--   demorce tamper activated\",\n\t\t\t\"--   script needs key · source locked\",\n\t\t\t\"--   https://emorce-hub.vercel.app\",\n\t\t\t\"-- ============================================\",\n\t\t}, \"\\n\")\n\tend\n\tlocal function isExecutor()\n\t\tlocal g = rawget(_G, \"game\")\n\t\tif not g then\n\t\t\tlocal ok, gg = pcall(function() return game end)\n\t\t\tif ok then g = gg end\n\t\tend\n\t\tif g == nil then return false end\n\t\tif type(loadstring) ~= \"function\" and type(load) ~= \"function\" then return false end\n\t\tlocal ok = pcall(function()\n\t\t\tlocal _ = g.PlaceId\n\t\tend)\n\t\treturn ok\n\tend\n\tif not isExecutor() then\n\t\tlocal msg = locked()\n\t\tif type(print) == \"function\" then pcall(print, msg) end\n\t\treturn (loadstring or load)(msg)\n\tend\nend\n\nlocal function httpGet(url)\n\tlocal body\n\tlocal ok = pcall(function()\n\t\tif type(syn) == \"table\" and type(syn.request) == \"function\" then\n\t\t\tbody = syn.request({ Url = url, Method = \"GET\" }).Body\n\t\telseif type(http_request) == \"function\" then\n\t\t\tbody = http_request({ Url = url, Method = \"GET\" }).Body\n\t\telseif type(request) == \"function\" then\n\t\t\tbody = request({ Url = url, Method = \"GET\" }).Body\n\t\telse\n\t\t\tbody = game:HttpGet(url)\n\t\tend\n\tend)\n\tif not ok then return nil end\n\treturn body\nend\n\nlocal function b64decode(data)\n\tlocal b = \"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/\"\n\tdata = tostring(data or \"\"):gsub(\"%s+\", \"\")\n\treturn (data:gsub(\".\", function(x)\n\t\tif x == \"=\" then return \"\" end\n\t\tlocal r, f = \"\", (b:find(x) - 1)\n\t\tfor i = 6, 1, -1 do\n\t\t\tr = r .. (f % 2 ^ i - f % 2 ^ (i - 1) > 0 and \"1\" or \"0\")\n\t\tend\n\t\treturn r\n\tend):gsub(\"%d%d%d?%d?%d?%d?%d?%d?\", function(x)\n\t\tif #x ~= 8 then return \"\" end\n\t\tlocal c = 0\n\t\tfor i = 1, 8 do\n\t\t\tc = c + (x:sub(i, i) == \"1\" and 2 ^ (8 - i) or 0)\n\t\tend\n\t\treturn string.char(c)\n\tend))\nend\n\nlocal _blob = httpGet(\"https://pastefy.app/eYoDIbY6/raw\")\nif type(_blob) ~= \"string\" or #_blob < 100 then\n\terror(\"[Emorce Hub] failed to fetch protected payload\", 0)\nend\nlocal _src = b64decode(_blob)\nlocal _fn, _err = (loadstring or load)(_src)\nif not _fn then\n\terror(\"[Emorce Hub] decode failed: \" .. tostring(_err), 0)\nend\n_fn()\n";

const HTML = "<!DOCTYPE html>\n<html lang=\"en\">\n<head>\n<meta charset=\"utf-8\"/>\n<meta name=\"viewport\" content=\"width=device-width,initial-scale=1\"/>\n<title>Emorce Hub</title>\n<style>\n  @import url('https://fonts.googleapis.com/css2?family=UnifrakturCook:wght@700&family=Cinzel+Decorative:wght@700&display=swap');\n  *{margin:0;padding:0;box-sizing:border-box}\n  html,body{height:100%;overflow:hidden;background:#0a0000}\n  .bg{\n    position:fixed;inset:0;\n    background:#0a0000 center/cover no-repeat;\n    background-image:linear-gradient(180deg,rgba(8,0,0,.55),rgba(20,0,4,.75)),url('https://i.pinimg.com/736x/b5/52/13/b5521376fe5a685af0aa25fc9f434ac8.jpg');\n    filter:saturate(1.1) contrast(1.05);\n  }\n  .vignette{\n    position:fixed;inset:0;\n    background:radial-gradient(ellipse at center,transparent 30%,rgba(0,0,0,.85) 100%);\n    pointer-events:none;\n  }\n  .blood{\n    position:fixed;inset:0;\n    background:\n      radial-gradient(ellipse 40% 20% at 20% 0%,rgba(120,0,10,.25),transparent 60%),\n      radial-gradient(ellipse 50% 25% at 80% 100%,rgba(80,0,8,.3),transparent 60%);\n    pointer-events:none;\n  }\n  .center{\n    position:fixed;inset:0;\n    display:flex;flex-direction:column;align-items:center;justify-content:center;\n    text-align:center;padding:24px;z-index:2;\n  }\n  h1{\n    font-family:'UnifrakturCook','Cinzel Decorative',serif;\n    font-size:clamp(2.2rem,7vw,4.5rem);\n    color:#f2e8e8;\n    text-shadow:\n      0 0 8px rgba(180,0,20,.9),\n      0 0 24px rgba(120,0,10,.7),\n      0 2px 0 #3a0000,\n      0 4px 12px rgba(0,0,0,.9);\n    letter-spacing:.04em;\n    line-height:1.15;\n    max-width:16ch;\n  }\n  h1 span{color:#c41e3a}\n  .sub{\n    margin-top:1.25rem;\n    font-family:'Cinzel Decorative',serif;\n    font-size:clamp(.75rem,2vw,1rem);\n    color:#c9a0a0;\n    letter-spacing:.35em;\n    text-transform:uppercase;\n    text-shadow:0 0 12px rgba(100,0,10,.6);\n  }\n  .line{\n    width:min(280px,60vw);height:1px;margin:1.4rem auto 0;\n    background:linear-gradient(90deg,transparent,#8b0000,transparent);\n  }\n  .footer{\n    position:fixed;bottom:18px;left:0;right:0;text-align:center;\n    font-family:system-ui,sans-serif;font-size:11px;color:#5a3030;\n    letter-spacing:.2em;text-transform:uppercase;z-index:2;\n  }\n</style>\n</head>\n<body>\n  <div class=\"bg\"></div>\n  <div class=\"blood\"></div>\n  <div class=\"vignette\"></div>\n  <div class=\"center\">\n    <h1>u tryna see the <span>code</span> son?</h1>\n    <div class=\"line\"></div>\n    <p class=\"sub\">demorce · locked</p>\n  </div>\n  <div class=\"footer\">emorce hub</div>\n</body>\n</html>\n";

module.exports = function handler(req, res) {
  const accept = String(req.headers['accept'] || '').toLowerCase();
  const dest = String(req.headers['sec-fetch-dest'] || '').toLowerCase();
  const mode = String(req.headers['sec-fetch-mode'] || '').toLowerCase();

  const wantsHtml =
    accept.includes('text/html') ||
    dest === 'document' ||
    mode === 'navigate' ||
    (req.query && (req.query.view === '1' || req.query.page === '1'));

  const forceLua =
    (req.query && (req.query.raw === '1' || req.query.lua === '1')) ||
    (accept.includes('text/plain') && !accept.includes('text/html'));

  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Cache-Control', 'no-store');

  if (wantsHtml && !forceLua) {
    res.setHeader('Content-Type', 'text/html; charset=utf-8');
    res.statusCode = 200;
    res.end(HTML);
    return;
  }

  res.setHeader('Content-Type', 'text/plain; charset=utf-8');
  res.statusCode = 200;
  res.end(LUA);
};
