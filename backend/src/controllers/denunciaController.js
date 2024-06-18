const nodemailer = require("nodemailer") ;
const dotenv = require('dotenv');
dotenv.config();
class DenunciaController {
  static async cadastrarDenuncia(req, res) {
    try {
      const {denuncia} = req.body;
      const anexos = req.files
      

      let listaAnexos = [];
      if(anexos){
        anexos.map((anexo)=>{
          listaAnexos.push(anexo.filename);
        });
      }
      if(denuncia){
        const minimoCaractere = 50
        if(denuncia.length < minimoCaractere){
          return res.status(200).json({ message: `Informe no minimo ${minimoCaractere} caracteres em sua denuncia`, error: true });
        }else{
          if(listaAnexos.length == 0){
            await enviarEmail(denuncia);
            return res.status(200).json({ message: "Denúncia criada com sucesso", error:false });
          }else{
            console.log(listaAnexos);
            await enviarEmail(denuncia, listaAnexos);
            return res.status(200).json({ message: "Denúncia criada com sucesso", error:false });
          }
        }
      }else{
        return res.status(400).json({ message: "campos da requisição preenchidas incorretamente, leia a documentação do sistema", error:true });
      }
      // Enviar e-mail após a criação bem-sucedida da denúncia
    } catch (erro) {
      console.log(erro);
      return res.status(500).json({ message: `${erro.message} - Falha ao cadastrar a denúncia` });
    }
  }
}
async function enviarEmail(text,listaAnexos) {  
  try {
    const denunciaEscrita = text
    // Configurar transporte SMTPS usando Nodemailer
    const transporter = nodemailer.createTransport({
      host:process.env.HOST,
      port: process.env.PORT,
      secure: true,
      auth: {
        user: process.env.EMAIL_FROM,
        pass: process.env.PASS
      }
    });

    if(listaAnexos){    
      console.log(listaAnexos[0]);
      const mailOptionsComAnexos = {
        from: process.env.EMAIL_FROM,
        to: process.env.RECEBEEMAIL ,
        cc:process.env.EMAIL_COPIA,
        subject: "Amalfis Denuncias - Nova denúncia recebida ",
        attachments:[ 
          {
            filename: `${listaAnexos[0]}`,
            path:  `./public/upload/anexos/${listaAnexos[0]}`,
            cid: `${listaAnexos[0]}` 
          }
        ],
        html:`
           <body 
                style="margin:0 auto;
                font-family: Verdana, Geneva, Tahoma, sans-serif;">


        <header 
        style="display: flex; 
        border:2px solid yello;
        justify-content: center;
        align-items: center;
        padding: 20px; color: #F24E1E;
        ">
          <h1>Amalfis Denúncias</h1>

        </header>
        <div style="padding: 10px;">
          <h2 style="
          display: flex;
          justify-content: center;
          align-items: center; 
          color: #01407a;">
            Nova denúncia recebida:
          </h2>
          <p>${denunciaEscrita}</p>
        </div>
      </body>
              
              
              `,
      };

      await transporter.sendMail(mailOptionsComAnexos,
        (error, info)=>{
          if (error){
            console.log(error);
          } else {
            console.log("Email sent successfully: " + info.response);
          }
        }
      )
    }
    else{
      const mailOptions = {
        from: process.env.EMAIL_FROM,
        to: process.env.RECEBEEMAIL ,
         //cc:process.env.EMAIL_COPIA,
        subject: "Amalfis Denuncias - Nova denúncia recebida ",
        html:`
                <body 
                style="margin:0 auto;
                font-family: Verdana, Geneva, Tahoma, sans-serif;">


        <header 
        style="display: flex; 
        border:2px solid yello;
        justify-content: center;
        align-items: center;
        padding: 20px; color: #F24E1E;
        ">
          <h1>Amalfis Denúncias</h1>

        </header>
        <div style="padding: 10px;">
          <h2 style="
          display: flex;
          justify-content: center;
          align-items: center; 
          color: #01407a;">
            Nova denúncia recebida:
          </h2>
          <p>${denunciaEscrita}</p>
        </div>
      </body>
              
              
              `,
   

      };

      await transporter.sendMail(mailOptions,
        (error, info)=>{
          if (error){
            console.log(error);
          } else {
            console.log("Email sent successfully: " + info.response);
          }
        }
      )
    }




  } catch (erro) {
    console.error("Não foi possivel enviar a denuncia", erro);
    //return res.status(500).json({ message: `${erro} - Falha ao cadastrar a denúncia verifique o arquivo enviado` });
  }
}





module.exports = DenunciaController;
