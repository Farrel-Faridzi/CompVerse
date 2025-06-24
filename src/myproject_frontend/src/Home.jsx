import React from 'react';
import './Home.css';

function Home() {
  return (
    <div className="home-container">
      <nav className="navbar-top">
        <div className="navbar-top-right">
          <ul className="navbar-top-right-list">
              <li>Tips</li>
              <li>Home</li>
              <li>About</li>
          </ul>
        </div>
      </nav>

      <div className="navbar-middle">
        <div className="navbar-middle-left">
          <div className="navbar-middle-left-logo">
            <div className="logo-icon">
              <img src="/LogoCompVerseTulisan.png" alt="CompVerse Logo" />
            </div>
          </div>
        </div>
        <div className="navbar-middle-right">
          <ul className="navbar-middle-right-list">
            <li>Search Competition</li>
            <li>Host List</li>
          </ul>
          <button className="sign-up-button">Sign In</button>
        </div>
      </div>

      <div className="main-section">
        <div className="main-left">
          <h1 className="main-heading">Compete Securely<br />with Web3</h1>
          <p className="main-subtext">A platform for safe and verified competitions</p>
          <button className="main-button">About CompVerse</button>
        </div>

        <div className="main-right">
          <div className="main-image-wrapper">
            <img src="/Image 1.png" alt="Trophy celebration" className="main-image" />
          </div>

          {/* Badge di luar wrapper supaya tidak terpotong */}
          <div className="badge badge-1">
            <img src="/icon1.png" alt="" />
            <span>Total Hadiah Terjamin<br /><strong>Rp 850.000.000+</strong></span>
          </div>

          <div className="badge badge-2">
            <img src="/icon2.png" alt="" />
            <span>Prestasi Telah Diterbitkan<br /><strong>15.000+ NFT</strong></span>
          </div>

          <div className="badge badge-3">
            <img src="/icon3.png" alt="" />
            <span>CV Prestasi On-Chain<br />Anti-Pemalsuan</span>
          </div>

          <div className="badge badge-4">
            <img src="/icon4.png" alt="" />
            <span>Dibangun di atas<br />Internet Computer</span>
          </div>
        </div>
      </div>
    </div>
  );
}

export default Home;