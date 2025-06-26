import React from 'react';
import { Routes, Route } from 'react-router-dom';
import Home from './Home';
import About from './About';
import CompVerseTeam from './CompVerseTeam'; // Pastikan kamu buat file ini

function App() {
  return (
    <Routes>
      <Route path="/" element={<Home />} />        {/* <- ini yang utama */}
      <Route path="/home" element={<Home />} />
      <Route path="/about" element={<About />} />
      <Route path="/compverse-team" element={<CompVerseTeam />} />
    </Routes>
  );
}

export default App;

