const express = require("express");
const fetch = require("node-fetch");

const app = express();

// simple homepage with address bar
app.get("/", (req, res) => {
  res.send(`<!DOCTYPE html>
<html lang="pt-PT">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Cloud Browser</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    body { background: #f5f5f5; font-family: sans-serif; }
    .browser { width: 90vw; height: 80vh; border: 1px solid #ccc; }
    .controls { margin: 20px; }
  </style>
</head>
<body>
  <div class="controls">
    <form onsubmit="goto(event)">
      <input id="url" type="text" placeholder="https://example.com" size="40" />
      <button type="submit" class="btn btn-primary">Go</button>
    </form>
  </div>
  <iframe id="frame" class="browser"></iframe>

  <script>
    function goto(e) {
      e.preventDefault();
      const u = document.getElementById('url').value;
      document.getElementById('frame').src = '/proxy/' + encodeURIComponent(u);
    }
  </script>
</body>
</html>`);
});

// proxy handler: everything after /proxy/<encoded> is forwarded to target
app.use('/proxy/:target(*)', async (req, res) => {
  try {
    const targetBase = decodeURIComponent(req.params.target);
    const url = new URL(targetBase);
    // append rest of path
    url.pathname = req.url.replace(/^\/proxy\/[^/]+/, '');
    const options = {
      method: req.method,
      headers: { ...req.headers, host: url.host },
      // body not handled (GET only for simplicity)
    };
    const response = await fetch(url.toString(), options);
    // copy status and headers
    res.status(response.status);
    response.headers.forEach((v, k) => res.setHeader(k, v));
    const body = await response.buffer();
    res.send(body);
  } catch (err) {
    res.status(500).send('proxy error: ' + err.message);
  }
});

app.listen(3000, () => {
  console.log("Server running on http://localhost:3000");
});
