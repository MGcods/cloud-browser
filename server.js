const express = require("express");
const { chromium } = require("playwright");
const WebSocket = require("ws");

const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.static("public"));

let browser;
let page;

(async () => {
  browser = await chromium.launch({
    headless: false,
    args: [
      "--no-sandbox",
      "--disable-setuid-sandbox",
      "--autoplay-policy=no-user-gesture-required",
      "--use-fake-ui-for-media-stream",
      "--enable-audio"
    ]
  });

  const context = await browser.newContext({
    viewport: { width: 1280, height: 720 }
  });

  page = await context.newPage();
})();

const server = app.listen(PORT, () => console.log(`Server running on port ${PORT}`));

const wss = new WebSocket.Server({ server });

wss.on("connection", ws => {
  console.log("Cliente conectado");

  ws.on("message", async message => {
    const input = JSON.parse(message.toString());
    if (!page) return;

    if (input.type === "goto") {
      await page.goto(input.url, { waitUntil: "domcontentloaded" });
    }
    if (input.type === "click") {
      await page.mouse.click(input.x, input.y);
    }
    if (input.type === "keydown") {
      await page.keyboard.press(input.key);
    }
  });
});