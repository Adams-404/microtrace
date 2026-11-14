# MICROTRACE

**Smartphone-Assisted Microscopy Workstation with On-Device Computer Vision**

> *Make every microscope more intelligent.*

[![GitHub](https://img.shields.io/badge/GitHub-Repository-blue?logo=github)](https://github.com/Adams-404/microtrace)
[![Flutter](https://img.shields.io/badge/Flutter-3.47.9-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.13.7-0175C2?logo=dart)](https://dart.dev)
[![Architecture](https://img.shields.io/badge/Architecture-Offline--First-10B981)](#architecture)
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

---

## 2. Implemented Screens & Workflows

MICROTRACE features a complete, production-quality Flutter frontend across 12 signature workstation screens:

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
13. **Workstation Settings (`/settings`):** Real-time theme switcher (**Dark Scientific**, **AMOLED Pure Black**, **Light Laboratory**), local storage management, and scientific disclaimers.

---

## 3. Design System

Designed specifically as a serious scientific instrument rather than a generic SaaS template:
- **Restrained Scientific Palette:** Deep slate surfaces (`#0B0F17`), true black AMOLED mode (`#000000`), Cerulean Cyan (`#0EA5E9`), Emerald Pass (`#10B981`), Amber Warning (`#F59E0B`), and Model Prediction Violet (`#8B5CF6`).
- **Typography:** Technical monospace for numerical metrics, confidence scores, graticule scales, and timestamps.
- **Custom Optics Components:** `MicroscopeReticleOverlay`, `QualityGauge`, `ScientificCard`, `StatusBadge`, and `FilmstripView`.

---

## 4. Architecture

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
│   ├── sessions/             # Session creation, history, and details
│   ├── capture/              # Optical capture viewport & filmstrip
│   ├── image_review/         # Field inspection & quality metrics
│   ├── analysis/             # LiteRT inference simulation pipeline
│   ├── results/              # Scientific review & bounding box overlays
│   ├── reports/              # Printable observation report
│   ├── modules/              # Module library catalog
│   ├── model_library/        # On-device model manager
│   └── settings/             # Themes, storage, and disclosures
└── shared/
    ├── models/               # Strongly-typed domain models
    └── services/             # In-memory repositories & inference abstractions
```

---

## 5. Verification & Code Quality

- **Flutter Analyze:** 0 errors, 0 warnings, 0 lints (`No issues found!`).
- **Dart Format:** 100% compliant with standard Dart conventions.
- **Widget Tests:** Passed (`MICROTRACE workstation app boots up and renders dashboard`).

---

## 6. Scientific & Medical Disclaimer

MICROTRACE is an offline-first research and laboratory decision-support tool. It is not certified as an in-vitro diagnostic medical device and does not replace professional histological, mycological, or pathological examination. All automated computer-vision predictions must be reviewed, verified, or corrected by qualified laboratory personnel.
