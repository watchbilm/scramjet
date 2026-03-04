const http = require("http");
const { createServer } = require("@mercuryworkshop/scramjet");

const server = http.createServer();

createServer({
  server,
});

const PORT = process.env.PORT || 3000;

server.listen(PORT, "0.0.0.0", () => {
  console.log(`Scramjet running on port ${PORT}`);
});