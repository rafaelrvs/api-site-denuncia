const multer = require('multer');
const path = require('path');


const maxSize = 10 * 1000 * 1000;

module.exports = (multer({
    //informando o local da unidade de disco que sera salvo os arquivos e seu nome
    storage:multer.diskStorage({
        destination: (req,file,callback)=>{
            
            callback(null,'./public/upload/anexos');
            },
            filename:(req,file,callback)=>{
                
                // Obtém o nome do arquivo sem a extensão
                const baseName = path.basename(file.originalname, path.extname(file.originalname));
                
                // Cria o novo nome do arquivo com a extensão .png
                const newFileName = `${Date.now().toString()}_anexo.png`;
                callback(null, newFileName);
            
        },
    }),
    //definindo os tipos de arquivos que poderam ser anexados
    fileFilter: (req,file, callback)=>{
        const extencaoArquivo = path.extname(file.originalname).toLowerCase();
        const extAceitas = ['.png', '.jpg', '.jpeg', '.pdf','.mp4','.mp3','.webp'];
        if (extAceitas.includes(extencaoArquivo)) {
        callback(null, true);
        } else {
            callback({
                code: 'UNSUPPORTED_MEDIA_TYPE'
            });
        }
    },
    //definindo o limite do arquivo que podera ser anexado/salvo
    limits:{
        fileSize: maxSize,
    },
}));