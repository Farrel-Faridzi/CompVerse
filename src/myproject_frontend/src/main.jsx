
import React from 'react';
import { createRoot } from 'react-dom/client';
import './index.css';

import Home from './Home';

createRoot(document.getElementById('root')).render(
  <React.StrictMode>
    <title>CompVerse</title>
    <Home />
  </React.StrictMode>
);