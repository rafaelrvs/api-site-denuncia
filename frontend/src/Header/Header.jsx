import "./Header.css"
import logo from '../../images/logoHeader.svg'

const Header = () =>{

    
    return (
        <header className="header" >
            <div className="content-header   " >
                <img src={logo} alt="logo" />
            </div>
        </header>
    )
}
export default Header;