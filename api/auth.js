// Emorce Hub · site login · key never in HTML
const VALID_KEY = "demorce22";

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
  res.setHeader("Access-Control-Allow-Headers", "Content-Type");
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
  const key = normalizeKey(body.key || body.password || "");
  if (key !== normalizeKey(VALID_KEY)) {
    res.statusCode = 403;
    return res.end(JSON.stringify({ ok: false, error: "denied" }));
  }
  res.statusCode = 200;
  return res.end(JSON.stringify({ ok: true }));
};
