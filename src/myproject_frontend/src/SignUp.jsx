import React from 'react';
import { Link } from 'react-router-dom';
import './SignUp.css';

function SignUp() {
  return (
    <div className="sign-up-container">
      {/* Navbar logo */}
      <nav className="navsign-top">
        <img src="/LogoCompVerseTulisan.png" alt="CompVerse Logo" className="logo-signup" />
      </nav>

      {/* Form signup */}
      <div className="signup-form-wrapper">
        <h2 className="signup-title">New Era of Competition</h2>
        <p className="signup-subtitle">
          Please create your account by completing the data below.
        </p>

        <form className="signup-form">
          <label>Full Name</label>
          <input type="text" placeholder="Your full name" />

          <label>Phone number</label>
          <div className="phone-input">
            <select>
              <option value="+62">Indonesia (+62)</option>
              <option value="+1">USA (+1)</option>
              <option value="+44">UK (+44)</option>
            </select>
            <input type="tel" placeholder="8123456789" />
          </div>

          <label>Email</label>
          <input type="email" placeholder="example@email.com" />

          <label>Password</label>
          <input type="password" placeholder="Password" />
          <small>
            Use 8 or more characters, with a mix of letters, numbers & symbols.
          </small>

          <label>Confirm Password</label>
          <input type="password" placeholder="Confirm your password" />

          <div className="checkbox-wrapper">
            <input type="checkbox" id="confirm" />
            <label htmlFor="confirm">
              I hereby declare that all data and/or information I have provided is correct.
            </label>
          </div>

          <button type="submit" className="signup-btn">Register</button>
        </form>

        <p className="signup-footer">
          Already have an account? <Link to="/login">Login here</Link>
        </p>
      </div>

      {/* Footer bawah */}
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

export default SignUp;
