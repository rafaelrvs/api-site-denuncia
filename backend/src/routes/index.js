const express = require("express");
const denuncia = require("./denunciaRoutes.js") ;
const cors = require('cors');


module.exports = (app) => {
  app.use( 
    cors(),
    express.json(),
    denuncia
  );
};


