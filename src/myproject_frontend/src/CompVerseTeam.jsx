import React from 'react';
import { Link } from 'react-router-dom';
import './CompVerseTeam.css';
import './About.css';

function CompVerseTeam() {
    return (
    <div className="home-container">
      <nav className="navbar-top">
        <div className="navbar-top-right">
          <ul className="navbar-top-right-list">
              <li>Tips</li>
              <li>Home</li>
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

      <div className="breadcrumb">
        <Link to="/home" style={{color:'black'}}>Home</Link>
        <span style={{color:'black'}}> / </span>
        <Link to="/about">About CompVerse</Link>
        <span style={{color: 'black'}}> / </span>
        <span style={{color:'black'}}>Our Team</span>
      </div>

    </div>
    );
}

export default CompVerseTeam;