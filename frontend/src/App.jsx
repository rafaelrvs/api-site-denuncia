import { useRef, useState } from 'react';
import './App.css';
import Header from './Header/Header';
import Modal from './Modal/Modal';
import React from 'react';
import Footer from './Footer/Footer';

function App() {
  const [imagemEscolhida, setImagemEscolhida] = useState(null);
  const [errorMessage, setErrorMessage] = useState('');
  const currentImg = useRef();
  const url = 'http://denuncia.amalfis.com.br/api/denuncia';

  const [modal, setModal] = useState({
    status: false,
    background: null,
    texto: null,
  });

  const [text, setText] = useState("");
  const [caracter, setCaracter] = useState(0);

  async function enviaDados() {
    try {
      const formData = new FormData();
      formData.append('denuncia', text.replace(/[<>/%$]/g, ''));
      if (currentImg.current.files[0]) {
        formData.append("anexo", currentImg.current.files[0]);
      }

      const response = await fetch(url ,  {
        method: "POST",
        body: formData,
      });

      if (response.ok) {
        ativaModal();
        setImagemEscolhida(null);
        currentImg.current.value = null; // Reset input file
      } else {
        throw new Error("Erro ao enviar a denúncia");
      }
    } catch (error) {
      console.log(error);
      setModal({
        status: true,
        background: "rgb(196, 33, 33)",
        texto: `Erro ao enviar a denúncia ${error.message}`,
      });
      desativaModal();
    }
  }

  function desativaModal() {
    setTimeout(() => {
      setModal({
        status: false,
        background: null,
        texto: null,
      });
    }, 5500);
  }

  function ativaModal() {
    setModal({
      status: true,
      background: "rgb(108, 207, 108)",
      texto: "Denúncia enviada com sucesso",
    });
    setText("");
    setCaracter(0);
    setTimeout(() => {
      desativaModal();
    }, 3000);
  }

  function validateText() {
    if (text.length <= 50) {
      setModal({
        status: true,
        background: "rgb(196, 33, 33)",
        texto: "Erro ao enviar a denúncia, pouco valor digitado minimo de 50 caracter!",
      });
      desativaModal();
      return false;
    }
    if (text.length >= 10000) {
      setModal({
        status: true,
        background: "rgb(196, 33, 33)",
        texto: "Erro ao enviar a denúncia, Ultrapassa o limite esperado!",
      });
      desativaModal();
      return false;
    } else {
      return true;
    }
  }

  async function handlerEnviaDenuncia(event) {
    event.preventDefault();
    if (validateText()) {
      await enviaDados();
    }
  }

  function handleFileChange(e) {
    const file = e.target.files[0];
    const allowedExtensions = ['.png', '.jpg', '.jpeg', '.pdf','.mp4','.mp3','.webp'];
    const fileExtension = file ? file.name.split('.').pop().toLowerCase() : '';

    if (file && !allowedExtensions.includes(`.${fileExtension}`)) {
      setErrorMessage('Apenas arquivos .png, .jpg, .jpeg, .pdf, .mp4, .mp3, .webp são permitidos');
      setImagemEscolhida(null);
      currentImg.current.value = null;
    } else {
      setErrorMessage('');
      setImagemEscolhida(file);
    }
  }

  return (
    <>
      <Header />
      <div className='main'>
        <h1 className='title-denuncia'>Faça aqui sua denúncia</h1>
        <form className='fielde-form' onSubmit={handlerEnviaDenuncia} encType="multipart/form-data">
          <textarea
            id="field-text"
            placeholder='Escreva aqui sua denúncia'
            maxLength={5000}
            required
            value={text}
            onChange={(e) => {
              setText(e.target.value);
              setCaracter(e.target.value.length);
            }}
          ></textarea>
          <p className='quantidade-letra'>
            <span
              className='quantidade-letra'
              style={{ color: text.length > 50 && text.length < 5000 ? '#01427A' : 'rgba(255, 0, 0, 0.342)' }}>
              {caracter}
            </span>
            falta <span className='quantidade-letra'>{5000 - text.length}</span>
          </p>
            <div className='content'>
              {errorMessage && <p id='erro-arquivo'>{errorMessage}</p>}
              <input
                type="file"
                name="anexo"
                ref={currentImg}
                className='anexo'
                onChange={handleFileChange}
              />
              <input id={modal.status ? 'disable-btn' : 'btn-subimit-denuncia'} type="submit" disabled={modal.status} value="Enviar denúncia" />
            </div>
            {modal.status && <Modal texto={modal.texto} background={modal.background} />}
        </form>
        <br />
        <h1 className='titulo-chamada'>A Amalfis não concorda!</h1>
        <p className='body-text'>
          Nosso compromisso é proporcionar um ambiente de trabalho seguro e respeitoso para todos os nossos colaboradores. Este Canal de Denúncia oferece a todos a oportunidade de reportar informações relativas a violações de qualquer natureza, bem como suspeitas fundamentadas de violações. A análise do conteúdo das denúncias é realizada exclusivamente pela Amalfis Uniformes/Maria Raimunda e o anonimato é garantido ao denunciante, que não precisa necessariamente se identificar. As informações fornecidas serão tratadas em estrita confidencialidade e apenas compartilhadas para a devida análise do caso. A informação fornecida poderá motivar o início de investigações internas, feitas por equipe especializada, bem como investigações por autoridades públicas e a tomada das medidas cabíveis. Por outro lado, a disseminação consciente de informação falsa ao Canal de Denúncia também será tratada com a devida seriedade, responsabilizando-se aqueles que procurarem utilizar este instrumento de forma indevida. Atenção: Este canal de denúncias NÃO é um canal de emergência. Não use este canal para denunciar ameaças iminentes à vida. Nestes casos, somente a autoridade policial local poderá interceder.
        </p>
        <br />
      </div>
      <Footer />
    </>
  );
}

export default App;
