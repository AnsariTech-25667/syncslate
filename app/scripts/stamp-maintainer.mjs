import fs from "fs";
import path from "path";

const maint = "/*!\n * Maintained by Maaz Ansari <maazansari25667@gmail.com>\n * See README.upstream.md for upstream credits and LICENSE.\n */\n\n";
const roots = ["app","components","lib"];
const exts = new Set([".ts",".tsx",".js",".jsx"]);

function walk(dir) {
  for (const e of fs.readdirSync(dir, { withFileTypes: true })) {
    const p = path.join(dir, e.name);
    if (e.isDirectory()) {
      if (p.includes("node_modules")) continue;
      walk(p);
    } else if (exts.has(path.extname(e.name))) {
      const src = fs.readFileSync(p, "utf8");
      if (/Maintained by Maaz Ansari/.test(src)) continue;
      if (/^\s*\/\*\s*!\s*DO NOT MODIFY|\blicense\b/i.test(src)) continue;
      fs.writeFileSync(p, maint + src);
      console.log("Stamped:", p);
    }
  }
}
for (const r of roots) if (fs.existsSync(r)) walk(r);
