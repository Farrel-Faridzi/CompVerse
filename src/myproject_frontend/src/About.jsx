import React from 'react';
import { Link } from 'react-router-dom';
import './About.css'; // Pastikan kamu buat file ini

function About() {
  return (
    <div className="home-container">
      <nav className="navbar-top">
        <div className="navbar-top-right">
          <ul className="navbar-top-right-list">
            <li>Tips</li>
            <li>
              <Link to="/home" style={{ color: 'white', textDecoration: 'none' }}>Home</Link>
            </li>
            <li>
              <Link to="/about" style={{ color: 'white', textDecoration: 'none' }}>About</Link>
            </li>
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

      <div className="about-banner">
        <h1>About CompVerse</h1>  
      </div>

      <div className="breadcrumb">
        <Link to="/home">Home</Link>
        <span style={{ color: 'black' }}> / About CompVerse</span>
      </div>

      <div className="about-section">
        <div className="about-content">
          <div className="content-logo">
            <img src="/Vector.png" alt="CompVerse Logo" />
          </div>
          <div className="content-text">
            <p>
              Website ini berbasis Web3 karena kami ingin membangun ekosistem kompetisi yang terverifikasi, transparan,
              dan adil secara otomatis—sesuatu yang sulit dicapai secara penuh di Web2.
            </p>
            <p>
              Web2 hanya mencatat siapa yang menang dan mengirim sertifikat PDF, tapi Web3 memungkinkan kami:
              <br />- Memberi bukti keikutsertaan dan kemenangan yang immutable (NFT)
              <br />- Menjamin hadiah kompetisi dibayar tepat waktu lewat smart contract escrow
              <br />- Membangun portofolio peserta yang kredibel dan bisa diverifikasi siapa pun, tanpa login
            </p>
            <p>
              Jadi, Web3 bukan sekadar tren, tapi solusi tepat untuk masalah nyata: trust, transparansi, dan pengakuan
              prestasi yang tahan lama.
            </p>
          </div>
        </div>
        <div className="about-ourteam">
          <div className="our-team-container">
            <h2>Our Team</h2>
            <p>Get to know the people who are part of our journey.</p>
            <img src="/OurTeamFoto.png" alt="Our Team" className="our-team-image" />
            <div className="our-team-overlay">
              <Link className="see-more-button" to="/team">See more</Link>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

export default About;
