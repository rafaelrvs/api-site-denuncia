const express = require("express");

const denunciaController = require( "../controllers/denunciaController.js");

const  ValidUploadAnexo = require("../../middlewares/multerUploadAnexo.js"); 

const routes = express.Router();

routes.post("/api/denuncia", ValidUploadAnexo.any("anexo"),(req, res) =>{denunciaController.cadastrarDenuncia(req,res)});



module.exports = routes;
