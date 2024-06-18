const mysql = require('mysql2/promise');
require('dotenv').config();

// Configuração da conexão MySQL
const dbConfig = {
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME
};

// Função para conectar ao MySQL
async function connectToMySQL() {
  try {
    const connection = await mysql.createConnection(dbConfig);
    console.log('Conexão com MySQL estabelecida com sucesso!');
    return connection;
  } catch (error) {
    console.error('Erro ao conectar ao MySQL:', error);
    throw error;
  }
}

// Exporte a função de conexão para uso em outras partes do seu aplicativo
module.exports = { connectToMySQL };
