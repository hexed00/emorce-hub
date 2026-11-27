// Emorce Hub · catalog only after key · no public place list
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

function loadGames() {
  return [{"id":"142823291","name":"Murder Mystery 2","tag":"MM2","features":["Silent aim","ESP","Auto farm","Kill aura","Speed / jump"],"img":"/api/icon?id=142823291"},{"id":"155615604","name":"Prison Life","tag":"Prison","features":["Arrest / jail tools","Gun mods","Noclip","Teleport","ESP"],"img":"/api/icon?id=155615604"},{"id":"286090429","name":"Arsenal","tag":"FPS","features":["Silent aim","ESP","Triggerbot","Hitbox","FOV circle"],"img":"/api/icon?id=286090429"},{"id":"443406476","name":"Project Lazarus","tag":"Zombie","features":["Auto farm","Gun mods","Max kills","Fire rate","No fall"],"img":"/api/icon?id=443406476"},{"id":"3039388345","name":"Shinjuku 2006","tag":"Combat","features":["Anti lock","No mercy","Inf stamina","Anims","Player lock"],"img":"/api/icon?id=3039388345"},{"id":"4581966615","name":"Anomic","tag":"Crime","features":["Combat tools","ESP","Vehicle","Utility","Emorce UI"],"img":"/api/icon?id=4581966615"},{"id":"6961824067","name":"Fling Things and People","tag":"Fling","features":["Fling tools","Orbit","Prop control","UI shell"],"img":"/api/icon?id=6961824067"},{"id":"8908228901","name":"SharkBite 2","tag":"Shark","features":["Auto farm","Boat tools","ESP","Utility"],"img":"/api/icon?id=8908228901"},{"id":"9872472334","name":"Evade","tag":"Escape","features":["ESP","Speed","Noclip","Utility"],"img":"/api/icon?id=9872472334"},{"id":"16116270224","name":"Dandy's World","tag":"Horror","features":["ESP","Auto tasks","Utility"],"img":"/api/icon?id=16116270224"},{"id":"17625359962","name":"Rivals","tag":"PvP","features":["Aim","ESP","Combat","Session key"],"img":"/api/icon?id=17625359962"},{"id":"18687417158","name":"Forsaken","tag":"Survival","features":["ESP","Generators","Stamina","Utility"],"img":"/api/icon?id=18687417158"},{"id":"2474168535","name":"Westbound","tag":"Western","features":["Aim lock","Shootbot","ESP","Br3ak3r","Fullbright"],"img":"/api/icon?id=2474168535"},{"id":"4924922222","name":"Brookhaven","tag":"RP","features":["Avatar","House RGB","Vehicles","Tools","Teleports"],"img":"/api/icon?id=4924922222"},{"id":"72169370437173","name":"Tribes 3v3","tag":"PvP","features":["Combat","ESP","Utility"],"img":"/api/icon?id=72169370437173"},{"id":"78515283254292","name":"Animal Hospital","tag":"Sim","features":["ESP","Auto tasks","Inf sanity","Utility"],"img":"/api/icon?id=78515283254292"},{"id":"79546208627805","name":"99 Nights in the Forest","tag":"Horror","features":["ESP","Utility","Survival tools"],"img":"/api/icon?id=79546208627805"},{"id":"93978595733734","name":"Violence District","tag":"Crime","features":["Combat","ESP","Utility"],"img":"/api/icon?id=93978595733734"},{"id":"94217045453265","name":"Dueling Grounds","tag":"PvP","features":["Aim","Combat","ESP"],"img":"/api/icon?id=94217045453265"},{"id":"99409088950210","name":"Survive a Million Monkeys","tag":"Survival","features":["ESP","Auto farm","Utility"],"img":"/api/icon?id=99409088950210"},{"id":"107535308163741","name":"Hush Valley","tag":"Horror","features":["ESP","Utility"],"img":"/api/icon?id=107535308163741"},{"id":"107778070777162","name":"Steal An Egg","tag":"Steal","features":["Auto steal","ESP","Speed"],"img":"/api/icon?id=107778070777162"},{"id":"111600158364583","name":"One Shot","tag":"FPS","features":["Silent aim","ESP","Fly / noclip","Config"],"img":"/api/icon?id=111600158364583"},{"id":"114574503491412","name":"Anime Zero","tag":"Anime","features":["Combat","ESP","Farm"],"img":"/api/icon?id=114574503491412"},{"id":"118418618261207","name":"Runaways","tag":"Adventure","features":["ESP","Utility"],"img":"/api/icon?id=118418618261207"},{"id":"121165298854655","name":"Don't Let Him In","tag":"Horror","features":["ESP","Utility"],"img":"/api/icon?id=121165298854655"},{"id":"126987974021910","name":"Illegal Soccer","tag":"Sports","features":["Ball tools","ESP","Utility"],"img":"/api/icon?id=126987974021910"},{"id":"128541381932893","name":"Kabuki","tag":"Combat","features":["Combat","ESP","Emorce UI"],"img":"/api/icon?id=128541381932893"},{"id":"134728380684025","name":"Aisle of the Locust","tag":"Horror","features":["ESP","Utility"],"img":"/api/icon?id=134728380684025"},{"id":"3351674303","name":"Driving Empire","tag":"Driving","features":["Auto drive","Auto farm","Car mods","ESP","Teleports","Jobs"],"img":"/api/icon?id=3351674303"},{"id":"3678761576","name":"Entrenched","tag":"WW1","features":["Aimbot","ESP pack","Hitbox","Fly / noclip","No recoil","Inf ammo"],"img":"/api/icon?id=3678761576"},{"id":"88933961678687","name":"Hyper Speed Runner","tag":"Farm","features":["Auto step XP","Auto win pad","Auto rebirth","Intervals","Configs"],"img":"/api/icon?id=88933961678687"},{"id":"78884249003161","name":"Voxel Wars","tag":"War","features":["Silent aim","Aimbot","ESP","Hitbox","Vehicles"],"img":"/api/icon?id=78884249003161"},{"id":"7633926880","name":"BloxStrike","tag":"CB","features":["Silent aim","Aim","ESP","Skins","Combat","Movement"],"img":"/api/icon?id=7633926880"},{"id":"4580204640","name":"Survive the Killer","tag":"Horror","features":["Auto revive","Killer alert","ESP","Tracers","Speed","Noclip","XRay"],"img":"/api/icon?id=4580204640"}];
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
