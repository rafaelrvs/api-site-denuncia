import "./Modal.css"
const Modal = ({texto,background}) =>{

    return(

        <p className="modal" style={{ background: `${background}` }}>{texto}</p>



    )
}
export default Modal;