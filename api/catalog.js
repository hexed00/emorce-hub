// Emorce Hub · catalog only after key · no public place list
const VALID_KEY = "demorce22";
const fs = require("fs");
const path = require("path");

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

function loadGames() {
  const candidates = [
    path.join(process.cwd(), "private", "catalog.json"),
    path.join(__dirname, "..", "private", "catalog.json"),
  ];
  for (const p of candidates) {
    try {
      if (fs.existsSync(p)) return JSON.parse(fs.readFileSync(p, "utf8"));
    } catch (e) {}
  }
  return [];
}

module.exports = async function handler(req, res) {
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader("Access-Control-Allow-Methods", "POST, OPTIONS");
  res.setHeader("Access-Control-Allow-Headers", "Content-Type, X-Emorce-Key");
  res.setHeader("Cache-Control", "no-store");
  res.setHeader("Content-Type", "application/json; charset=utf-8");

  if (req.method === "OPTIONS") {
    res.statusCode = 204;
    return res.end();
  }
  if (req.method !== "POST") {
    res.statusCode = 405;
    return res.end(JSON.stringify({ ok: false, error: "method" }));
  }

  const body = await readBody(req);
  const key = normalizeKey(body.key || body.password || req.headers["x-emorce-key"]);
  if (key !== normalizeKey(VALID_KEY)) {
    res.statusCode = 403;
    return res.end(JSON.stringify({ ok: false, error: "denied" }));
  }

  const games = loadGames();
  const out = games.map((g, i) => ({
    t: "g" + (i + 1).toString(36),
    name: g.name,
    tag: g.tag,
    features: g.features || [],
    img: "/api/icon?id=" + g.id,
  }));
  res.statusCode = 200;
  return res.end(JSON.stringify({ ok: true, games: out }));
};
