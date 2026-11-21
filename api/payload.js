// Emorce Hub · KEY SERVER-SIDE ONLY · rotated pastes · GET locked
const PLACE_MAP = {
  "142823291": "https://pastefy.app/zvocgiLo/raw",
  "155615604": "https://pastefy.app/rksICSVS/raw",
  "286090429": "https://pastefy.app/fpDN9It0/raw",
  "443406476": "https://pastefy.app/gkUPpfJN/raw",
  "3039388345": "https://pastefy.app/Jt8ljEu6/raw",
  "4581966615": "https://pastefy.app/6yzeSJu0/raw",
  "6961824067": "https://pastefy.app/iLAZ4JUh/raw",
  "8908228901": "https://pastefy.app/AnYAyT1R/raw",
  "9872472334": "https://pastefy.app/iVzAclHg/raw",
  "16116270224": "https://pastefy.app/nqlBvaat/raw",
  "18687417158": "https://pastefy.app/LNjf3L70/raw",
  "72169370437173": "https://pastefy.app/tCqDC4ao/raw",
  "78515283254292": "https://pastefy.app/70xMfjHF/raw",
  "79546208627805": "https://pastefy.app/Pj1TWVA2/raw",
  "93978595733734": "https://pastefy.app/NfllWsty/raw",
  "94217045453265": "https://pastefy.app/u4qEMO30/raw",
  "99409088950210": "https://pastefy.app/NdNNxpEc/raw",
  "107535308163741": "https://pastefy.app/Cyb3n8t8/raw",
  "107778070777162": "https://pastefy.app/7LkUh4b3/raw",
  "114574503491412": "https://pastefy.app/Z9rCrRPP/raw",
  "118418618261207": "https://pastefy.app/LfCK34Fv/raw",
  "121165298854655": "https://pastefy.app/vHQcAPNO/raw",
  "126987974021910": "https://pastefy.app/NoVAj3uo/raw",
  "128541381932893": "https://pastefy.app/sGjXO2Fu/raw",
  "134728380684025": "https://pastefy.app/GtVc4qae/raw"
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

function normalizeKey(k) {
  return String(k || "").replace(/\s+/g, "").toUpperCase();
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

  if (req.method === "GET") {
    res.setHeader("Content-Type", "text/plain; charset=utf-8");
    res.statusCode = 403;
    return res.end(LOCKED);
  }

  if (req.method !== "POST") {
    res.setHeader("Content-Type", "text/plain; charset=utf-8");
    res.statusCode = 405;
    return res.end(LOCKED);
  }

  const body = await readBody(req);
  const key = normalizeKey(body.key || body.scriptKey || req.headers["x-emorce-key"]);
  const placeId = String(body.placeId || body.place || "").trim();

  if (key !== normalizeKey(VALID_KEY)) {
    res.setHeader("Content-Type", "text/plain; charset=utf-8");
    res.statusCode = 403;
    return res.end(LOCKED);
  }

  if (!placeId) {
    res.setHeader("Content-Type", "text/plain; charset=utf-8");
    res.statusCode = 400;
    return res.end("-- [Emorce Hub] placeId required\n");
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
