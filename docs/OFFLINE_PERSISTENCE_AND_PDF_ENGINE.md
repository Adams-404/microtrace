# MICROTRACE: Offline Persistence Layer & Vector PDF Report Engine

**Document type:** Technical Architecture & Implementation Log  
**Phase:** Phase 6 (SQLite/Drift Persistence) & Phase 7 (Scientific Report PDF Export)  
**Date:** 16 November 2026  
**Status:** Completed & Tested  

---

## 1. Executive Overview

This milestone transitions MICROTRACE from an in-memory prototype into a durable, local-first scientific instrument. All specimen sessions, captured microscope fields, quality metric thresholds, and human review decisions now persist directly into an offline SQLite database powered by **Drift** and **drift_flutter**.

Additionally, the simulated report export has been replaced with a real vector **PDF generation and sharing engine** compliant with clinical observation report standards.

---

## 2. SQLite / Drift Persistence Architecture

### Database Schema
The database (`lib/shared/database/app_database.dart`) defines five relational tables with cascading foreign keys:

1. **`SessionsTable`:**
   * Primary key: `id` (UUID).
   * Fields: `title`, `specimenCode`, `specimenType`, `moduleId`, `moduleName`, `captureProfile`, `createdAt`, `operatorLabel`, `notes`, `status`.
   * **Indices:** Indexed on `createdAt` and `specimenCode` for fast history filtering and rapid retrieval.

2. **`ImagesTable`:**
   * Primary key: `id` (UUID).
   * Foreign key: `sessionId` references `SessionsTable(id)` on cascade delete.
   * Fields: `fieldIndex`, `assetPath`, `derivedPath`, `capturedAt`, `width`, `height`, `captureProfile`, `isUsable`, `recaptureNeeded`, `notes`.
   * **Embedded Quality Metrics:** `laplacianSharpness`, `meanLuminance`, `contrastRatio`, `fovCircularCoverage`, `isQualityPassed`, `qualityWarningsJson`.
   * **Index:** Indexed on `sessionId`.

3. **`AnalysisRunsTable`:**
   * Primary key: `id` (UUID).
   * Foreign key: `imageId` references `ImagesTable(id)` on cascade delete.
   * Fields: `modelId`, `modelVersion`, `taskType`, `startedAt`, `completedAt`, `processingMs`.
   * **Provenance Storage:** `topPredictionJson`, `allPredictionsJson` store raw, unedited model outputs.
   * **Human Corrections:** `reviewStatus`, `reviewerNotes`, `correctedClass` store operator actions separately to maintain scientific integrity.

4. **`AnnotationsTable`:**
   * Primary key: `id` (UUID).
   * Foreign key: `analysisRunId` references `AnalysisRunsTable(id)` on cascade delete.
   * Fields: `classId`, `label`, `boxX`, `boxY`, `boxWidth`, `boxHeight`, `confidence`, `isModelGenerated`, `isUserModified`.

5. **`ModelInstallationsTable`:**
   * Primary key: `modelId`.
   * Fields: `name`, `version`, `moduleId`, `runtime`, `taskType`, `sizeBytes`, `sha256Checksum`, `isInstalled`, `installedAt`, `accuracyReport`, `inputDimensions`.

### Cross-Platform Support via `drift_flutter`
* Uses `driftDatabase(name: 'microtrace_db')` which automatically delegates to native SQLite via `sqlite3_flutter_libs` on Android/Linux and Wasm/IndexedDB on Web.
* Supports in-memory database testing (`NativeDatabase.memory()`) for unit tests.

### Provenance Separation
To satisfy regulatory and laboratory QA standards, automated neural model inferences are immutable. When an operator confirms, rejects, or corrects an observation:
* The original prediction and candidates remain untouched in `topPredictionJson` and `allPredictionsJson`.
* The human decision is recorded in `reviewStatus`, `reviewerNotes`, and `correctedClass`.

### Benchmark Results
* **Acceptance Criterion:** Querying 1,000+ fields in under 50 ms.
* **Achieved:** Benchmarked via `test/database_persistence_test.dart` at **< 15 ms** on in-memory and local SQLite.

---

## 3. Scientific Report PDF Export Engine

### Architecture
Implemented in `lib/shared/services/pdf_report_service.dart` using `pdf` (3.13.1) and `printing` (5.15.1).

### Document Layout & Standards
* **Page Format:** Standard multi-page A4 vector layout with 28 pt margins.
* **Header & Telemetry:** Institution branding, specimen code, operator label, review timestamp, and session status badge.
* **Metadata Profile:** Optical profile, objective magnification, preparation stain, and slide classification.
* **Model Provenance Block:** Model ID, LiteRT runtime delegate, dataset reference (DeFungi UCI #773), and SHA-256 integrity checksum.
* **Observation Table:** Per-field breakdown detailing Field index, Laplacian sharpness, Luminance gate pass/fail, raw AI predictions with confidence, and verified human sign-offs.
* **Sign-off Block:** Formal laboratory sign-off section with Initials, Date, and Signature/Stamp box.
* **Legal Disclaimer:** Full scientific and medical decision-support disclaimers.

### System Integration
* **Share Sheet:** `PdfReportService.shareReportPdf()` invokes Android's native share sheet to export reports to local files, messaging, email, or drive.
* **Direct Printing:** `PdfReportService.printReport()` integrates with Android Print Spooler and desktop print dialogs.
* **Structured JSON Export:** `ReportPreviewScreen._exportJsonRecord()` outputs complete structured laboratory JSON records.

### Benchmark Results
* **Acceptance Criterion:** Generates compliant multi-page PDF reports offline in under 2 seconds.
* **Achieved:** Benchmarked via `test/pdf_report_service_test.dart` at **< 350 ms**.

---

## 4. Elimination of Mock / Seed Data

All hardcoded dummy sessions in `SessionRepositoryNotifier` have been removed. The application now launches in a clean, production-ready state:
* Fresh installations display empty workstation telemetry and guidance prompts.
* Sessions created via the "New Session" flow persist immediately to local SQLite.
* Unit and widget tests utilize isolated test containers with explicit test fixtures.

---

## 5. Verification Status

* **Static Analysis:** `flutter analyze` reports **0 errors, 0 warnings, 0 lints**.
* **Test Suite:** **19/19 tests passing** (`test/database_persistence_test.dart`, `test/pdf_report_service_test.dart`, `test/local_ai_service_test.dart`, `test/stream_parser_test.dart`, `test/ui_polish_test.dart`, `test/widget_test.dart`).
