const express = require("express");
const { chromium } = require("playwright");

const app = express();
const PORT = process.env.PORT || 3000;

let browser;
let page;

(async () => {
  browser = await chromium.launch({
    headless: true,
    args: ["--no-sandbox", "--disable-setuid-sandbox"]
  });

  const context = await browser.newContext({
    viewport: { width: 1280, height: 800 }
  });

  page = await context.newPage();
})();

app.get("/", (req, res) => {
  res.send(`
  <body style="margin:0;background:#111;color:white;font-family:sans-serif">
    <div style="padding:10px;background:#222">
      <input id="url" placeholder="https://google.com" style="width:70%">
      <button onclick="go()">Go</button>
    </div>
    <img id="view" style="width:100%;height:90vh;object-fit:contain"/>
    <script>
      async function go(){
        const url=document.getElementById('url').value;
        await fetch('/goto?url='+encodeURIComponent(url));
      }
      setInterval(()=>{
        document.getElementById('view').src='/frame?'+Date.now();
      },1000);
    </script>
  </body>
  `);
});

app.get("/goto", async (req, res) => {
  await page.goto(req.query.url, { waitUntil: "domcontentloaded" });
  res.send("ok");
});

app.get("/frame", async (req, res) => {
  const img = await page.screenshot();
  res.set("Content-Type", "image/png");
  res.send(img);
});

app.listen(PORT, () =>
  console.log("Cloud browser running on port " + PORT)
);
