<svg xmlns="http://www.w3.org/2000/svg" width="1200" height="420" viewBox="0 0 1200 420">

<defs>

  <linearGradient id="bg" x2="1" y2="1">
    <stop stop-color="#030503"/>
    <stop offset=".5" stop-color="#142608"/>
    <stop offset="1" stop-color="#030503"/>
  </linearGradient>

  <linearGradient id="neon" x2="0" y2="1">
    <stop stop-color="#eaff90"/>
    <stop offset=".5" stop-color="#b6ff00"/>
    <stop offset="1" stop-color="#238900"/>
  </linearGradient>

  <linearGradient id="wallet" x2="1" y2="1">
    <stop stop-color="#384438"/>
    <stop offset=".5" stop-color="#151b15"/>
    <stop offset="1" stop-color="#050805"/>
  </linearGradient>

  <linearGradient id="card" x2="1" y2="1">
    <stop stop-color="#b6ff00"/>
    <stop offset="1" stop-color="#174900"/>
  </linearGradient>

  <filter id="glow">
    <feGaussianBlur stdDeviation="5" result="blur"/>
    <feMerge>
      <feMergeNode in="blur"/>
      <feMergeNode in="SourceGraphic"/>
    </feMerge>
  </filter>

  <pattern id="carbon" width="12" height="12" patternUnits="userSpaceOnUse">
    <path d="M0 0L12 12 M-6 6L6 18 M6 -6L18 6"
          stroke="#ffffff" stroke-opacity=".035"/>
  </pattern>

</defs>

<!-- Fond noir carbone -->

<rect width="1200" height="420" rx="25" fill="url(#bg)"/>
<rect width="1200" height="420" rx="25" fill="url(#carbon)"/>

<rect x="3" y="3" width="1194" height="414" rx="25"
      fill="none" stroke="#b6ff00" stroke-width="2"/>

<!-- Flammes vertes -->

<g fill="url(#neon)" opacity=".65" filter="url(#glow)">

  <path d="M0 420 Q90 350 45 270
           Q140 310 110 170
           Q230 290 175 350
           Q260 310 245 240
           Q330 350 280 420 Z"/>

  <path d="M850 420 Q900 350 860 270
           Q960 310 930 150
           Q1040 250 990 340
           Q1100 300 1060 100
           Q1200 230 1140 340
           Q1190 310 1200 270
           L1200 420 Z"/>

</g>

<!-- Particules lumineuses -->

<g fill="#b6ff00" filter="url(#glow)">
  <circle cx="80" cy="80" r="3"/>
  <circle cx="240" cy="110" r="2"/>
  <circle cx="580" cy="55" r="3"/>
  <circle cx="690" cy="320" r="3"/>
  <circle cx="1120" cy="70" r="4"/>
  <circle cx="1060" cy="200" r="2"/>
  <circle cx="420" cy="360" r="3"/>
</g>

<!-- Titre -->

<text x="65" y="95"
      font-family="Arial,sans-serif"
      font-size="14"
      letter-spacing="6"
      fill="#b6ff00">
  NEXT GENERATION DIGITAL WALLET
</text>

<text x="60" y="165"
      font-family="Arial,sans-serif"
      font-size="57"
      font-weight="900"
      fill="#ffffff">
  SMARTWALLET
</text>

<text x="65" y="235"
      font-family="Arial,sans-serif"
      font-size="65"
      font-weight="900"
      fill="#b6ff00"
      filter="url(#glow)">
  // PRO
</text>

<text x="65" y="275"
      font-family="Arial,sans-serif"
      font-size="22"
      letter-spacing="3"
      fill="#ffffff">
  YOUR LIFE. ONE WALLET.
</text>

<!-- Badge -->

<rect x="65" y="300" width="295" height="38"
      rx="19" fill="#b6ff00"/>

<text x="212" y="325"
      text-anchor="middle"
      font-family="Arial,sans-serif"
      font-size="13"
      font-weight="bold"
      fill="#071000">
  3D EXPERIENCE / PREMIUM EDITION
</text>

<!-- Cartes superposées -->

<g transform="translate(780 70) rotate(-12 140 85)">
  <rect width="280" height="170" rx="18"
        fill="#245cc7" stroke="#8abaff" stroke-width="2"/>
  <text x="20" y="35" fill="white"
        font-family="Arial" font-size="23" font-weight="bold">
    RAMQ
  </text>
  <text x="20" y="60" fill="white"
        font-family="Arial" font-size="12">
    DEMO / HEALTH
  </text>
</g>

<g transform="translate(820 95) rotate(12 140 85)">
  <rect width="280" height="170" rx="18"
        fill="#7238b5" stroke="#c59bff" stroke-width="2"/>
  <text x="20" y="35" fill="white"
        font-family="Arial" font-size="23" font-weight="bold">
    BOREAL
  </text>
  <text x="20" y="60" fill="white"
        font-family="Arial" font-size="12">
    DEMO / STUDENT
  </text>
</g>

<g transform="translate(790 140) rotate(-4 140 85)">
  <rect width="280" height="170" rx="18"
        fill="url(#card)" stroke="#e0ff9e" stroke-width="2"/>

  <text x="20" y="35" fill="#071000"
        font-family="Arial" font-size="25" font-weight="bold">
    DESJARDINS
  </text>

  <text x="20" y="60" fill="#071000"
        font-family="Arial" font-size="13">
    AUTO INSURANCE / DEMO
  </text>

  <rect x="20" y="80" width="42" height="32"
        rx="6" fill="#d4c17d" stroke="#fff0ae"/>

  <text x="20" y="140" fill="white"
        font-family="monospace" font-size="17">
    DEMO - AUTO - 001
  </text>
</g>

<!-- Portefeuille noir carbone -->

<rect x="755" y="235" width="360" height="145"
      rx="22" fill="url(#wallet)"
      stroke="#b6ff00" stroke-width="2"/>

<rect x="765" y="245" width="340" height="125"
      rx="16" fill="none"
      stroke="#b6ff00" stroke-opacity=".5"
      stroke-dasharray="5 5"/>

<rect x="755" y="235" width="360" height="145"
      rx="22" fill="url(#carbon)"/>

<text x="785" y="295"
      font-family="Arial,sans-serif"
      font-size="37" font-weight="900"
      fill="#b6ff00" filter="url(#glow)">
  SW // PRO
</text>

<text x="785" y="325"
      font-family="Arial,sans-serif"
      font-size="12" letter-spacing="4"
      fill="#a4b29e">
  DIGITAL COLLECTION
</text>

<path d="M1060 280 L1080 300 L1060 320 L1040 300 Z"
      fill="none" stroke="#b6ff00"
      stroke-width="3" filter="url(#glow)"/>

<!-- Auteur -->

<text x="65" y="390"
      font-family="Arial,sans-serif"
      font-size="13"
      letter-spacing="2"
      fill="#ffffff">
  DEVELOPED BY LACHI LAHLOU / 2026
</text>

</svg>
