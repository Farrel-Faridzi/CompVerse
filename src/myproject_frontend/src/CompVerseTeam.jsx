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

      <div className="path-info">
        <Link to="/home" style={{ color: 'blue' }}>Home</Link>
        <span style={{ color: 'black' }}> / </span>
        <Link to="/about" style={{ color: 'blue' }}>About CompVerse</Link>
        <span style={{ color: 'black' }}> / </span>
        <span style={{ color: 'black' }}>Our Team</span>
      </div>

      <div className="team-container">
        <div className="judul-team">
          <judul>CompVerse Team</judul>
          <description>We are a team working together to achieve a common goal. Get</description>
          <description>to know the people who are part of our journey.</description>
        </div>

        <div className="foto-team">
          <div className="foto-barisan">
            <div className="team-member">
              <img src="/Farrel.svg" alt="Farrel Faridzi L." />
              <div className="name">Farrel Faridzi L.</div>
              <div className="role">Team Leader</div>
            </div>
            <div className="team-member">
              <img src="/Touya.svg" alt="Randuichi Touya" />
              <div className="name">Randuichi Touya</div>
              <div className="role">Fullstack Dev</div>
            </div>
          </div>

          <div className="foto-barisan">
            <div className="team-member">
              <img src="/Juma.svg" alt="Juma Jordan B." />
              <div className="name">Juma Jordan B.</div>
              <div className="role">Product Manager</div>
            </div>
            <div className="team-member">
              <img src="/Salman.svg" alt="M. Salman Fahri" />
              <div className="name">M. Salman Fahri</div>
              <div className="role">Front-End Dev</div>
            </div>
            <div className="team-member">
              <img src="/Justin.svg" alt="Justin Dwitama S." />
              <div className="name">Justin Dwitama S.</div>
              <div className="role">UI/UX Designer</div>
            </div>
          </div>
        </div>

        <div className="penutup-team">
          <judulpenutup>Reach Your Peak Achievement, With Us!</judulpenutup>
          <descriptionpenutup>With the spirit of fairness and innovation, we build this platform to open a</descriptionpenutup>
          <descriptionpenutup>new era of transparent competition. We believe that every participant</descriptionpenutup>
          <descriptionpenutup>deserves an equal opportunity and every victory is a real proof that should</descriptionpenutup>
          <descriptionpenutup>be recognized globally and forever.</descriptionpenutup>
        </div>
      </div>
    </div>
  );
}

export default CompVerseTeam;
