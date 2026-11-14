# MICROTRACE

**Smartphone-Assisted Microscopy Workstation with On-Device Computer Vision**

> *Make every microscope more intelligent.*

[![GitHub](https://img.shields.io/badge/GitHub-Repository-blue?logo=github)](https://github.com/Adams-404/microtrace)
[![Flutter](https://img.shields.io/badge/Flutter-3.47.9-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.13.7-0175C2?logo=dart)](https://dart.dev)
[![Architecture](https://img.shields.io/badge/Architecture-Offline--First-10B981)](#architecture)
[![Local AI](https://img.shields.io/badge/Local_AI-On--Device-C8F751)](#local-ai-copilot)
[![License](https://img.shields.io/badge/License-Research_Use_Only-orange)](#scientific-integrity)

---

## 1. Executive Summary

**MICROTRACE** is an offline-first mobile microscopy workstation that turns a conventional optical microscope and an Android smartphone into a digital laboratory decision-support system using smartphone eyepiece adapters.

### Core Principles
- **Offline-First Operation:** Local-first records, local neural runtime, zero mandatory cloud connectivity.
- **Privacy-First Data Handling:** All specimen fields and records remain strictly within app-private local storage.
- **Modular Scientific Analysis:** Platform architecture supporting interchangeable modules (Mycology, Parasitology, Malaria, Cell Counting).
- **Human-in-the-Loop Verification:** Explicit separation between automated model predictions and microscopist-verified observations.
- **Traceable Scientific Sessions:** Every observation is tied to specimen metadata, capture profiles, model checksums, and reviewer sign-offs.
- **On-Device AI Copilot:** A locally hosted language model answers questions about sessions, fields, quality metrics and predictions — no cloud, no uploads.

---

## 2. Implemented Screens & Workflows

MICROTRACE features a complete, production-quality Flutter frontend across 14 signature workstation screens:

1. **Onboarding (`/onboarding`):** Guided first-launch experience detailing optical microscope alignment, on-device LiteRT architecture, and human review responsibilities.
2. **Main Dashboard (`/`):** Workspace telemetry, quick session initialization, recent slide records, module readiness, and instant theme switching.
3. **New Microscopy Session (`/new-session`):** Specimen registration form capturing slide IDs, preparation types, optical objectives, and microscopist initials with instant validation.
4. **Capture Workspace (`/capture/:sessionId`):** Central interactive optical viewport with pinch/zoom, reticle graticule overlay (25 µm scale), real-time Laplacian focus meter, simulated optical feeds (Aspergillus, Candida, Trichophyton, Penicillium), shutter animation, and capture filmstrip.
5. **Image Review (`/session/:id/image/:imgId`):** High-resolution pinch/pan field inspection, heuristic quality gates (Sharpness, Luminance, Eyepiece Alignment), usability flags, and operator notes.
6. **Analysis Workspace (`/session/:id/image/:imgId/analysis`):** Multi-stage on-device LiteRT neural execution pipeline simulation (aperture crop, quality thresholding, neural inference, posterior decoding).
7. **Results & Scientific Review (`/session/:id/image/:imgId/results`):** Decision-support interface with ROI bounding box overlays, confidence distributions, and human sign-off actions (**Confirm**, **Correct**, **Reject**, **Needs Expert Review**).
8. **Session History (`/sessions`):** Searchable laboratory archive with status filters (In Progress, Completed, Reviewed) and rich specimen cards.
9. **Session Details (`/session/:id`):** Microscopic field gallery, specimen metadata table, and session-level observation summaries.
10. **Report Preview (`/session/:id/report`):** Formal scientific observation report ready for PDF export, model provenance disclosure, and verification sign-off blocks.
11. **Modules Library (`/modules`):** Module catalog highlighting Mycology (Installed & Ready) alongside future roadmap modules (Parasitology, Malaria Smear, Hemocytometry).
12. **Model Library (`/models`):** On-device LiteRT neural model manager showing model sizes, checksums, tensor input formats, and offline update workflows.
13. **Workstation Settings (`/settings`):** Real-time theme switcher (**Darkroom**, **AMOLED**, **Daylight**), Local AI server configuration, local storage management, and scientific disclaimers.
14. **Local AI Copilot (`/assistant`):** Streaming chat with the phone's on-device model, optionally grounded on a single session (`/assistant?session=<id>`) with a factual summary of captures, quality gates and model predictions.

---

## 3. Design System

Designed specifically as a serious scientific instrument rather than a generic SaaS template:
- **Darkroom-First Palette:** Near-black surfaces (`#06080D`), true-black AMOLED mode (`#000000`), and a single bio-luminescent lime signal color (`#C8F751`). No decorative gradients — flat surfaces separated by hairline borders.
- **Semantic Tokens:** Every screen reads surfaces, text and semantic channels through an `AppTokens` theme extension, so Darkroom, AMOLED and Daylight stay consistent.
- **Typography:** Inter for interface text and JetBrains Mono for specimen codes, metrics, confidence scores, graticule scales and timestamps. Both fonts are bundled for offline use.
- **Motion & Touch:** A floating glass navigation bar with stroke (outline) active tabs, and a shared `Haptics` vocabulary (tap, select, success, warning) wired across cards, chips, navigation and actions.
- **Custom Optics Components:** `MicroscopeReticleOverlay`, `QualityGauge`, `ScientificCard`, `StatusBadge`, `FloatingNavBar` and `FilmstripView`.

---

## 4. Local AI Copilot

MICROTRACE reuses the phone's existing on-device model server — the same **Clearport / llama.cpp** stack that powers the Clearport chat app. No model is bundled and no request leaves the device.

**How it works**
- An OpenAI-compatible client (`LocalAiService`) talks to `http://127.0.0.1:8080/v1` by default, with optional model ID, API key, temperature and a live connection test in **Settings → Local AI Copilot**.
- Responses stream token-by-token through a parser that understands SSE (`data:` frames), Ollama newline-delimited JSON and plain text.
- The copilot can be opened standalone from the dashboard, or **grounded on a session** from the session detail screen. Grounding serialises only verified app facts: specimen metadata, capture profile, per-field quality metrics, top prediction, candidate classes, confidence values and reviewer notes.
- The system prompt keeps the model concise, tells it to refuse to invent missing data, and requires a human-verification reminder on every clinical answer.

**Set up the model on Android (Termux)**
```bash
# One-time install of the Clearport CLI
pkg install -y curl && curl -fsSL https://raw.githubusercontent.com/Adams-404/clearport-cli/main/install.sh | bash

# Place a GGUF model in ~/models, then start the local server
clearport local-models
clearport use ~/models/your-model.gguf
clearport start
```

The app and CLI share the same endpoint, so a model already serving Clearport works with MICROTRACE immediately. On the Flutter web preview, `127.0.0.1:8080` resolves to the development machine, which makes UI testing easy.

**Safety**
- The assistant is decision support only. It never returns a definitive diagnosis and always defers to a qualified microscopist.
- Session context is truncated (first 8 fields, top 3 candidate classes) to keep small 1B-class models coherent.
- No telemetry, no analytics, no remote inference.

---

## 5. Architecture

```
lib/
├── app/
│   ├── app.dart              # Root application widget with theme switching
│   ├── router/app_router.dart # Declarative GoRouter with ShellRoute navigation
│   └── theme/                # Scientific color tokens, typography, and themes
├── core/
│   ├── constants/            # Scientific constants & disclaimers
│   ├── utils/                # Number, date, byte formatters
│   └── widgets/              # Reticles, gauges, badges, cards, app bars
├── features/
│   ├── onboarding/           # First-launch guidance
│   ├── dashboard/            # Laboratory dashboard
│   ├── assistant/            # Local AI chat, grounding and controller
│   ├── sessions/             # Session creation, history, and details
│   ├── capture/              # Optical capture viewport & filmstrip
│   ├── image_review/         # Field inspection & quality metrics
│   ├── analysis/             # LiteRT inference simulation pipeline
│   ├── results/              # Scientific review & bounding box overlays
│   ├── reports/              # Printable observation report
│   ├── modules/              # Module library catalog
│   ├── model_library/        # On-device model manager
│   └── settings/             # Themes, storage, Local AI and disclosures
└── shared/
    ├── models/               # Strongly-typed domain models
    └── services/             # Repositories, local AI client, stream parser
```

---

## 6. Verification & Code Quality

- **Flutter Analyze:** 0 errors, 0 warnings, 0 lints (`No issues found!`).
- **Dart Format:** 100% compliant with standard Dart conventions.
- **Widget Tests:** Passed (`MICROTRACE workstation app boots up and renders dashboard`).
- **Streaming Tests:** OpenAI SSE parsing, server-side error payloads and plain-text fallback are covered by `test/stream_parser_test.dart`.
- **Visual Verification:** Dashboard, floating navigation, session screens and the Local AI copilot are checked against a `flutter run -d web-server` preview.

---

## 7. Scientific & Medical Disclaimer

MICROTRACE is an offline-first research and laboratory decision-support tool. It is not certified as an in-vitro diagnostic medical device and does not replace professional histological, mycological, or pathological examination. All automated computer-vision predictions must be reviewed, verified, or corrected by qualified laboratory personnel.
