/** @type {import('tailwindcss').Config} */
export default {
  content: [
    './index.html',
    './2025portfolio.html',
    './2025resume.html',
  ],
  theme: {
    extend: {
      colors: {
        primary: '#2563eb',
        'primary-dark': '#1d4ed8',
        secondary: '#10b981',
        accent: '#f59e0b',
        background: '#0f172a',
        surface: '#1e293b',
        'surface-light': '#334155',
      },
      fontFamily: {
        'code': ['JetBrains Mono', 'monospace'],
      },
      animation: {
        'drift': 'drift 20s infinite linear',
      },
      keyframes: {
        drift: {
          '0%, 100%': { transform: 'translate(0, 0) rotate(0deg)' },
          '33%': { transform: 'translate(30px, -30px) rotate(120deg)' },
          '66%': { transform: 'translate(-20px, 20px) rotate(240deg)' },
        },
      },
    },
  },
  plugins: [],
  safelist: [
    // Add classes that might be generated dynamically
    'text-blue-600',
    'text-green-600',
    'text-purple-600',
    'bg-blue-100',
    'bg-green-100',
    'bg-purple-100',
    'border-blue-600',
    'border-green-600',
  ],
}
