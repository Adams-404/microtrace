# MICROTRACE

## Product, Research & Engineering Specification

**Document type:** Product requirements + technical design + research
findings\
**Status:** Hackathon concept / MVP specification\
**Prepared:** 13 November 2026\
**Primary platform:** Android (Flutter)\
**Core principle:** Smartphone-assisted microscopy with on-device
computer vision\
**Working tagline:** *Make every microscope more intelligent.*

------------------------------------------------------------------------

## 1. Executive summary

MICROTRACE is an offline-first mobile microscopy assistant that turns a
conventional optical microscope and an Android smartphone into a
portable digital microscopy workstation.

A user attaches a phone camera to a microscope eyepiece, captures
microscopic fields, and runs specialized computer-vision models directly
on the phone. The application helps organize image acquisition, assess
image quality, detect or classify objects supported by a selected model,
count detected objects where the model is validated for counting, and
produce traceable observation reports.

MICROTRACE is not intended to replace a trained microscopist, a clinical
laboratory, a validated diagnostic test, or a pathologist. It is a
research and laboratory decision-support tool. Its outputs must remain
reviewable, editable, and attributable to the model version and image
that produced them.

The product's differentiator is not simply "AI detects things in
microscope images." Published research already demonstrates
smartphone-based microscopy and on-device parasite detection. MICROTRACE
aims to make this capability reusable and practical through:

1.  A guided microscope-to-phone image acquisition workflow.
2.  Image-quality checks before analysis.
3.  A modular model system for different microscopy tasks.
4.  Offline inference and local-first records.
5.  Human review and correction of model outputs.
6.  Reproducible observations, provenance, and exportable reports.
7.  A future pathway for locally collected and expert-annotated
    microscopy data.

### One-sentence pitch

MICROTRACE is an offline-first smartphone microscopy workstation that
helps laboratories capture, analyze, review, and document microscopic
observations using modular computer-vision models that run directly on
the phone.

------------------------------------------------------------------------

## 2. The problem

Microscopy remains central to many areas of biology, microbiology,
parasitology, mycology, and laboratory medicine. However, routine
microscopy workflows can be constrained by:

-   Dependence on trained personnel to inspect and interpret slides.
-   Manual counting and repetitive visual inspection.
-   Inconsistent image capture between users, microscopes, and phones.
-   Poor documentation of the exact field of view that was examined.
-   Images scattered across phone galleries, messaging apps, and
    computers.
-   Limited access to expensive microscope cameras and desktop analysis
    software.
-   Unreliable internet access in some laboratories and field settings.
-   Difficulty reproducing or reviewing observations after the original
    examination.

A phone attached to a conventional microscope can digitize the
microscope field, but taking a photograph is only the first step. The
user still needs a reliable way to capture usable images, analyze them,
review predictions, record observations, and export results.

MICROTRACE focuses on this complete workflow rather than presenting a
single image-classification screen.

### Problem statement

Small laboratories, teaching laboratories, field researchers, and
microscopy learners need an affordable and practical way to digitize and
organize microscopic observations and use computer vision to assist with
selected analysis tasks, without depending on continuous internet access
or expensive dedicated imaging equipment.

------------------------------------------------------------------------

## 3. Product vision and objectives

### Vision

Make advanced, reviewable microscopy assistance accessible through
equipment that laboratories already have: a conventional microscope and
an Android phone.

### Primary objectives

-   Build a polished Android application for microscope image
    acquisition and analysis.
-   Support phone-to-eyepiece capture using a conventional microscope.
-   Provide a guided acquisition process that reduces blur, poor
    exposure, and unusable images.
-   Run at least one microscopy computer-vision model fully offline on
    the phone.
-   Display model outputs as overlays on the original image.
-   Allow a human reviewer to correct, accept, or reject detections.
-   Store images, annotations, analysis metadata, and reports locally.
-   Demonstrate a technically credible path toward additional microscopy
    modules.

### Non-goals for the hackathon MVP

-   Replacing clinical diagnosis or expert microscopy.
-   Claiming universal identification of fungi, parasites, bacteria, or
    cells.
-   Building a general-purpose medical chatbot.
-   Training a foundation model from scratch.
-   Supporting every microscope, phone, specimen type, and staining
    protocol.
-   Building a national patient-record platform.
-   Making cloud connectivity mandatory for core capture or analysis.

------------------------------------------------------------------------

## 4. Target users and use cases

### Primary users

**Laboratory technicians and research assistants** - Capture microscope
fields consistently. - Organize observations by specimen and session. -
Use supported models to assist with selected analysis tasks. - Review
and correct model outputs.

**Biology and microbiology students** - Learn to capture and document
microscopic fields. - Explore image annotations and model predictions. -
Compare observations with instructor-verified references.

**Research scientists and supervisors** - Review image sets and
annotations. - Export structured observations. - Maintain a traceable
record of model version, capture settings, and manual edits.

### Initial use cases

1.  A user attaches a smartphone to a microscope and captures a fungal
    microscopy image.
2.  The application checks focus, brightness, and field-of-view quality.
3.  The user captures one or more fields and associates them with a
    specimen record.
4.  A compatible on-device model analyzes the image.
5.  The app displays detections or classifications with confidence
    information.
6.  The user reviews the result, corrects annotations, and records
    notes.
7.  The app stores the session locally and generates an exportable
    report.

------------------------------------------------------------------------

## 5. Product strategy: one platform, specialized modules

MICROTRACE should be designed as a modular microscopy platform, not a
single-purpose diagnostic classifier.

Each module must define: - Its supported specimen and preparation
method. - The imaging conditions under which it was trained and
evaluated. - Its model task: classification, detection, segmentation, or
counting. - Its supported labels and definitions. - Its limitations and
validation status. - Its model version, preprocessing pipeline, and
confidence thresholds.

### Proposed module roadmap

  -----------------------------------------------------------------------
  Module                  Potential task          Initial status
  ----------------------- ----------------------- -----------------------
  Mycology                Fungal microscopy image First research module
                          classification and      
                          later morphology        
                          detection               

  Parasitology            Parasite object         Future module
                          detection and counting  
                          assistance              

  Malaria microscopy      Plasmodium detection in Future module requiring
                          validated smear         local validation
                          workflows               

  Cell analysis           Cell/object counting    Future module
                          and morphology          
                          assistance              

  General image tools     Capture, focus checks,  Core platform
                          measurements,           
                          annotations             
  -----------------------------------------------------------------------

### Why start with mycology?

The initial research direction should be fungal microscopy because it is
a manageable way to establish the platform's modular design and it
connects naturally to biological science and microscopy.

However, we must not imply that a public fungal image dataset
automatically supports identification of environmental fungi such as
*Aspergillus niger*. Dataset classes, specimen sources, staining
methods, and image acquisition conditions must be inspected before
selecting a scientific task.

**Recommended first claim:** MICROTRACE can classify selected microscopy
image patches into the classes represented in a documented research
dataset, under the dataset's known limitations.

**Do not claim:** MICROTRACE can diagnose fungal infections, identify
all fungi, or reliably identify *Aspergillus niger* in arbitrary
microscope images.

A later *Aspergillus* morphology module should be trained and evaluated
on a separately curated, expert-labelled dataset with documented
preparation and acquisition protocols.

------------------------------------------------------------------------

## 6. Research findings

This section distinguishes published findings from MICROTRACE design
recommendations.

### 6.1 Smartphone microscopy and malaria parasite detection (2026)

**Paper:** "Automated Detection of Malaria (Plasmodium) Parasites in
Images Captured with Mobile Phones Using Convolutional Neural Networks."
*Applied Sciences*, 16(2), 927, published 16 January 2026.

Link: https://www.mdpi.com/2076-3417/16/2/927\
DOI: https://doi.org/10.3390/app16020927

Reported details: - 400 slides from Loreto, Peru. - 8,625 images
captured using three smartphone models. - 54,531 annotated Plasmodium
instances. - Eight morphological classes across *P. vivax* and *P.
falciparum*. - YOLOv11n-based visual-field localization and parasite
detection. - Image tiling into 640 × 640 patches. - YOLOv11n achieved F1
= 0.938 and test accuracy = 90.92%. - Reported inference latency was
110.9 ms per 640 × 640 patch on a Samsung Galaxy S24 Ultra.

Important lessons for MICROTRACE: - Smartphone microscope images vary
significantly between phones and capture sessions. - Focus,
illumination, staining, camera alignment, and automatic phone image
processing matter. - Image preprocessing and visual-field localization
can be as important as the detection model. - Performance on one
high-end phone does not establish performance on low-cost Android
devices. - The model's results are specific to its dataset and malaria
task; they cannot be transferred to fungal microscopy.

### 6.2 Smartphone microscopy for Trypanosoma cruzi detection

**Paper:** "Artificial intelligence algorithm for real-time detection
and counting of Trypanosoma cruzi parasites using smartphone
microscopy."

PLOS Neglected Tropical Diseases:
https://journals.plos.org/plosntds/article?id=10.1371/journal.pntd.0012955

The study describes a smartphone-integrated microscopy system using a
3D-printed microscope adapter, telemedicine-enabled annotation
workflows, and lightweight models including SSD-MobileNetV2 and YOLOv8.

Reported human-sample results for SSD-MobileNetV2 included
approximately: - Precision: 86% - Recall: 87% - F1-score: 86.5%

The study also reported a smaller real-world operational experiment. Its
results show both the potential and the difficulty of moving from
curated image datasets to real microscope operation.

Lessons: - A simple physical phone-to-eyepiece adapter can be part of a
useful system. - Human annotation and review are valuable parts of the
workflow. - Real-world evaluation should be reported separately from
offline dataset performance. - High sensitivity can be useful for
screening assistance, but it does not establish clinical suitability.

### 6.3 DeFungi microscopy dataset

**Dataset:** DeFungi, UCI Machine Learning Repository, dataset 773.

Link: https://archive.ics.uci.edu/dataset/773/defungi\
Paper: https://doi.org/10.48550/arXiv.2109.07322\
Dataset licence listed by UCI: CC BY 4.0.

Reported characteristics: - 9,114 microscopy image instances. - Five
classes. - Images relate to direct mycological examination of
superficial fungal infections caused by yeasts, moulds, or dermatophyte
fungi. - Images were manually labelled with subject-matter expert
assistance. - Images were cropped to regions of interest. - The dataset
is intended for image classification research. - UCI does not provide an
official recommended train/validation/test split.

Important limitations: - These are pre-cropped image patches, not a
complete set of raw microscope fields. - The dataset does not, by
itself, provide bounding boxes or segmentation masks for individual
spores. - It is not a universal fungal taxonomy dataset. - It should not
be treated as a dataset for diagnosing environmental fungal
contamination or identifying *Aspergillus niger* unless the labels and
original paper support that task. - Related images or patches may
originate from the same specimen or source. A random image split could
cause data leakage if related samples appear in both training and
testing.

Recommended use: - Begin with image-level classification experiments. -
Inspect class codes and source documentation before assigning biological
names to labels. - Create a specimen-aware or source-aware split if the
metadata permits. - Keep a separate untouched test set. - Do not use
this dataset to claim spore detection or clinical diagnostic
performance.

### 6.4 Fungi MultiClass Microscopic Fungi Images (2026)

Dataset: https://data.mendeley.com/datasets/4g9yhrtsy5/1\
DOI: https://doi.org/10.17632/4g9yhrtsy5.1\
Published: 15 September 2026\
Licence: CC BY 4.0.

Reported characteristics: - 6,801 microscopic fungal images. - Five
image classes identified as H1, H2, H3, H5, and H6. - Predefined
training, validation, and test folders. - The dataset description
reports 5,000 training, 899 validation, and 902 test images.

Caution: The class labels are coded and the public description includes
broad fungal categories. The biological meaning and suitability of the
classes must be confirmed from the dataset documentation and original
source before using them in a user-facing classifier. Do not invent
class names from H1--H6.

### 6.5 On-device inference: Google LiteRT

Official documentation:
https://developers.google.com/edge/litert/overview

LiteRT is Google's on-device inference runtime and the successor
branding for TensorFlow Lite. It supports deployment of machine-learning
models on Android and other platforms.

The current documentation describes: - On-device model execution. - CPU
and supported accelerator paths. - Model conversion and optimization. -
Quantization options. - A modern CompiledModel API, while the
Interpreter API remains available for backward compatibility.

Android documentation lists Android API 24 or later as a supported
baseline for the documented LiteRT development workflow.

Recommendation: - Use LiteRT for local inference. - Benchmark the actual
model on representative Android devices. - Start with the simplest
reliable runtime path. - Test CPU inference first, then evaluate GPU
acceleration. - Do not assume GPU delegates are faster on every phone;
delegate startup, memory use, unsupported operators, and thermal
behaviour can affect results.

### 6.6 YOLO and LiteRT deployment

Ultralytics documentation:
https://docs.ultralytics.com/integrations/litert

The current integration documentation describes exporting supported YOLO
models to LiteRT for mobile and edge deployment. It documents
classification, detection, and segmentation tasks, as well as
quantization options.

The documentation also describes an Ultralytics YOLO Flutter integration
for running exported models on Android.

Recommendation: - Evaluate a nano-sized YOLO detector if the selected
task requires object localization. - Export to LiteRT and validate
output decoding, preprocessing, and post-processing. - Confirm the
current plugin's licence, version compatibility, supported model tasks,
and runtime requirements before committing to it. - Keep the inference
interface behind an internal abstraction so the app can switch to native
LiteRT if necessary.

### 6.7 Flutter camera support

Flutter camera package: https://pub.dev/packages/camera\
Flutter camera recipe:
https://docs.flutter.dev/cookbook/plugins/picture-using-camera

The official Flutter camera plugin supports camera preview, still
capture, video, and image streams. Its Android implementation uses
CameraX by default in current versions.

Recommendation: - Use Flutter for the product interface and application
workflow. - Use the camera plugin for the initial camera
implementation. - If microscope-specific controls, stable frame
handling, manual focus, exposure control, or performance require more
control, implement a native Android CameraX bridge. - Treat
phone-to-eyepiece capture as a different optical workflow from ordinary
rear-camera photography.

------------------------------------------------------------------------

## 7. Model strategy

MICROTRACE should not choose a model based on popularity alone. The
model task must match the available annotations and the product's
intended output.

### 7.1 Model task selection

  -------------------------------------------------------------------------
  Task              What it returns   Required training Suitable use
                                      labels            
  ----------------- ----------------- ----------------- -------------------
  Image             One or more       Image-level       Classifying a
  classification    labels for an     labels            cropped microscopy
                    image/patch                         field

  Object detection  Bounding boxes    Bounding boxes    Locating/counting
                    and class scores                    individual objects

  Instance          A separate mask   Per-object masks  Measuring
  segmentation      for each object                     individual object
                                                        shape/area

  Semantic          Pixel-level class Pixel-level masks Separating
  segmentation      masks                               foreground
                                                        structures from
                                                        background

  Image quality     Quality labels or Quality labels    Rejecting blur,
  classification    score                               poor exposure, or
                                                        unusable fields
  -------------------------------------------------------------------------

Do not train an object detector using only image-level class labels. Do
not claim accurate object counts from a classification model.

### 7.2 Candidate model families

**A. MobileNetV3-Small** - Intended for efficient mobile image
classification. - A good baseline for image-patch classification. -
Relatively compact and suitable for testing on lower-end phones. -
Candidate for transfer learning on DeFungi after label and split
inspection.

**B. EfficientNet-Lite0** - Google AI Edge documents it as a lightweight
image-classification option. - The documented model uses 224 × 224 input
and is available in float32 and int8 variants. - Useful as a baseline,
but its pretrained ImageNet weights do not already understand
microscopy-specific classes. - It must be fine-tuned and evaluated on
relevant microscopy data.

Official model documentation:
https://developers.google.com/edge/mediapipe/solutions/vision/image_classifier

**C. YOLO nano detection model** - Candidate when the task is locating
individual objects such as cells, parasites, or spores. - YOLOv11n is a
useful research baseline because of the 2026 smartphone malaria paper. -
Current Ultralytics LiteRT documentation also describes newer YOLO
families and export paths. - Choose the specific model version after
comparing export stability, licence, latency, model size, and accuracy.

**D. Lightweight segmentation model** - Consider a compact U-Net with a
MobileNet encoder or another mobile-friendly segmentation
architecture. - Appropriate when the desired output is a mask rather
than a bounding box. - Requires pixel-level mask annotations and careful
evaluation.

### 7.3 Recommended initial experiment

Run a controlled comparison rather than assuming one architecture will
win.

  --------------------------------------------------------------------------
  Experiment        Model                Task              Input
  ----------------- -------------------- ----------------- -----------------
  Baseline A        MobileNetV3-Small    Classification    224 × 224

  Baseline B        EfficientNet-Lite0   Classification    224 × 224

  Candidate C       YOLO nano            Detection, only   640 × 640
                                         if object labels  
                                         exist             

  Candidate D       Lightweight U-Net    Segmentation,     256 or 512 square
                                         only if masks     
                                         exist             
  --------------------------------------------------------------------------

For the first hackathon prototype, classification is the fastest
defensible route if using DeFungi. Detection should be a separate
experiment using a dataset with suitable object-level annotations or a
small expert-annotated dataset.

### 7.4 Model output contract

Every model module should return a consistent structured result:

``` json
{
  "model_id": "mycology_patch_classifier",
  "model_version": "0.1.0",
  "task": "image_classification",
  "input_size": [224, 224],
  "predictions": [
    {
      "class_id": "class_code_from_dataset",
      "score": 0.91
    }
  ],
  "quality_gate": {
    "passed": true,
    "warnings": []
  },
  "processing_ms": 0
}
```

The actual class names must come from verified dataset metadata. The
example score is illustrative, not a performance claim.

------------------------------------------------------------------------

## 8. Image acquisition: the most important product experience

A microscopy model can fail because the input image is poor even when
the model itself is well designed. MICROTRACE should treat image
acquisition as a first-class feature.

### 8.1 Supported capture setup

Initial setup: - Conventional optical microscope. - Smartphone rear
camera. - Adjustable phone-to-eyepiece adapter or stable universal
clamp. - Prepared microscope slide. - Appropriate microscope objective
and illumination. - User-selected capture profile for the microscope and
specimen workflow.

The hackathon MVP should not require custom hardware. A low-cost adapter
can improve alignment and repeatability, but the first demo can use an
available phone adapter or a carefully stabilized setup.

### 8.2 Guided capture interface

The camera screen should include: - Live microscope preview. - Circular
field-of-view guide. - Focus status indicator. - Brightness/exposure
warning. - Capture button. - Manual focus control where supported. -
Exposure and white-balance controls where supported. - Image-quality
feedback. - Captured-field counter. - A clear "capture field" action.

### 8.3 Image-quality checks

Start with explainable image-processing checks before using a learned
quality model:

**Blur / focus** - Use a sharpness metric such as variance of the
Laplacian as an initial heuristic. - Calibrate thresholds against real
microscope images. - Show "Refocus and try again" rather than silently
capturing unusable images.

**Brightness** - Estimate mean luminance and clipped
highlights/shadows. - Warn when the field is too dark or overexposed.

**Field of view** - Detect or estimate the circular microscope field. -
Crop outside borders and dark eyepiece regions. - Keep the original
image for traceability.

**Alignment** - Warn when the field is badly off-centre or partially
obstructed. - Do not reject an image solely because it is not perfectly
circular.

**Colour** - Preserve original colour information. - Avoid aggressive
automatic colour correction that could alter staining characteristics. -
Any normalization used for model input must be documented and
reproducible.

### 8.4 Capture workflow

1.  User selects or creates a specimen/session.
2.  User chooses the microscopy module and capture profile.
3.  App opens the live preview.
4.  User aligns the microscope field.
5.  App checks focus and exposure.
6.  User captures the field.
7.  App displays a quick quality review.
8.  User accepts, retakes, or saves the image.
9.  Accepted images enter the analysis queue.

### 8.5 Multiple fields

For the MVP, support a small set of manually captured fields per
specimen. Do not promise automated whole-slide scanning.

A later version can support: - A capture grid. - Guided manual movement
between fields. - Duplicate-field detection. - Field coverage
tracking. - Image stitching, if optical movement and overlap can be
measured reliably.

------------------------------------------------------------------------

## 9. User experience and visual design

### Design direction

MICROTRACE should feel like a serious scientific instrument, not a
generic AI chatbot or a consumer photo-filter app.

Design qualities: - Clean, precise, calm, and modern. - Light-first
interface with an optional dark laboratory theme. - Neutral surfaces and
restrained scientific accent colours. - Strong image presentation. -
Clear typography and readable measurements. - Minimal decoration. - No
unnecessary gradients, glowing AI effects, or clutter. - Large touch
targets for use near laboratory equipment.

### Navigation

Use a simple bottom navigation with four destinations:

1.  **Home**
2.  **Capture**
3.  **Library**
4.  **Models**

Settings and profile can be accessed from the home header.

### Screen 1: Home dashboard

Purpose: show the user's current workspace and make starting a
microscopy session immediate.

Elements: - MICROTRACE wordmark. - "New microscopy session" primary
action. - Recent sessions. - Installed model/module status. - Storage
usage. - Offline status indicator. - Small summary: sessions captured,
fields analyzed, pending reviews.

Example layout:

``` text
MICROTRACE                         [Profile]

Good afternoon

[ + New microscopy session ]

WORKSPACE
12 sessions       86 fields
3 pending reviews

RECENT SESSIONS
Fungal sample 04        Today
Teaching slide 02       Yesterday
Research sample 01     10 Nov

MODULES
Mycology                Installed
Parasitology            Coming soon

[Home] [Capture] [Library] [Models]
```

### Screen 2: New session

Fields: - Session title. - Specimen/sample code. - Specimen type. -
Module. - Microscope/capture profile. - Optional notes. - Optional
operator name or initials.

Avoid collecting patient identifiers in the hackathon MVP. If a future
clinical workflow is considered, define privacy, consent, access
control, and retention requirements separately.

### Screen 3: Microscope capture

This is the signature screen.

Visual structure: - Large camera preview occupying most of the screen. -
Subtle circular field-of-view overlay. - Focus and exposure
indicators. - Small control strip for zoom, focus, exposure, and light
guidance. - Capture button at bottom centre. - Captured fields as a
compact horizontal thumbnail strip. - Quality feedback shown immediately
and in plain language.

The screen must prioritize the microscope image rather than decorative
interface elements.

### Screen 4: Image review

Show: - Large captured image. - Quality status. - Retake button. -
Accept image button. - Optional crop/rotate controls. - Capture
metadata.

The original image should remain immutable. Any crop or preprocessing
should be saved as a derived image with a link to the original.

### Screen 5: Analysis

Show: - Image being analyzed. - Model name and version. - Progress
indicator. - Processing status. - Clear offline/local processing
indicator.

Do not show a fake percentage if the inference engine cannot report
meaningful progress.

### Screen 6: Results viewer

This should be one of the most polished screens.

Elements: - Original image with zoom and pan. - Toggle for model
overlay. - Detection boxes or segmentation masks where supported. -
Class label and score. - Object count only if the model task supports
valid object detection/counting. - Review state. - "Accept", "Edit", and
"Reject" actions. - Model limitations and warnings accessible without
dominating the screen.

For classification models, show image-level class predictions rather
than drawing invented boxes around objects.

### Screen 7: Annotation and review

For detection models: - Tap a detection to inspect it. - Change its
label. - Delete false detections. - Add a missed detection manually. -
Save the reviewer correction.

For classification models: - Confirm or reject the predicted image
class. - Add a note. - Mark uncertain cases for expert review.

Keep model predictions and human corrections separate in storage.

### Screen 8: Session report

Include: - Session details. - Captured fields. - Analysis summary. -
Model version. - Processing date/time. - Reviewer edits. - Warnings and
limitations. - Export to PDF and CSV/JSON where applicable.

A report must distinguish AI-generated suggestions from human-confirmed
observations.

### Screen 9: Model library

Show: - Available modules. - Installed models. - Model version and
size. - Supported task. - Supported input requirements. -
Download/install status. - Remove/update controls. - Model licence and
source information.

Model downloads should be resumable and verified with checksums. A model
should not be activated until its metadata and checksum have been
validated.

### Screen 10: Settings

Include: - Theme. - Storage management. - Export location. - Model
download preferences. - Camera troubleshooting. - Privacy information. -
About and research limitations.

------------------------------------------------------------------------

## 10. Technical architecture

### Recommended stack

  -----------------------------------------------------------------------
  Layer                   Technology              Reason
  ----------------------- ----------------------- -----------------------
  Mobile UI               Flutter / Dart          Fast cross-platform
                                                  interface development

  Android camera          Flutter camera plugin   Preview and capture,
                          initially; CameraX      with a path to more
                          native bridge if needed control

  On-device inference     Google LiteRT           Local model execution

  Model training          Python + PyTorch        Research and training
                                                  ecosystem

  Detection training      Ultralytics, if         Practical object
                          selected                detection and export
                                                  workflow

  Classification training PyTorch / timm          Flexible transfer
                                                  learning

  Image processing        OpenCV                  Cropping, blur checks,
                                                  normalization, image
                                                  utilities

  Local database          SQLite via Drift        Structured offline data

  File storage            App-private filesystem  Original images,
                                                  derived images, model
                                                  files

  State management        Riverpod                Predictable Flutter
                                                  state management

  Routing                 go_router               Declarative navigation

  PDF export              Flutter PDF package or  Session reports
                          native generation       

  Optional sync           REST API later          Backup and
                                                  multi-facility
                                                  collaboration
  -----------------------------------------------------------------------

### Architecture overview

``` text
┌──────────────────────────────────────────────┐
│               Flutter Application            │
│                                              │
│  Home │ Sessions │ Capture │ Results │ Models│
└──────────────────────┬───────────────────────┘
                       │
┌──────────────────────▼───────────────────────┐
│              Application Services            │
│                                              │
│ Session service │ Capture service │ Export   │
│ Review service  │ Model registry  │ Storage  │
└──────────────┬───────────────────┬───────────┘
               │                   │
┌──────────────▼─────────┐ ┌───────▼───────────┐
│ Image acquisition      │ │ Local data layer  │
│ Flutter Camera /       │ │ SQLite / Drift    │
│ Native CameraX bridge  │ │ Private files     │
└──────────────┬─────────┘ └───────────────────┘
               │
┌──────────────▼───────────────────────────────┐
│             Microscopy processing            │
│                                              │
│ Field crop │ Quality checks │ Preprocessing  │
└──────────────────────┬───────────────────────┘
                       │
┌──────────────────────▼───────────────────────┐
│             Inference abstraction            │
│                                              │
│ Model registry │ LiteRT runtime │ Postprocess│
│ Classification │ Detection      │ Segmentation│
└──────────────────────┬───────────────────────┘
                       │
┌──────────────────────▼───────────────────────┐
│             Results and human review         │
│                                              │
│ Overlay │ Correction │ Confidence │ Provenance│
└──────────────────────────────────────────────┘
```

### Important architectural decision

Do not tightly couple the Flutter UI to one model package.

Define an internal inference interface such as:

``` dart
abstract interface class MicroscopyModel {
  Future<void> load();
  Future<AnalysisResult> analyze(MicroscopyImage image);
  Future<void> dispose();
  ModelMetadata get metadata;
}
```

Each model adapter can implement this interface: - LiteRT classification
adapter. - LiteRT detection adapter. - Segmentation adapter. - Mock
adapter for UI development and tests.

This allows the team to build the application before the final model is
ready.

### Native Android boundary

If Flutter camera streaming or model integration becomes unreliable,
keep the user interface in Flutter and implement only
performance-sensitive components natively in Kotlin: - CameraX capture
and controls. - Image conversion and preprocessing. - LiteRT model
execution. - Hardware delegate selection. - Efficient result
serialization back to Flutter.

Use a platform channel or a Flutter plugin boundary. Avoid moving large
raw image buffers repeatedly between Dart and Kotlin if inference can
happen natively.

------------------------------------------------------------------------

## 11. Machine-learning pipeline

### Stage 1: Dataset inspection

Before training: 1. Download the dataset from its official source. 2.
Read its licence and documentation. 3. Inspect all class labels and
sample counts. 4. Inspect image dimensions, colour distribution, and
image quality. 5. Identify duplicates and near-duplicates. 6. Determine
whether multiple images originate from the same specimen or source. 7.
Check whether metadata permits group-aware splitting. 8. Visually
inspect examples from every class.

Deliverable: a dataset audit report.

### Stage 2: Data splitting

Use: - Training set. - Validation set. - Untouched test set.

Avoid leakage: - Group by specimen, slide, patient, source image, or
acquisition session wherever metadata permits. - Keep related image
patches in one partition. - Do not use random patch-level splitting if
related patches can cross partitions.

If source metadata is unavailable, explicitly state that the evaluation
has a leakage limitation.

### Stage 3: Preprocessing

Document and version: - Image decoding. - Colour channel order. -
Resizing. - Normalization. - Cropping. - Field-of-view handling. -
Augmentation.

Possible training augmentations: - Small rotations. -
Horizontal/vertical flips where biologically appropriate. - Moderate
brightness and contrast variation. - Mild blur/noise variation if it
reflects real capture conditions. - Small scale and crop variation.

Avoid augmentations that alter meaningful morphology or produce
unrealistic specimens.

### Stage 4: Training

For the first classification experiment: - Start with
MobileNetV3-Small. - Compare EfficientNet-Lite0. - Use transfer
learning. - Track validation loss and per-class metrics. - Save the best
validation checkpoint. - Record random seeds and training configuration.

For a later detection experiment: - Collect or obtain images with
object-level bounding-box annotations. - Train a nano-sized YOLO
detector. - Inspect false positives and missed objects manually. -
Evaluate object-level and image-level performance separately.

### Stage 5: Evaluation

Classification metrics: - Accuracy. - Macro precision. - Macro recall. -
Macro F1. - Per-class precision and recall. - Confusion matrix. -
Calibration and confidence behaviour.

Detection metrics: - Precision and recall. - F1-score. - mAP at relevant
IoU thresholds. - Per-class performance. - Count error against expert
counts. - False positives per field.

Segmentation metrics: - Dice score. - Intersection over Union. -
Per-class performance. - Boundary quality where relevant.

Do not report accuracy alone, especially when classes are imbalanced.

### Stage 6: Mobile conversion

1.  Export the trained model to a supported format.
2.  Convert to LiteRT.
3.  Test float32 or float16 first.
4.  Test INT8 quantization using representative microscopy images.
5.  Compare model size, latency, memory use, and task metrics.
6.  Run inference on real Android devices.
7.  Verify that mobile preprocessing exactly matches training
    preprocessing.
8.  Verify output decoding and label mapping.
9.  Record the final model checksum and metadata.

Quantization can reduce model size and improve performance, but it may
also reduce accuracy. The quantized model must be evaluated again.

### Stage 7: Model release package

Each model package should include: - Model file. - Metadata JSON. -
Label map. - Input dimensions. - Normalization parameters. -
Preprocessing version. - Output schema. - Model version. - Dataset
references. - Licence. - Evaluation report. - SHA-256 checksum. - Known
limitations.

------------------------------------------------------------------------

## 12. Dataset and annotation strategy

### Initial public datasets

**DeFungi** - 9,114 images. - Five classes. - Direct mycological
examination. - UCI dataset 773. - CC BY 4.0 according to UCI. - Good
first candidate for patch classification experiments. - Not sufficient
by itself for spore detection or universal fungal identification.

**Fungi MultiClass Microscopic Fungi Images** - 6,801 images. - Five
coded classes. - Mendeley Data. - CC BY 4.0 as listed. - Verify label
meaning and source documentation before training.

### Local dataset opportunity

A genuinely valuable future asset would be a small, well-documented
microscopy dataset collected with permission from a university or
diagnostic laboratory.

A local collection protocol should record: - Specimen/sample code
without direct identifiers. - Organism or structure label confirmed by
an expert. - Preparation and staining method. - Microscope objective and
magnification. - Microscope model where available. - Phone model and
camera settings. - Capture date and session. - Image quality. - Expert
annotation and reviewer identity. - Consent/approval status where
human-derived specimens are involved.

Do not upload patient images or identifiable laboratory records to
public datasets without appropriate permission, consent, and governance.

### Annotation tools

Potential tools: - CVAT: https://www.cvat.ai/ - Label Studio:
https://labelstud.io/ - Roboflow Annotate: https://roboflow.com/annotate

Choose the tool according to annotation type and data governance
requirements. For sensitive data, confirm hosting, access, retention,
and licence terms before uploading.

### Annotation protocol

-   Define each class precisely.
-   Provide example images and exclusion rules.
-   Use trained annotators.
-   Have a second reviewer inspect a subset.
-   Resolve disagreements through an expert.
-   Preserve annotation history.
-   Keep uncertain examples marked as uncertain rather than forcing a
    label.

------------------------------------------------------------------------

## 13. Performance and smoothness requirements

MICROTRACE must feel responsive even on mid-range Android devices.

### Performance principles

-   Never run heavy inference on Flutter's UI thread.
-   Use background isolates or native worker threads where appropriate.
-   Avoid processing every camera frame with a large model in the first
    MVP.
-   Capture a still image, run quality checks, then analyze
    asynchronously.
-   Keep camera preview and inference workloads separate.
-   Resize only the model input; preserve the original image.
-   Use efficient image buffers and avoid unnecessary copies.
-   Cache loaded models where memory permits.
-   Release camera and inference resources when leaving their screens.
-   Use progressive loading for the image library.
-   Keep database writes small and asynchronous.
-   Avoid blocking the UI while generating PDFs.

### Initial engineering targets

These are product targets to measure, not claims of existing
performance.

  -----------------------------------------------------------------------
  Metric                              Initial target
  ----------------------------------- -----------------------------------
  App launch to usable home           Under 3 seconds on target mid-range
                                      device

  Camera preview startup              Under 2 seconds after permission
                                      and camera initialization

  Quality check                       Under 300 ms for a normal still
                                      image

  Single image classification         Under 1 second on target device, if
                                      achievable

  Detection inference                 Target under 2 seconds per field on
                                      the baseline phone

  UI interaction                      No visible blocking during
                                      inference

  Offline core workflow               Capture, analyze, review, save, and
                                      export work without internet

  Crash-free demo session             No known critical crash in repeated
                                      end-to-end tests
  -----------------------------------------------------------------------

Benchmark on at least: - One lower-end Android phone. - One mid-range
Android phone. - One higher-end Android phone.

Record device model, Android version, RAM, runtime, delegate, model
size, warm-up behaviour, and thermal conditions.

### Low-memory strategy

-   Offer a CPU-compatible model path.
-   Avoid loading multiple models simultaneously.
-   Use smaller input dimensions where validation supports it.
-   Release large image buffers after processing.
-   Generate thumbnails for the library.
-   Keep original images in app-private storage.
-   Warn users before running models that exceed device capability.

------------------------------------------------------------------------

## 14. Offline-first data design

Core functionality must work without a network connection.

### Local entities

**MicroscopySession** - id - title - specimen_code - specimen_type -
module_id - created_at - operator_label - notes - status

**MicroscopyImage** - id - session_id - original_path - derived_path -
captured_at - width - height - capture_profile_id - quality_status -
quality_metrics_json

**AnalysisRun** - id - image_id - model_id - model_version -
preprocessing_version - started_at - completed_at - processing_ms -
result_json - status

**Annotation** - id - analysis_run_id - class_id - geometry_json -
confidence - origin (model/manual) - review_status - reviewer_note

**ModelInstallation** - model_id - version - local_path - checksum -
installed_at - licence - status

### Storage principles

-   Store images in app-private storage.
-   Store structured metadata in SQLite.
-   Keep original images immutable.
-   Store crops and processed images as derived assets.
-   Keep human corrections separate from model predictions.
-   Record model and preprocessing versions for reproducibility.
-   Do not collect direct patient identifiers in the MVP.
-   Provide a clear delete/export workflow.

### Optional synchronization (future)

The first version should not need an account or cloud service.

A later sync service may support: - Encrypted backup. - Multi-device
research projects. - Shared model distribution. - Approved dataset
contribution. - Institution-level collaboration.

Any future sync feature requires authentication, access control,
transport security, retention policies, and a clear data-sharing consent
process.

------------------------------------------------------------------------

## 15. Privacy, safety, and scientific integrity

MICROTRACE handles potentially sensitive biological and laboratory
information. Privacy and scientific honesty are core requirements.

### Privacy

-   Local-first by default.
-   No analytics or image uploads without explicit consent.
-   No automatic cloud inference.
-   App-private image storage.
-   No patient names or phone numbers in the hackathon MVP.
-   Clear model download and data export disclosures.

### Scientific integrity

-   Every prediction must be traceable to a model version.
-   The original image must remain available.
-   Confidence scores must not be presented as clinical certainty.
-   Human edits must be recorded separately.
-   Low-quality images should be flagged.
-   Out-of-distribution images should be handled cautiously.
-   Unsupported specimen types should be rejected or marked unsupported.
-   Reports must identify AI-generated suggestions.

### Medical safety boundary

MICROTRACE is not a medical device or validated diagnostic product in
this MVP. It must not independently diagnose, prescribe, or recommend
treatment.

If a future version is intended for clinical diagnosis or clinical
decision-making, it will require appropriate clinical validation,
regulatory assessment, professional oversight, and jurisdiction-specific
compliance before deployment.

------------------------------------------------------------------------

## 16. MVP scope for the hackathon

The hackathon MVP must be small enough to complete, but complete enough
to demonstrate a real workflow.

### Must-have

1.  Flutter Android application.
2.  Home dashboard.
3.  Create microscopy session.
4.  Live microscope camera preview.
5.  Capture and save an image.
6.  Basic focus/brightness quality checks.
7.  One working on-device model.
8.  Analysis result screen.
9.  Human review/confirmation.
10. Local session and image storage.
11. Basic report/export.
12. Fully offline demo.

### Should-have

-   Circular microscope field crop.
-   Multiple fields per session.
-   Image zoom and pan.
-   Model metadata and version display.
-   Dark laboratory theme.
-   Model installation screen.
-   Capture troubleshooting.

### Could-have

-   Manual bounding-box annotation.
-   PDF report styling.
-   Model comparison screen.
-   Dataset contribution workflow.
-   Optional encrypted backup.

### Explicitly out of scope

-   Multi-hospital cloud platform.
-   Full laboratory information management system.
-   Automated whole-slide scanning.
-   Multiple clinically validated diagnostic modules.
-   Custom microscope hardware manufacturing.
-   AI chatbot.
-   Federated learning implementation in the hackathon MVP.

------------------------------------------------------------------------

## 17. Suggested development plan

This plan is optimized for a short hackathon build. It assumes the team
can work in parallel.

### Phase 1 --- Scientific and technical feasibility

-   Download and inspect DeFungi.
-   Read the original dataset paper.
-   Confirm label meanings and licence.
-   Build a dataset audit.
-   Train a simple classification baseline.
-   Test a sample model on a real Android phone.
-   Test microscope phone-adapter capture.

**Exit condition:** one defensible task, a dataset audit, and proof that
an on-device model can run.

### Phase 2 --- Application foundation

-   Create Flutter project.
-   Establish design tokens and navigation.
-   Build dashboard and session creation.
-   Implement local database and image storage.
-   Add camera preview and still capture.

**Exit condition:** a user can create a session and save microscope
images offline.

### Phase 3 --- Image quality and inference

-   Implement focus and brightness heuristics.
-   Add preprocessing pipeline.
-   Export the trained model.
-   Integrate LiteRT inference.
-   Add model metadata.
-   Display predictions.

**Exit condition:** a saved microscope image can be analyzed offline on
a physical Android phone.

### Phase 4 --- Review and reporting

-   Add prediction review.
-   Add manual correction for the chosen task.
-   Store review history.
-   Build session summary.
-   Export report.

**Exit condition:** complete capture → analyze → review → save → export
workflow.

### Phase 5 --- Polish and demonstration

-   Test low-, mid-, and high-range Android devices where possible.
-   Profile inference and memory.
-   Test offline mode.
-   Fix camera lifecycle bugs.
-   Prepare a repeatable demonstration dataset.
-   Prepare a clear limitations statement.
-   Record a fallback demo video.

**Exit condition:** stable demonstration with honest metrics and no
dependency on internet access.

------------------------------------------------------------------------

## 18. Team roles

For a team of 2--5:

**Product and mobile lead** - Product scope. - Flutter architecture. -
Navigation and state management. - Local persistence. - Integration and
release.

**ML/computer-vision lead** - Dataset audit. - Model experiments. -
Evaluation. - Conversion and mobile inference.

**Microscopy/scientific lead** - Dataset interpretation. - Image
acquisition protocol. - Biological label verification. - Annotation
guidance. - Scientific limitations and validation.

**UI/UX designer** - Design system. - Capture experience. - Results
visualization. - Usability testing.

**QA/demo and research lead** - Device testing. - Reproducibility
checks. - Documentation. - Demo preparation and pitch.

One person may cover multiple roles.

------------------------------------------------------------------------

## 19. Risks and mitigations

  -----------------------------------------------------------------------
  Risk                    Why it matters          Mitigation
  ----------------------- ----------------------- -----------------------
  Dataset labels are      Model could learn       Inspect original paper
  ambiguous               meaningless labels      and metadata before
                                                  training

  Dataset does not match  Poor real-world         Collect a small local
  local images            generalization          validation set with
                                                  permission

  Image quality varies    Predictions become      Guided capture and
                          unreliable              quality gates

  Model is too slow       Poor user experience    Smaller models,
                                                  quantization,
                                                  asynchronous inference

  Model export changes    Mobile predictions      Compare golden test
  outputs                 differ from Python      images before and after
                                                  export

  Class imbalance         Accuracy hides weak     Macro metrics and
                          classes                 per-class reporting

  Data leakage            Inflated test results   Group-aware splits and
                                                  duplicate checks

  False detections        Misleading object       Human review and
                          counts                  conservative thresholds

  Camera adapter          Cropped or distorted    Guided alignment and
  alignment               fields                  physical adapter
                                                  testing

  Medical overclaiming    Safety and credibility  Decision-support
                          risk                    framing and clear
                                                  limitations

  Licensing issues        Model or dataset cannot Audit dataset, model,
                          be redistributed        and dependency licences
  -----------------------------------------------------------------------

------------------------------------------------------------------------

## 20. Evaluation and success criteria

### Product success

-   A user can create and complete a microscopy session offline.
-   The camera workflow works with a real microscope and phone adapter.
-   Captured images are saved with metadata.
-   The application performs image-quality checks.
-   The model runs locally without a network connection.
-   Results can be reviewed and corrected.
-   Reports can be exported.
-   The app does not crash during repeated capture and analysis cycles.

### ML success

-   A documented dataset audit exists.
-   Train/validation/test split is defensible.
-   The chosen task matches the available labels.
-   Baseline metrics are reported.
-   Per-class metrics and confusion matrix are available.
-   Mobile model outputs match the reference inference pipeline within
    defined tolerances.
-   Latency, model size, and memory use are measured on real devices.
-   Limitations are clearly stated.

### Demonstration success

A judge should be able to see: 1. A real microscope and smartphone
setup. 2. A live microscope field in MICROTRACE. 3. A captured image. 4.
The image-quality feedback. 5. On-device analysis with internet
disabled. 6. A visual result. 7. Human review. 8. A saved session and
exported report.

The demonstration must use genuine model outputs. If a fallback sample
is used, label it as a precomputed example rather than pretending it is
live inference.

------------------------------------------------------------------------

## 21. Future roadmap

### Version 0.1 --- Hackathon MVP

-   Mycology image classification experiment.
-   Android capture workflow.
-   Offline inference.
-   Local sessions and reports.

### Version 0.2 --- Research-grade capture

-   Better microscope alignment.
-   Capture profiles.
-   Improved field-of-view detection.
-   More robust quality assessment.
-   Dataset review and annotation tools.

### Version 0.3 --- Object-level analysis

-   Expert-annotated dataset.
-   Detection or segmentation model.
-   Manual annotation correction.
-   Object counting with validated error measurements.

### Version 0.4 --- Additional modules

-   Parasitology module.
-   Malaria research module using suitable, properly licensed datasets.
-   Additional fungal morphology module.
-   Module-specific validation and metadata.

### Version 1.0 --- Laboratory collaboration

-   Institution workspaces.
-   Encrypted backup and synchronization.
-   Shared model registry.
-   Controlled dataset contribution.
-   Research exports and audit trails.

------------------------------------------------------------------------

## 22. Repository structure proposal

``` text
microtrace/
├── README.md
├── PROJECT.md
├── LICENSE
├── docs/
│   ├── research-findings.md
│   ├── product-requirements.md
│   ├── architecture.md
│   ├── model-card-template.md
│   ├── dataset-audit-template.md
│   ├── image-acquisition-protocol.md
│   └── demo-script.md
├── app/
│   ├── lib/
│   │   ├── app/
│   │   ├── core/
│   │   ├── features/
│   │   │   ├── home/
│   │   │   ├── sessions/
│   │   │   ├── capture/
│   │   │   ├── analysis/
│   │   │   ├── review/
│   │   │   ├── library/
│   │   │   └── models/
│   │   └── main.dart
│   └── android/
├── ml/
│   ├── data/
│   │   └── README.md
│   ├── notebooks/
│   ├── src/
│   ├── configs/
│   ├── tests/
│   ├── exports/
│   └── reports/
└── assets/
    ├── branding/
    ├── icons/
    └── sample_images/
```

Do not commit restricted datasets, private specimen images, large model
weights, or patient data to the repository. Use documented download
scripts or release assets where redistribution is permitted.

------------------------------------------------------------------------

## 23. Immediate next steps

The first work should be research validation, not designing ten screens
or training a model blindly.

1.  Download DeFungi from UCI.
2.  Read the associated paper and confirm the five class definitions.
3.  Inspect the images and check for duplicates or related image groups.
4.  Build a dataset audit with class counts and representative samples.
5.  Test MobileNetV3-Small and EfficientNet-Lite0 as classification
    baselines.
6.  Confirm that the chosen dataset task is scientifically meaningful.
7.  Capture a small set of microscope images using the actual phone and
    adapter intended for the demo.
8.  Compare real phone images with public dataset images.
9.  Decide whether the first module should remain patch classification
    or move to a locally annotated detection task.
10. Only then freeze the MVP model and interface.

### Critical go/no-go decision

If DeFungi labels cannot be interpreted reliably, or if its image domain
is too different from the images we can capture, do not force it into
the product. Use it as a research benchmark only and seek a better
dataset or an expert-supported local collection.

A smaller, defensible model is better than an impressive but
scientifically invalid demonstration.

------------------------------------------------------------------------

## 24. References and useful resources

### Research papers

1.  Vásquez Ascate, J. et al. (2026). "Automated Detection of Malaria
    (Plasmodium) Parasites in Images Captured with Mobile Phones Using
    Convolutional Neural Networks." *Applied Sciences*, 16(2), 927.\
    https://www.mdpi.com/2076-3417/16/2/927\
    https://doi.org/10.3390/app16020927

2.  "Artificial intelligence algorithm for real-time detection and
    counting of Trypanosoma cruzi parasites using smartphone
    microscopy." *PLOS Neglected Tropical Diseases*.\
    https://journals.plos.org/plosntds/article?id=10.1371/journal.pntd.0012955

3.  Sopo, C., Hajati, F., and Gheisari, S. (2021). "DeFungi: direct
    mycological examination of microscopic fungi images."\
    https://doi.org/10.48550/arXiv.2109.07322

### Datasets

4.  UCI Machine Learning Repository --- DeFungi, dataset 773.\
    https://archive.ics.uci.edu/dataset/773/defungi

5.  Mendeley Data --- Fungi MultiClass Microscopic Fungi Images.\
    https://data.mendeley.com/datasets/4g9yhrtsy5/1\
    https://doi.org/10.17632/4g9yhrtsy5.1

### Mobile ML and computer vision

6.  Google AI Edge --- LiteRT overview.\
    https://developers.google.com/edge/litert/overview

7.  Google AI Edge --- MediaPipe image classifier and EfficientNet-Lite
    model information.\
    https://developers.google.com/edge/mediapipe/solutions/vision/image_classifier

8.  Ultralytics --- Export YOLO models to LiteRT.\
    https://docs.ultralytics.com/integrations/litert

9.  Google AI Edge --- MediaPipe Android setup.\
    https://developers.google.com/edge/mediapipe/solutions/setup_android

### Flutter and image capture

10. Flutter camera package.\
    https://pub.dev/packages/camera

11. Flutter camera documentation.\
    https://docs.flutter.dev/cookbook/plugins/picture-using-camera

### Annotation tools

12. CVAT.\
    https://www.cvat.ai/

13. Label Studio.\
    https://labelstud.io/

14. Roboflow Annotate.\
    https://roboflow.com/annotate

------------------------------------------------------------------------

## 25. Final product position

MICROTRACE should be presented as a **modular, offline-first smartphone
microscopy workstation with on-device computer vision and human-reviewed
analysis**.

Its strongest initial demonstration is not a claim that it can diagnose
every microorganism. It is a complete, practical workflow that takes a
real microscope image, checks its quality, analyzes it locally using a
documented model, lets a human review the output, and preserves a
reproducible record.

The product should earn trust through good acquisition, transparent
model limitations, reproducible evaluation, and a polished experience.

**The principle to protect throughout development: the microscope
provides the biological evidence, the model provides assistance, and the
human remains responsible for interpretation.**
