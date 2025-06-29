import React from 'react';
import { Link } from 'react-router-dom';
import './Login.css';

function Login() {
  return (
    <div className="login-container">
      <nav className="navlog-top">
        <img src="/LogoCompVerseTulisan.png" alt="CompVerse Logo" className="logo-signup" />
      </nav>
      <div className="login-box">
        <form className="login-form">
          <label>Email</label>
          <input type="email" placeholder="Enter your email" />

          <label>Password</label>
          <div className="password-row">
            <input type="password" placeholder="Enter your password" />
            <Link to="#" className="forgot-password">Forgot the password?</Link>
          </div>

          <button className="login-btn" type="submit">Sign in</button>

          <p className="register-text">
            New in CompVerse? <Link to="/sign-up">Register Here</Link>
          </p>
        </form>
      </div>

      <footer className="signup-footer-links">
              <img src="/LogoCompVerseTulisan.png" alt="CompVerse Logo" />
              <div className="footer-links">
                <Link to="#">Terms & Conditions</Link>
                <Link to="#">Privacy Policy</Link>
                <Link to="/about">About CompVerse</Link>
              </div>
              <span>© 2023 Copyright by IK Developers. All rights reserved.</span>
        </footer>
    </div>
  );
}

export default Login;
