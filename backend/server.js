
const app = require("./src/app.js");
const dotenv= require("dotenv");
dotenv.config()
 
const PORT = process.env.PORTAPI;


app.listen(PORT, ()=>{ // usando o app.js para escutar o servidor 
    console.log("Servidor ligado na porta " + PORT);
});