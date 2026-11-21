// Emorce Hub · key-gated payload delivery
// PLACE_MAP lives only here. Never in client Lua.
const PLACE_MAP = {
  "142823291": "https://pastefy.app/tOtemoYf/raw",
  "155615604": "https://pastefy.app/JdOp1T0N/raw",
  "286090429": "https://pastefy.app/scP3mXh3/raw",
  "443406476": "https://pastefy.app/AXAvFFok/raw",
  "3039388345": "https://pastefy.app/Hvw6leGQ/raw",
  "4581966615": "https://pastefy.app/Kt0EnPZ6/raw",
  "6961824067": "https://pastefy.app/2xDGGAVT/raw",
  "8908228901": "https://pastefy.app/L3lPbrtG/raw",
  "9872472334": "https://pastefy.app/PgeaVa8t/raw",
  "16116270224": "https://pastefy.app/kT8Udfys/raw",
  "18687417158": "https://pastefy.app/nLpDGZqe/raw",
  "72169370437173": "https://pastefy.app/Gc3oKaNz/raw",
  "78515283254292": "https://pastefy.app/SouZ8Tls/raw",
  "79546208627805": "https://pastefy.app/yyEOWFjz/raw",
  "93978595733734": "https://pastefy.app/u6Mi92Ka/raw",
  "94217045453265": "https://pastefy.app/ODmhyEea/raw",
  "99409088950210": "https://pastefy.app/Zev8ojUl/raw",
  "107535308163741": "https://pastefy.app/QBUlS4PW/raw",
  "107778070777162": "https://pastefy.app/9t3IdQQ8/raw",
  "114574503491412": "https://pastefy.app/yLB7BtAo/raw",
  "118418618261207": "https://pastefy.app/1AebVxnv/raw",
  "121165298854655": "https://pastefy.app/xcaBKzwM/raw",
  "126987974021910": "https://pastefy.app/tserCaT7/raw",
  "128541381932893": "https://pastefy.app/5KYPY3EO/raw",
  "134728380684025": "https://pastefy.app/wipf29cS/raw"
};

const VALID_KEY = "demorce22";

const LOCKED = `-- ============================================\n--   demorce tamper activated\n--   script needs key · source locked\n--   https://emorce-hub.vercel.app\n-- ============================================\n`;

function readBody(req) {
  return new Promise((resolve) => {
    if (req.body && typeof req.body === "object") return resolve(req.body);
    if (typeof req.body === "string") {
      try { return resolve(JSON.parse(req.body)); } catch (e) { return resolve({}); }
    }
    let data = "";
    req.on("data", (c) => { data += c; });
    req.on("end", () => {
      try { resolve(JSON.parse(data || "{}")); } catch (e) { resolve({}); }
    });
  });
}

module.exports = async function handler(req, res) {
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader("Access-Control-Allow-Methods", "POST, OPTIONS");
  res.setHeader("Access-Control-Allow-Headers", "Content-Type, X-Emorce-Key");
  res.setHeader("Cache-Control", "no-store");

  if (req.method === "OPTIONS") {
    res.statusCode = 204;
    return res.end();
  }

  if (req.method !== "POST") {
    res.setHeader("Content-Type", "text/plain; charset=utf-8");
    res.statusCode = 405;
    return res.end(LOCKED);
  }

  const body = await readBody(req);
  const key = String(body.key || body.scriptKey || req.headers["x-emorce-key"] || "").trim();
  const placeId = String(body.placeId || body.place || "").trim();

  if (key !== VALID_KEY) {
    res.setHeader("Content-Type", "text/plain; charset=utf-8");
    res.statusCode = 403;
    return res.end(LOCKED);
  }

  const url = PLACE_MAP[placeId];
  if (!url) {
    res.setHeader("Content-Type", "text/plain; charset=utf-8");
    res.statusCode = 404;
    return res.end("-- [Emorce Hub] no payload for this place\n");
  }

  try {
    const r = await fetch(url, {
      headers: { "User-Agent": "emorce-hub/server", Accept: "*/*" },
    });
    if (!r.ok) throw new Error("upstream " + r.status);
    const text = await r.text();
    if (!text || text.length < 50) throw new Error("empty upstream");
    res.setHeader("Content-Type", "text/plain; charset=utf-8");
    res.statusCode = 200;
    return res.end(text);
  } catch (e) {
    res.setHeader("Content-Type", "text/plain; charset=utf-8");
    res.statusCode = 502;
    return res.end("-- [Emorce Hub] delivery failed\n");
  }
};
