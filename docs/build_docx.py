from pathlib import Path

from docx import Document
from docx.enum.section import WD_SECTION
from docx.enum.table import WD_TABLE_ALIGNMENT
from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.shared import Inches, Pt, RGBColor


ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "docs" / "MICROTRACE_Technical_Evidence.docx"
SCREENSHOTS = ROOT / "screenshots_for_evidence_pdf"


def add_title(document, title, subtitle=None):
    p = document.add_paragraph()
    p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    r = p.add_run(title)
    r.bold = True
    r.font.size = Pt(28)
    r.font.color.rgb = RGBColor(20, 25, 30)
    if subtitle:
        p = document.add_paragraph()
        p.alignment = WD_ALIGN_PARAGRAPH.CENTER
        r = p.add_run(subtitle)
        r.font.size = Pt(13)
        r.font.color.rgb = RGBColor(90, 100, 110)


def add_body(document, text):
    p = document.add_paragraph(text)
    p.paragraph_format.space_after = Pt(7)
    return p


def add_bullets(document, items):
    for item in items:
        p = document.add_paragraph(item, style="List Bullet")
        p.paragraph_format.space_after = Pt(3)


def add_screenshot(document, filename, caption):
    path = SCREENSHOTS / filename
    if path.exists():
        p = document.add_paragraph()
        p.alignment = WD_ALIGN_PARAGRAPH.CENTER
        p.add_run().add_picture(str(path), width=Inches(2.4))
    p = document.add_paragraph()
    p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    r = p.add_run(caption)
    r.italic = True
    r.font.size = Pt(9)
    r.font.color.rgb = RGBColor(90, 100, 110)


document = Document()
section = document.sections[0]
section.top_margin = Inches(0.65)
section.bottom_margin = Inches(0.65)
section.left_margin = Inches(0.75)
section.right_margin = Inches(0.75)

styles = document.styles
styles["Normal"].font.name = "Arial"
styles["Normal"].font.size = Pt(10)
for name in ("Heading 1", "Heading 2", "Heading 3"):
    styles[name].font.name = "Arial"

logo = ROOT / "docs" / "branding" / "BIAS-logo-white.png"
if logo.exists():
    p = document.add_paragraph()
    p.alignment = WD_ALIGN_PARAGRAPH.RIGHT
    p.add_run().add_picture(str(logo), width=Inches(1.35))

add_title(
    document,
    "MICROTRACE",
    "Technical Evidence & Product Development Dossier",
)
add_body(
    document,
    "A product-ready Android microscopy workstation that extends conventional optical microscopes with smartphone-assisted capture, structured laboratory sessions and a clear path to validated decision support.",
)
add_body(document, "Prepared for the USPF Changemaker Challenge 2026")
add_body(document, "BIAS · Basira Institute for Advanced Science · bias.science")
document.add_page_break()

document.add_heading("1. Executive Overview", level=1)
add_body(
    document,
    "MICROTRACE is an engineered Flutter application for smartphone-assisted microscopy. It organizes specimen metadata, microscopy sessions, captured fields, quality review, analysis stages, scientific review, model metadata and reporting in one instrument-like interface.",
)
add_body(
    document,
    "The product is designed for laboratories that already depend on conventional optical microscopes and need a practical path to structured digital records, reviewable image workflows and local decision support.",
)
document.add_heading("Current product position", level=2)
add_bullets(
    document,
    [
        "Implemented Flutter workstation shell with routed dashboard, capture, sessions, review, analysis, results, reporting, modules, models, settings and assistant surfaces.",
        "Typed microscopy domain models for sessions, images, quality metrics, predictions, annotations and reviewer status.",
        "Implemented loopback LocalAiService with model health checks, streaming responses, cancellation and explicit offline errors.",
        "Release workflow covering formatting, static analysis, tests, Android APK build and web bundle build.",
    ],
)
add_body(
    document,
    "The current software establishes the production integration seam and product workflow. Specialist model execution, camera calibration, durable records and laboratory evaluation are the next controlled-release steps.",
)

document.add_heading("2. The MICROTRACE Approach", level=1)
add_body(
    document,
    "Conventional optical microscope → smartphone eyepiece adapter → Android smartphone → MICROTRACE application → structured microscopy workflow.",
)
add_body(
    document,
    "The phone adds a screen, camera, local compute and a portable record to existing optical infrastructure. MICROTRACE adds the workflow layer: specimen context, capture profiles, quality review, model metadata, human sign-off and reporting.",
)

document.add_heading("3. System Architecture & Technology", level=1)
add_body(
    document,
    "The repository is organized as a feature-oriented Flutter application using GoRouter, Riverpod state notifiers, typed domain models, shared scientific UI components and service classes.",
)
add_bullets(
    document,
    [
        "Flutter/Dart application shell with theme tokens, responsive screens and bundled fonts/assets.",
        "GoRouter navigation across the workstation workflow.",
        "Riverpod repositories for session, module, model and storage state.",
        "LocalAiService and StreamParser for an OpenAI-compatible phone-local model endpoint.",
        "LiteRT model metadata surfaces for runtime, tensor shape, checksum and installation state.",
        "GitHub Actions release workflow for repeatable analysis, tests and build artifacts.",
    ],
)

document.add_heading("4. Application & Feature Evidence", level=1)
add_screenshot(
    document,
    "Screenshot_20261115-215052.jpg",
    "Dashboard: workstation telemetry, new-session entry point, local AI entry point and navigation.",
)
add_screenshot(
    document,
    "Screenshot_20261115-215058.jpg",
    "Local AI copilot: guided prompts, loopback status feedback and on-device privacy language.",
)
add_screenshot(
    document,
    "Screenshot_20261115-215106.jpg",
    "Session history: searchable archive with specimen codes, statuses, preparation details and field counts.",
)
add_screenshot(
    document,
    "Screenshot_20261115-215108.jpg",
    "Module library: mycology marked ready, with future modules separated as roadmap work.",
)
add_screenshot(
    document,
    "Screenshot_20261115-215119.jpg",
    "Model library: runtime labels, tensor shapes, installation state, checksums and evaluation fields.",
)
add_screenshot(
    document,
    "Screenshot_20261115-215128.jpg",
    "Session detail: specimen metadata, operator information, report action and reviewed microscopic field.",
)

document.add_heading("5. AI-Assisted Microscopy", level=1)
add_body(
    document,
    "MICROTRACE separates specialized microscopy model integration from the local language-model copilot. The image pathway is designed for validated, versioned LiteRT model packages with explicit preprocessing, quality gates, posterior outputs and human review. The language model pathway is an implemented OpenAI-compatible loopback client for workflow assistance, explanation and session-grounded summaries.",
)
add_body(
    document,
    "The copilot is not represented as a microscopy classifier and does not have diagnostic authority. Human review remains the boundary between model output and a laboratory finding.",
)

document.add_heading("6. Offline-First Design", level=1)
add_bullets(
    document,
    [
        "Local Flutter state for sessions, images, analyses, modules and model metadata.",
        "SharedPreferences for onboarding, theme and assistant settings.",
        "Optional local model endpoint at 127.0.0.1:8080/v1.",
        "Streaming parser for fragmented SSE, server errors and plain-text fallback.",
        "Explicit offline and local-model error states in the product interface.",
    ],
)
add_body(
    document,
    "The controlled-release hardening phase will add durable specimen/image storage, Android camera acquisition, adapter calibration, validated LiteRT packages, backup/export controls and device migration policy.",
)

document.add_heading("7. Development Progress", level=1)
add_body(document, "The current working tree was verified with flutter analyze and flutter test; the analyzer reported no issues and the test suite passed.")
add_body(
    document,
    "The repository includes source, tests, bundled assets and a GitHub Actions workflow that formats, analyzes, tests and builds Android and web artifacts. This provides a repeatable engineering base for controlled pilot preparation.",
)

document.add_heading("8. Practical Applications & Intended Users", level=1)
add_bullets(
    document,
    [
        "Medical laboratory scientists and laboratory technologists.",
        "Primary healthcare and community laboratories using optical microscopy.",
        "Research and teaching laboratories needing a structured image record.",
        "Qualified microscopists seeking reviewable decision support rather than an opaque answer.",
    ],
)
add_body(
    document,
    "The installed module focus is mycology, covering culture mounts, KOH mounts, lactophenol cotton blue, Gram-stained mucosal smears and fungal morphology. The platform is structured to expand into parasitology, malaria microscopy and cell analysis.",
)

document.add_heading("9. Product Refinement & Roadmap", level=1)
table = document.add_table(rows=1, cols=3)
table.alignment = WD_TABLE_ALIGNMENT.CENTER
table.style = "Table Grid"
hdr = table.rows[0].cells
hdr[0].text = "Workstream"
hdr[1].text = "Next phase"
hdr[2].text = "Evidence required"
rows = [
    ("Hardware", "Adapter fit, camera acquisition, focus guidance and device calibration.", "Compatibility matrix and repeatable capture procedure."),
    ("Computer vision", "Connect and evaluate validated LiteRT model packages.", "Held-out evaluation, error analysis and provenance."),
    ("Records", "Durable local specimen/image storage with export and backup.", "Recovery, audit and privacy review."),
    ("Evaluation", "Controlled workflow evaluation with qualified personnel.", "Usability findings, failure modes and protocol adherence."),
]
for row in rows:
    cells = table.add_row().cells
    for i, value in enumerate(row):
        cells[i].text = value

document.add_heading("10. References & Project Links", level=1)
add_body(document, "Android offline-first architecture: https://developer.android.com/topic/architecture/data-layer/offline-first")
add_body(document, "Google LiteRT: https://developers.google.com/edge/litert/overview")
add_body(document, "MICROTRACE repository: https://github.com/Adams-404/microtrace")
add_body(document, "BIAS: https://www.bias.science/")
add_body(document, "MICROTRACE product domain: https://microtrace.bias.science/")
add_body(
    document,
    "Positioning: research and laboratory decision-support product in controlled-release preparation. Not a certified in-vitro diagnostic device and not a replacement for professional examination.",
)

document.save(OUT)
print(OUT)
