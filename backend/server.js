
const app = require("./src/app.js");
const dotenv= require("dotenv");
dotenv.config()
 
const PORT = 3000;

const https = require('https');
const fs = require('fs');

 const httpsOptions = {
    key: fs.readFileSync('/etc/letsencrypt/live/denuncia.amalfis.com.br/privkey.pem'),
    cert: fs.readFileSync('/etc/letsencrypt/live/denuncia.amalfis.com.br/fullchain.pem')
}; 

const server = https.createServer(httpsOptions,app);

server.listen(PORT, ()=>{ // usando o app.js para escutar o servidor 
    console.log("Servidor ligado na porta " + PORT);
});