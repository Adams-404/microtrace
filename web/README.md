# MICROTRACE website

A React + Vite landing page for MICROTRACE, a smartphone-assisted digital microscopy workstation from BIAS.

## Local development

```bash
cd web
npm install
npm run dev
```

Create a production build with `npm run build`.

## Deployment

The Vite app is rooted in this directory. In Vercel, set the project Root Directory to `web`, Framework Preset to Vite, Build Command to `npm run build`, and Output Directory to `dist`.

The primary download CTA points to the latest GitHub Release so it always leads visitors to the current Android APK assets:
https://github.com/Adams-404/microtrace/releases/latest

MICROTRACE is a research-use-only decision-support tool. It does not provide autonomous medical diagnoses.
