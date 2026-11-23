// Emorce Hub · token routes · no placeId required from client
const crypto = require("crypto");

const VALID_KEY = "demorce22";
const SEAT_MS = 20 * 60 * 1000;
const ROUTE_SECRET = "emorce-hub-route-v1";
const ROUTE_URL = "https://pastefy.app/PAfKNeg9/raw";

// token -> pastefy (opaque; placeIds never leave server)
let TOKEN_MAP = {"4c68f62b00bda34c":"https://pastefy.app/zvocgiLo/raw","f8fd7a0728f5f66b":"https://pastefy.app/rksICSVS/raw","184e9b6135df23ad":"https://pastefy.app/fpDN9It0/raw","c1b8e2a0f3d94567":"https://pastefy.app/gkUPpfJN/raw","9e2a1c4b7f8d6035":"https://pastefy.app/xdfuEdkZ/raw","a3f91d2e6b0c8471":"https://pastefy.app/gRBdxk7q/raw","d5e8c1a29f4b7036":"https://pastefy.app/iLAZ4JUh/raw","b7c2e9a14f6d8053":"https://pastefy.app/AnYAyT1R/raw","e1a4d8c27b9f6032":"https://pastefy.app/iVzAclHg/raw","f2b5e0d38a1c7049":"https://pastefy.app/nqlBvaat/raw","83c6f1e49b2d8057":"https://pastefy.app/e6i7kZY2/raw","94d7a2f50c3e9068":"https://pastefy.app/LNjf3L70/raw","05e8b3a61d4f0179":"https://pastefy.app/I1CcLNb8/raw","16f9c4b72e50128a":"https://pastefy.app/SFsAyZDn/raw","270ad5c83f61239b":"https://pastefy.app/tCqDC4ao/raw","381be6d9407234ac":"https://pastefy.app/70xMfjHF/raw","492cf7ea518345bd":"https://pastefy.app/Pj1TWVA2/raw","5a3d08fb629456ce":"https://pastefy.app/NfllWsty/raw","6b4e19ac73a567df":"https://pastefy.app/u4qEMO30/raw","7c5f2abd84b678e0":"https://pastefy.app/NdNNxpEc/raw","8d603bce95c789f1":"https://pastefy.app/Cyb3n8t8/raw","9e714cdf06d89a02":"https://pastefy.app/7LkUh4b3/raw","af825de017e9ab13":"https://pastefy.app/zvNMyyvp/raw","b0936ef128f0bc24":"https://pastefy.app/Z9rCrRPP/raw","c1a47f023901cd35":"https://pastefy.app/LfCK34Fv/raw","d2b580134a12de46":"https://pastefy.app/vHQcAPNO/raw","e3c691245b23ef57":"https://pastefy.app/NoVAj3uo/raw","f4d7a2356c34f068":"https://pastefy.app/sGjXO2Fu/raw","05e8b3467d450179":"https://pastefy.app/GtVc4qae/raw","ba37d73e9d1a0011":"https://pastefy.app/yjAOcCKS/raw"};

// placeId -> token (server-only derivation table; not returned to clients)
const PLACE_TO_TOKEN = {"142823291":"4c68f62b00bda34c","155615604":"f8fd7a0728f5f66b","286090429":"184e9b6135df23ad","443406476":"c1b8e2a0f3d94567","3039388345":"9e2a1c4b7f8d6035","4581966615":"a3f91d2e6b0c8471","6961824067":"d5e8c1a29f4b7036","8908228901":"b7c2e9a14f6d8053","9872472334":"e1a4d8c27b9f6032","16116270224":"f2b5e0d38a1c7049","17625359962":"83c6f1e49b2d8057","18687417158":"94d7a2f50c3e9068","2474168535":"05e8b3a61d4f0179","4924922222":"16f9c4b72e50128a","72169370437173":"270ad5c83f61239b","78515283254292":"381be6d9407234ac","79546208627805":"492cf7ea518345bd","93978595733734":"5a3d08fb629456ce","94217045453265":"6b4e19ac73a567df","99409088950210":"7c5f2abd84b678e0","107535308163741":"8d603bce95c789f1","107778070777162":"9e714cdf06d89a02","111600158364583":"af825de017e9ab13","114574503491412":"b0936ef128f0bc24","118418618261207":"c1a47f023901cd35","121165298854655":"d2b580134a12de46","126987974021910":"e3c691245b23ef57","128541381932893":"f4d7a2356c34f068","134728380684025":"05e8b3467d450179","3351674303":"ba37d73e9d1a0011"};

let SEATS = [];

const LOCKED = `-- ============================================\n--   demorce tamper activated\n--   script needs key · source locked\n--   https://emorce-hub.vercel.app\n-- ============================================\n`;
const BUSY = `-- Emorce · seat taken\npcall(function()\n  local p = game:GetService("Players").LocalPlayer\n  if p then p:Kick("Emorce Hub · seats full · max 2 users") end\nend)\nreturn\n`;
const BROKEN = `-- Emorce · environment rejected\nerror("EmorceHub: invalid environment", 0)\n`;

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

function tokenForPlace(pid) {
  return crypto.createHmac("sha256", ROUTE_SECRET).update(String(pid)).digest("hex").slice(0, 16);
}

function looksLikeBrowser(req) {
  const ua = String(req.headers["user-agent"] || "").toLowerCase();
  const accept = String(req.headers["accept"] || "").toLowerCase();
  if (accept.includes("text/html")) return true;
  if (/mozilla|chrome|safari|firefox|edg\//i.test(ua) && !/roblox|executor|synapse|fluxus|wave|solara|emorce|hexpulse/i.test(ua)) {
    return true;
  }
  return false;
}

function isEmorceClient(req, body) {
  const h = String(req.headers["x-emorce-client"] || "").toLowerCase();
  const mark = String((body && body.client) || "").toLowerCase();
  if (h === "hex-pulse-7f3a" || mark === "hex-pulse-7f3a") return true;
  const ua = String(req.headers["user-agent"] || "").toLowerCase();
  if (/synapse|fluxus|wave|solara|krnl|script-ware|oxygen|emorce|hexpulse|roblox/i.test(ua)) return true;
  return false;
}

function claimSeat(token) {
  const now = Date.now();
  const t = String(token || "").trim() || ("anon-" + now);
  SEATS = SEATS.filter((s) => s.until > now);
  const existing = SEATS.find((s) => s.token === t);
  if (existing) {
    existing.until = now + SEAT_MS;
    return true;
  }
  if (SEATS.length >= 2) return false;
  SEATS.push({ token: t, until: now + SEAT_MS });
  return true;
}

async function resolveUrl(token, placeId) {
  let t = String(token || "").trim().toLowerCase();
  if (!t && placeId) {
    t = PLACE_TO_TOKEN[String(placeId)] || tokenForPlace(placeId);
  }
  if (!t) return null;
  if (TOKEN_MAP[t]) return TOKEN_MAP[t];
  try {
    const r = await fetch(ROUTE_URL, { headers: { "User-Agent": "emorce-hub/server" } });
    if (r.ok) {
      const j = await r.json();
      if (j && j.routes && typeof j.routes === "object") {
        TOKEN_MAP = j.routes;
        if (TOKEN_MAP[t]) return TOKEN_MAP[t];
      }
    }
  } catch (e) {}
  return null;
}

module.exports = async function handler(req, res) {
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader("Access-Control-Allow-Methods", "POST, OPTIONS");
  res.setHeader("Access-Control-Allow-Headers", "Content-Type, X-Emorce-Key, X-Emorce-Client");
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
  const token = String(body.token || body.route || body.t || "").trim();
  const placeId = String(body.placeId || body.place || "").trim();
  const sessionId = String(body.sessionId || body.seat || "").trim();

  if (key !== normalizeKey(VALID_KEY)) {
    res.setHeader("Content-Type", "text/plain; charset=utf-8");
    res.statusCode = 403;
    return res.end(LOCKED);
  }

  if (looksLikeBrowser(req) || !isEmorceClient(req, body)) {
    res.setHeader("Content-Type", "text/plain; charset=utf-8");
    res.statusCode = 403;
    return res.end(BROKEN);
  }

  if (!claimSeat(sessionId || key)) {
    res.setHeader("Content-Type", "text/plain; charset=utf-8");
    res.statusCode = 200;
    return res.end(BUSY);
  }

  const url = await resolveUrl(token, placeId);
  if (!url) {
    res.setHeader("Content-Type", "text/plain; charset=utf-8");
    res.statusCode = 404;
    return res.end("-- [Emorce Hub] no payload for this route\n");
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
