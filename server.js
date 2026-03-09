const express = require("express");

const app = express();

const htmlContent = `<!DOCTYPE html>
<html lang="pt-PT">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Cloud Browser - Twitch</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    body {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
    }
    .container-custom {
      text-align: center;
      background: white;
      border-radius: 15px;
      padding: 50px;
      box-shadow: 0 10px 40px rgba(0,0,0,0.3);
    }
    h1 {
      color: #764ba2;
      margin-bottom: 30px;
    }
    .btn-twitch {
      background-color: #9146FF;
      border: none;
      padding: 15px 40px;
      font-size: 18px;
      border-radius: 8px;
      transition: all 0.3s ease;
    }
    .btn-twitch:hover {
      background-color: #772ce8;
      transform: scale(1.05);
      color: white;
    }
  </style>
</head>
<body>
  <div class="container-custom">
    <h1>🎮 Cloud Browser</h1>
    <p class="text-muted mb-4">Aceda ao Twitch diretamente</p>
    <a href="https://twitch.tv" target="_blank" class="btn btn-twitch">Abrir Twitch</a>
  </div>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>`;

app.get("/", (req, res) => {
  res.send(htmlContent);
});

app.listen(3000, () => {
  console.log("Server running on http://localhost:3000");
});
