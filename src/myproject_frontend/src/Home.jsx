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

      <nav className="navbar-middle">
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
      </nav>
    </div>
  );
}

export default Home;