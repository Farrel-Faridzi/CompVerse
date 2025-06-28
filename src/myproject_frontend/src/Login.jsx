import React from 'react';
import { Link } from 'react-router-dom';
import './Login.css';

function Login() {
  return (
    <div className="login-container">
      <nav className="navsign-top">
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
    </div>
  );
}

export default Login;
