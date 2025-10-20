require('dotenv').config();
const express = require('express');
const app = express();
const port = process.env.PORT || 3000;

app.get('/', (req, res) => {
  res.send('Hello World!');
});

app.get('/api-key', (req, res) => {
  res.send(`Your API Key is: ${process.env.API_KEY}`);
});

app.listen(port, () => {
  console.log(`Example app listening at http://localhost:${port}`);
});
