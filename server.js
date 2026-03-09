const express = require("express");
const { chromium } = require("playwright");

const app = express();

let cachedContent = null;

// Generate static HTML on startup
async function generateStaticContent() {
  const browser = await chromium.launch();
  const page = await browser.newPage();

  await page.goto("https://twitch.tv");

  cachedContent = await page.content();

  await browser.close();
  console.log("Static webpage generated successfully");
}

app.get("/", (req, res) => {
  if (cachedContent) {
    res.send(cachedContent);
  } else {
    res.status(500).send("Content not ready yet");
  }
});

// Initialize on startup
generateStaticContent().catch(err => {
  console.error("Error generating static content:", err);
  process.exit(1);
});

app.listen(3000, () => {
  console.log("Server running on http://localhost:3000");
});
