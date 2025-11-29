#!/usr/bin/env bash
set -e

# SCRIPT: build_innprontum_zip.sh
# Propósito: crear estructura del proyecto Innprontum (React + Vite + Tailwind)
# y comprimirla en innprontum-website.zip
#
# Uso:
# chmod +x build_innprontum_zip.sh
# ./build_innprontum_zip.sh
#
# Resultado: innprontum-website/ (carpeta) y innprontum-website.zip

ROOTDIR="innprontum-website"

echo "Creando carpeta del proyecto: ${ROOTDIR}"
rm -rf "${ROOTDIR}"
mkdir -p "${ROOTDIR}/public" "${ROOTDIR}/src/components" "${ROOTDIR}/assets"

echo "Creando package.json..."
cat > "${ROOTDIR}/package.json" <<'JSON'
{
  "name": "innprontum-website",
  "version": "1.0.0",
  "private": true,
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview",
    "lint": "eslint . --ext .js,.jsx"
  },
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0"
  },
  "devDependencies": {
    "autoprefixer": "^10.4.14",
    "postcss": "^8.4.24",
    "tailwindcss": "^3.4.8",
    "vite": "^5.0.0"
  }
}
JSON

echo "Creando tailwind.config.js..."
cat > "${ROOTDIR}/tailwind.config.js" <<'TAIL'
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./index.html",
    "./src/**/*.{js,jsx,ts,tsx}"
  ],
  theme: {
    extend: {
      colors: {
        brand: {
          50: '#fdfbf7',
          100: '#fff6e6',
          500: '#00a99d',
          600: '#007a71',
          accent: '#ffd166'
        }
      },
      fontFamily: {
        inter: ['Inter', 'sans-serif']
      }
    }
  },
  plugins: []
}
TAIL

echo "Creando postcss.config.js..."
cat > "${ROOTDIR}/postcss.config.js" <<'PC'
module.exports = {
  plugins: {
    tailwindcss: {},
    autoprefixer: {}
  }
}
PC

echo "Creando public/index.html..."
cat > "${ROOTDIR}/public/index.html" <<'HTML'
<!doctype html>
<html lang="es">
  <head>
    <meta charset="utf-8" />
    <link rel="icon" href="/logo.png" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Telemetría Inteligente — Innprontum</title>
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/src/index.jsx"></script>
  </body>
</html>
HTML

echo "Añadiendo placeholder logo y assets..."
# placeholder logo (simple 1x1 png encoded)
cat > "${ROOTDIR}/public/logo.png" <<'PNG_BASE64'
iVBORw0KGgoAAAANSUhEUgAAAOEAAADhCAYAAACc3h6dAAAAAklEQVR4AewaftIAAABYSURBVO3BQY4AAAwDMO5fNNTmQAAAAAAAAAAAAAAAAAAAAAAAAD8GZcAAGgkq0QAAAAASUVORK5CYII=
PNG_BASE64
# decode it to binary
base64 --decode "${ROOTDIR}/public/logo.png" > "${ROOTDIR}/public/_logo.png" 2>/dev/null || true
# replace with a simple SVG if base64 decode above fails:
if [ -f "${ROOTDIR}/public/_logo.png" ]; then
  mv "${ROOTDIR}/public/_logo.png" "${ROOTDIR}/public/logo.png"
else
  cat > "${ROOTDIR}/public/logo.png" <<'SVG'
<svg xmlns="http://www.w3.org/2000/svg" width="200" height="60">
  <rect width="200" height="60" fill="#00a99d"/>
  <text x="20" y="38" font-size="20" font-family="Arial" fill="#ffffff">Innprontum</text>
</svg>
SVG
fi

# small placeholder image
cat > "${ROOTDIR}/assets/placeholder.png" <<'SVG'
<svg xmlns="http://www.w3.org/2000/svg" width="1200" height="800">
  <rect width="1200" height="800" fill="#e9f6f5"/>
  <text x="50%" y="50%" dominant-baseline="middle" text-anchor="middle" font-size="36" fill="#026a63" font-family="Arial">Mockup Tablero KPI</text>
</svg>
SVG

echo "Creando src/index.jsx..."
cat > "${ROOTDIR}/src/index.jsx" <<'INDEX'
import React from 'react'
import { createRoot } from 'react-dom/client'
import App from './App'
import './main.css'

createRoot(document.getElementById('root')).render(<App />)
INDEX

echo "Creando src/main.css..."
cat > "${ROOTDIR}/src/main.css" <<'CSS'
@tailwind base;
@tailwind components;
@tailwind utilities;

/* Custom styles */
:root {
  --accent: #00a99d;
  --accent-2: #ffd166;
  --dark: #052028;
}
body {
  @apply bg-[linear-gradient(180deg,#fbfeff,#f0f9f9)] text-[var(--dark)] font-inter;
}
.card {
  @apply bg-white rounded-xl shadow-lg;
}
CSS

echo "Creando src/App.jsx..."
cat > "${ROOTDIR}/src/App.jsx" <<'APP'
import React from 'react'
import Header from './components/Header'
import Hero from './components/Hero'
import Benefits from './components/Benefits'
import Industries from './components/Industries'
import Process from './components/Process'
import Footer from './components/Footer'

export default function App(){
  return (
    <div>
      <Header />
      <main>
        <Hero />
        <section className="py-12"><Benefits /></section>
        <section className="py-12 bg-white"><Industries /></section>
        <section className="py-12"><Process /></section>
      </main>
      <Footer />
    </div>
  )
}
APP

echo "Creando componentes..."
cat > "${ROOTDIR}/src/components/Header.jsx" <<'HED'
import React from 'react'

export default function Header(){
  return (
    <header className="flex items-center justify-between p-6 max-w-7xl mx-auto">
      <img src="/logo.png" alt="Innprontum" className="h-12"/>
      <nav className="flex gap-3">
        <a href="#proceso" className="px-3 py-2 rounded-md border border-gray-200">Proceso</a>
        <a href="https://calendly.com/innprontum-demos/45min" className="px-4 py-2 rounded-md font-semibold bg-[var(--accent-2)]">Agenda sesión</a>
      </nav>
    </header>
  )
}
HED

cat > "${ROOTDIR}/src/components/Hero.jsx" <<'HERO'
import React from 'react'

export default function Hero(){
  return (
    <section className="container mx-auto px-6 py-16 grid lg:grid-cols-2 gap-10 items-center">
      <div>
        <h1 className="text-4xl font-bold leading-tight">Estrategia, datos y control para flotas que no pueden fallar</h1>
        <p className="mt-6 text-lg text-gray-600 max-w-xl">Telemetría inteligente y análisis avanzado para que tomes decisiones precisas, reduzcas costos y operes con la máxima eficiencia posible.</p>
        <div className="mt-8 flex gap-4">
          <a href="https://calendly.com/innprontum-demos/45min" className="bg-[var(--accent-2)] px-5 py-3 rounded-lg font-bold">Solicitar sesión estratégica</a>
          <a href="#proceso" className="px-4 py-3 rounded-lg border">Ver proceso</a>
        </div>

        <div className="mt-6 flex gap-3">
          <div className="card p-3 text-center">
            <div className="text-sm text-gray-500">Ahorro estimado</div>
            <div className="text-xl font-bold text-[var(--accent)]">25%</div>
          </div>
          <div className="card p-3 text-center">
            <div className="text-sm text-gray-500">Mejora OTIF</div>
            <div className="text-xl font-bold text-[var(--accent)]">30%</div>
          </div>
          <div className="card p-3 text-center">
            <div className="text-sm text-gray-500">Reducción mermas</div>
            <div className="text-xl font-bold text-[var(--accent)]">40%</div>
          </div>
        </div>
      </div>

      <div className="rounded-xl bg-gradient-to-br from-slate-50 to-slate-100 h-96 flex items-center justify-center">
        <div className="w-11/12 h-3/4 bg-white rounded-lg shadow-inner flex items-center justify-center">Tablero KPI (vista ejecutiva)</div>
      </div>
    </section>
  )
}
HERO

cat > "${ROOTDIR}/src/components/Benefits.jsx" <<'BEN'
import React from 'react'

export default function Benefits(){
  const items = [
    {t:'Visibilidad operacional total', d:'Control en tiempo real de activos, hábitos, rutas y desvíos críticos.'},
    {t:'Reducción inmediata de fugas', d:'Detección y alerta de comportamientos que generan gasto, riesgo o pérdidas.'},
    {t:'KPIs accionables', d:'Decisiones con datos claros, predictivos y comparativos desde un tablero único.'}
  ]
  return (
    <div className="max-w-7xl mx-auto px-6">
      <h2 className="text-2xl font-bold mb-6">Lo que directivos de alto nivel obtienen</h2>
      <div className="grid md:grid-cols-3 gap-6">
        {items.map((it,i)=>(
          <div className="card p-6" key={i}>
            <h3 className="text-lg font-semibold mb-2">{it.t}</h3>
            <p className="text-gray-600">{it.d}</p>
          </div>
        ))}
      </div>
    </div>
  )
}
BEN

cat > "${ROOTDIR}/src/components/Industries.jsx" <<'IND'
import React from 'react'

export default function Industries(){
  const sectors = [
    {t:'Logística y Transporte', d:'Control total de rutas y flotas.'},
    {t:'Retail y Última Milla', d:'Precisión en entregas y tiempos.'},
    {t:'Construcción y Combustible', d:'Seguridad y control de activos.'},
    {t:'Alimentos y Bebidas', d:'Monitoreo crítico de temperatura.'}
  ]
  return (
    <div className="max-w-7xl mx-auto px-6">
      <h2 className="text-2xl font-bold mb-6">Diseñado para operaciones críticas</h2>
      <div className="grid md:grid-cols-4 gap-6">
        {sectors.map((s,i)=>(
          <div className="card p-5" key={i}>
            <h4 className="font-semibold">{s.t}</h4>
            <p className="text-gray-600 mt-2">{s.d}</p>
          </div>
        ))}
      </div>
    </div>
  )
}
IND

cat > "${ROOTDIR}/src/components/Process.jsx" <<'PROC'
import React from 'react'

export default function Process(){
  return (
    <div className="max-w-7xl mx-auto px-6" id="proceso">
      <header className="mb-6">
        <h2 className="text-2xl font-bold">De la evaluación al impacto operativo real</h2>
        <p className="text-gray-600 mt-2 max-w-2xl">Un proceso ejecutivo, claro y medible: desde diagnóstico hasta piloto y despliegue, diseñado para producir resultados verificables en tus KPIs.</p>
      </header>

      <div className="grid lg:grid-cols-2 gap-8 items-start">
        <div>
          <div className="step card p-5 mb-4 flex gap-4">
            <div className="w-14 h-14 rounded-lg flex items-center justify-center font-bold text-white" style={{background:'linear-gradient(180deg,#00a99d,#007a71)'}}>1</div>
            <div>
              <h3 className="font-semibold">Diagnóstico ejecutivo para comprender tu operación</h3>
              <p className="text-gray-600">Analizamos procesos, puntos de fricción y KPIs actuales para establecer una línea base clara y objetivos medibles.</p>
            </div>
          </div>

          <div className="step card p-5 mb-4 flex gap-4">
            <div className="w-14 h-14 rounded-lg flex items-center justify-center font-bold text-white" style={{background:'linear-gradient(180deg,#2b8cff,#005bb5)'}}>2</div>
            <div>
              <h3 className="font-semibold">Te mostramos el ahorro y KPI proyectado</h3>
              <p className="text-gray-600">Escenarios de ahorro, ROI estimado y un bosquejo del tablero KPI para visualizar el impacto cuantitativo.</p>
            </div>
          </div>

          <div className="step card p-5 flex gap-4">
            <div className="w-14 h-14 rounded-lg flex items-center justify-center font-bold" style={{background:'linear-gradient(180deg,#ff9f43,#c76a00)', color:'#052028'}}>3</div>
            <div>
              <h3 className="font-semibold">Definimos el plan de implementación inteligente</h3>
              <p className="text-gray-600">Etapas, unidades piloto, cronograma y métricas para un despliegue ágil que genere resultados rápidos.</p>
            </div>
          </div>
        </div>

        <aside className="card p-6 bg-gradient-to-b from-[#022d2d] to-[#052a2a] text-white">
          <h4 className="text-lg font-semibold">Evaluación Ejecutiva + Piloto KPI</h4>
          <p className="text-sm text-[#cfe9e6] mt-2">Workshop estratégico, piloto 30 días y tablero KPI personalizado con indicadores clave.</p>
          <ul className="mt-4 ml-4 list-disc text-sm text-[#cfe9e6]">
            <li>Diagnóstico (2 horas)</li>
            <li>Piloto con tablero KPI</li>
            <li>Roadmap de escalamiento</li>
          </ul>
          <a href="https://calendly.com/innprontum-demos/45min" className="block mt-6 bg-[var(--accent-2)] text-[var(--dark)] px-4 py-3 rounded-md font-bold text-center">Agenda sesión estratégica</a>
          <p className="text-xs mt-3 text-[#9fcfc9]">20–45 minutos. Presentación ejecutiva y plan de trabajo inicial.</p>
        </aside>
      </div>
    </div>
  )
}
PROC

cat > "${ROOTDIR}/src/components/Footer.jsx" <<'FTR'
import React from 'react'

export default function Footer(){
  return (
    <footer className="py-10 text-center text-sm text-gray-500">
      © {new Date().getFullYear()} Telemetría Inteligente. Todos los derechos reservados.
    </footer>
  )
}
FTR

echo "Creando README.md..."
cat > "${ROOTDIR}/README.md" <<'README'
Proyecto: Innprontum - Telemetría Inteligente (versión premium)
Generado automáticamente por script. Contiene una SPA React (Vite) con TailwindCSS.

Instrucciones rápidas:
1) npm install
2) npm run dev
3) reemplaza public/logo.png por tu logo real

README
README

echo "Instalando dependencias (solo package.json creado; no instalaré npm deps por ti)..."
# No ejecutar npm install automáticamente para evitar modificar entorno del usuario.

echo "Comprimiendo en innprontum-website.zip..."
zip -r "${ROOTDIR}.zip" "${ROOTDIR}" >/dev/null

echo "Listo. Archivo generado: ${ROOTDIR}.zip"
echo
echo "Siguientes pasos recomendados:"
echo "1) cd ${ROOTDIR}"
echo "2) npm install"
echo "3) npm run dev"
echo
echo "Si deseas, puedo ahora mostrar cómo subir el ZIP a Vercel o Netlify, o generar un repo Git con estos archivos."
