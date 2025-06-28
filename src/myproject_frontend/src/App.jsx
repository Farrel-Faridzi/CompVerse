import React from 'react';
import { Routes, Route } from 'react-router-dom';
import Home from './Home';
import About from './About';
import SignUp from './SignUp'; // Pastikan kamu buat file ini
import CompVerseTeam from './CompVerseTeam'; // Pastikan kamu buat file ini
import Login from './Login';

function App() {
  return (
    <Routes>
      <Route path="/" element={<Home />} />        {/* <- ini yang utama */}
      <Route path="/home" element={<Home />} />
      <Route path="/about" element={<About />} />
      <Route path="/compverse-team" element={<CompVerseTeam />} />
      <Route path="/sign-up" element={<SignUp />} /> {/* Pastikan SignUp sudah dibuat */}
      <Route path="/login" element={<Login />} />   {/* Pastikan Login sudah dibuat */}
    </Routes>
  );
}

export default App;

