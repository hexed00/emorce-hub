// Emorce Hub · icon proxy — avoids browser CORS / hotlink blocks on tr.rbxcdn
module.exports = async function handler(req, res) {
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader("Access-Control-Allow-Methods", "GET, OPTIONS");
  res.setHeader("Cache-Control", "public, max-age=86400, s-maxage=604800");
  if (req.method === "OPTIONS") {
    res.statusCode = 204;
    return res.end();
  }
  const id = String((req.query && req.query.id) || "").replace(/\D/g, "");
  if (!id) {
    res.statusCode = 400;
    res.setHeader("Content-Type", "text/plain");
    return res.end("id required");
  }
  try {
    const api = "https://thumbnails.roblox.com/v1/places/gameicons?placeIds=" + id + "&size=512x512&format=Png&isCircular=false";
    const r1 = await fetch(api, { headers: { "User-Agent": "EmorceHub/1.0" } });
    const j = await r1.json();
    const imageUrl = j && j.data && j.data[0] && j.data[0].imageUrl;
    if (!imageUrl) {
      res.statusCode = 404;
      res.setHeader("Content-Type", "text/plain");
      return res.end("no icon");
    }
    const r2 = await fetch(imageUrl, { headers: { "User-Agent": "EmorceHub/1.0" } });
    if (!r2.ok) {
      res.statusCode = 502;
      return res.end("upstream");
    }
    const buf = Buffer.from(await r2.arrayBuffer());
    res.setHeader("Content-Type", r2.headers.get("content-type") || "image/png");
    res.statusCode = 200;
    return res.end(buf);
  } catch (e) {
    res.statusCode = 500;
    res.setHeader("Content-Type", "text/plain");
    return res.end("error");
  }
};
