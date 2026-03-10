const express = require("express");
const { chromium } = require("playwright");
const WebSocket = require("ws");
const http = require("http");

const app = express();
const server = http.createServer(app);
const wss = new WebSocket.Server({ server });

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
  await page.goto("https://example.com");
})();

app.get("/", (req, res) => {
  res.send(`
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Cloud Browser</title>

<style>
body {
  margin:0;
  font-family:sans-serif;
  background:linear-gradient(135deg,#6b73ff,#9b59b6);
  height:100vh;
  display:flex;
  justify-content:center;
  align-items:center;
}

.container{
  background:white;
  border-radius:12px;
  padding:20px;
  width:90vw;
  height:85vh;
  display:flex;
  flex-direction:column;
  box-shadow:0 10px 30px rgba(0,0,0,0.2);
}

.controls{
  display:flex;
  gap:10px;
  margin-bottom:10px;
}

input{
  flex:1;
  padding:10px;
  border-radius:6px;
  border:1px solid #ccc;
}

button{
  background:#7b4dff;
  border:none;
  color:white;
  padding:10px 20px;
  border-radius:6px;
  cursor:pointer;
}

canvas{
  flex:1;
  background:black;
  border-radius:8px;
}
</style>
</head>

<body>

<div class="container">
  <div class="controls">
    <input id="url" placeholder="https://example.com"/>
    <button onclick="go()">Go</button>
  </div>

  <canvas id="screen"></canvas>
</div>

<script>
const ws = new WebSocket(
  (location.protocol === "https:" ? "wss://" : "ws://") + location.host
);

const canvas = document.getElementById("screen");
const ctx = canvas.getContext("2d");

ws.onmessage = async (event) => {
  const blob = new Blob([event.data], { type: "image/jpeg" });
  const img = await createImageBitmap(blob);

  canvas.width = img.width;
  canvas.height = img.height;
  ctx.drawImage(img,0,0);
};

function go(){
  const url = document.getElementById("url").value;
  ws.send(JSON.stringify({ type:"goto", url }));
}

canvas.addEventListener("click", e=>{
  ws.send(JSON.stringify({
    type:"click",
    x:e.offsetX,
    y:e.offsetY
  }));
});
</script>

</body>
</html>
`);
});

wss.on("connection", ws => {

  const stream = async () => {
    while (ws.readyState === 1) {
      const buffer = await page.screenshot({
        type: "jpeg",
        quality: 60
      });
      ws.send(buffer);
      await new Promise(r => setTimeout(r, 120));
    }
  };

  stream();

  ws.on("message", async msg => {
    const data = JSON.parse(msg);

    if (data.type === "goto") {
      try {
        await page.goto(data.url);
      } catch {}
    }

    if (data.type === "click") {
      await page.mouse.click(data.x, data.y);
    }
  });
});

const PORT = process.env.PORT || 3000;

server.listen(PORT, () => {
  console.log("Cloud browser running on port", PORT);
});
