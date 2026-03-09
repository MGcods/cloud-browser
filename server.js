const express = require("express");
const { chromium } = require("playwright");

const app = express();

app.get("/", async (req, res) => {
  const browser = await chromium.launch();
  const page = await browser.newPage();

  await page.goto("https://twitch.tv");

  const content = await page.content();
  res.send(content);

  await browser.close();
});

app.listen(3000);
