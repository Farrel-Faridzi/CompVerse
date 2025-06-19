import React from 'react';
import './Home.css';

function Home() {
  return (
    <div className="home-container">
      {/* NAVBAR */}
      <nav className="navbar">
        <div className="navbar-left">
          {/* Tambahkan teks "CompVerse" di sini */}
          <img src="/Vector.png" alt="CompVerse" className="logo" />
          <span className="logo-text">CompVerse</span> {/* BARIS INI DITAMBAHKAN */}
        </div>

        <ul className="nav-links">
          <li>About us</li>
          <li>Services</li>
          <li>Case Studies</li>
          <li>Blog</li>
          <li>How it Works</li>
          <li>Hire</li>
        </ul>

        <div className="navbar-right">
          <button className="signin-btn">Sign in</button>
        </div>
      </nav>

      {/* HERO SECTION - Tidak ada perubahan di sini */}
      <section className="hero">
        <div className="hero-text">
          <h1>
            <span>Compete Securely</span> with Web3
          </h1>
          <p>A platform for safe and verified competitions</p>
        </div>
        <div className="hero-image">
          <div className="image-placeholder" />
        </div>
      </section>
    </div>
  );
}

export default Home;