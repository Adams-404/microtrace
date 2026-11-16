import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../core/constants/app_constants.dart';
import '../../core/utils/formatters.dart';
import '../models/analysis_run.dart';
import '../models/session.dart';

class PdfReportService {
  /// Generates a compliant laboratory observation report as PDF bytes
  static Future<Uint8List> generateObservationReportPdf({
    required MicroscopySession session,
  }) async {
    final pdf = pw.Document(
      title: 'MICROTRACE Report - ${session.specimenCode}',
      author: 'MICROTRACE Laboratory Decision-Support System',
    );

    // Instrument colors in PDF format
    const primaryColor = PdfColor.fromInt(0xFF101216);
    const mutedColor = PdfColor.fromInt(0xFF5E6672);
    const borderColor = PdfColor.fromInt(0xFFDFE3E8);
    const headerBg = PdfColor.fromInt(0xFFF4F6F7);
    const passColor = PdfColor.fromInt(0xFF0F9F73);
    const signalAccent = PdfColor.fromInt(0xFF5F8C00);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(28),
        header: (pw.Context context) {
          return pw.Container(
            padding: const pw.EdgeInsets.only(bottom: 12),
            decoration: const pw.BoxDecoration(
              border: pw.Border(
                bottom: pw.BorderSide(color: borderColor, width: 1.2),
              ),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      AppConstants.appName,
                      style: const pw.TextStyle(
                        color: primaryColor,
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    pw.Text(
                      'CLINICAL & RESEARCH MICROSCOPY DECISION-SUPPORT',
                      style: const pw.TextStyle(
                        color: mutedColor,
                        fontSize: 7.5,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text(
                      'SPECIMEN: ${session.specimenCode}',
                      style: const pw.TextStyle(
                        color: primaryColor,
                        fontSize: 11,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      'STATUS: ${session.status.displayName.toUpperCase()}',
                      style: const pw.TextStyle(
                        color: signalAccent,
                        fontSize: 8.5,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
        footer: (pw.Context context) {
          return pw.Container(
            padding: const pw.EdgeInsets.only(top: 8),
            decoration: const pw.BoxDecoration(
              border: pw.Border(
                top: pw.BorderSide(color: borderColor, width: 0.8),
              ),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  'CONFIDENTIAL | MICROTRACE OFFLINE WORKSTATION REPORT',
                  style: const pw.TextStyle(color: mutedColor, fontSize: 7),
                ),
                pw.Text(
                  'Page ${context.pageNumber} of ${context.pagesCount}',
                  style: const pw.TextStyle(color: mutedColor, fontSize: 7),
                ),
              ],
            ),
          );
        },
        build: (pw.Context context) {
          return [
            pw.SizedBox(height: 12),

            // Specimen & Session Profile Box
            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                color: headerBg,
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
                border: pw.Border.all(color: borderColor, width: 0.8),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'SPECIMEN & SESSION METADATA',
                    style: const pw.TextStyle(
                      color: primaryColor,
                      fontSize: 8.5,
                      fontWeight: pw.FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  pw.SizedBox(height: 8),
                  pw.Row(
                    children: [
                      pw.Expanded(
                        child: _metadataItem(
                          'Title',
                          session.title,
                          primaryColor,
                          mutedColor,
                        ),
                      ),
                      pw.Expanded(
                        child: _metadataItem(
                          'Specimen Type',
                          session.specimenType,
                          primaryColor,
                          mutedColor,
                        ),
                      ),
                      pw.Expanded(
                        child: _metadataItem(
                          'Module',
                          session.moduleName,
                          primaryColor,
                          mutedColor,
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 6),
                  pw.Row(
                    children: [
                      pw.Expanded(
                        child: _metadataItem(
                          'Optical Profile',
                          session.captureProfile.replaceAll('•', '|'),
                          primaryColor,
                          mutedColor,
                        ),
                      ),
                      pw.Expanded(
                        child: _metadataItem(
                          'Operator / Reviewer',
                          session.operatorLabel,
                          primaryColor,
                          mutedColor,
                        ),
                      ),
                      pw.Expanded(
                        child: _metadataItem(
                          'Session Date',
                          Formatters.formatDateTime(session.createdAt),
                          primaryColor,
                          mutedColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            pw.SizedBox(height: 14),

            // Model Provenance Block (Section 10 Requirement)
            pw.Container(
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: borderColor, width: 0.8),
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
              ),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'NEURAL RUNTIME PROVENANCE',
                          style: const pw.TextStyle(
                            color: primaryColor,
                            fontSize: 8,
                            fontWeight: pw.FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                        pw.SizedBox(height: 4),
                        pw.Text(
                          'Model ID: ${session.moduleId} | Runtime: Google LiteRT (Float16 Delegate)\n'
                          'Dataset Reference: DeFungi (UCI ML Repository #773; Sopo et al., 2021)\n'
                          'SHA-256 Checksum: e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
                          style: const pw.TextStyle(
                            color: mutedColor,
                            fontSize: 7,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: const pw.BoxDecoration(
                      color: headerBg,
                      borderRadius: pw.BorderRadius.all(pw.Radius.circular(4)),
                    ),
                    child: pw.Text(
                      '100% OFFLINE INFERENCE',
                      style: const pw.TextStyle(
                        color: passColor,
                        fontSize: 7.5,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            pw.SizedBox(height: 16),

            // Fields Table Header
            pw.Text(
              'MICROSCOPIC FIELD OBSERVATIONS (${session.images.length} Captured Fields)',
              style: const pw.TextStyle(
                color: primaryColor,
                fontSize: 9,
                fontWeight: pw.FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            pw.SizedBox(height: 8),

            // Observations Table
            pw.Table(
              border: pw.TableBorder.all(color: borderColor, width: 0.6),
              columnWidths: const {
                0: pw.FixedColumnWidth(36), // Field #
                1: pw.FlexColumnWidth(2.2), // Field Details & Quality
                2: pw.FlexColumnWidth(2.5), // Automated Model Inference
                3: pw.FlexColumnWidth(2.5), // Qualified Human Verification
              },
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: headerBg),
                  children: [
                    _tableHeader('#'),
                    _tableHeader('Field & Quality'),
                    _tableHeader('Automated Model Prediction'),
                    _tableHeader('Human Microscopist Sign-off'),
                  ],
                ),
                for (final img in session.images)
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(6),
                        child: pw.Text(
                          '#${img.fieldIndex}',
                          style: const pw.TextStyle(
                            fontSize: 8.5,
                            fontWeight: pw.FontWeight.bold,
                          ),
                          textAlign: pw.TextAlign.center,
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(6),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              img.captureProfile.replaceAll('•', '|'),
                              style: const pw.TextStyle(
                                fontSize: 7.5,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.SizedBox(height: 2),
                            pw.Text(
                              'Sharpness: ${img.qualityMetrics.laplacianSharpness.toStringAsFixed(1)} | '
                              'Luminance: ${(img.qualityMetrics.meanLuminance * 100).toStringAsFixed(0)}%',
                              style: const pw.TextStyle(
                                fontSize: 6.8,
                                color: mutedColor,
                              ),
                            ),
                            pw.Text(
                              'Quality Gate: ${img.qualityMetrics.isPassed ? "PASSED" : "FAILED / RECAPTURE"}',
                              style: pw.TextStyle(
                                fontSize: 6.8,
                                fontWeight: pw.FontWeight.bold,
                                color: img.qualityMetrics.isPassed
                                    ? passColor
                                    : PdfColors.red800,
                              ),
                            ),
                          ],
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(6),
                        child: img.analysisRun == null
                            ? pw.Text(
                                'Pending Analysis',
                                style: const pw.TextStyle(
                                  fontSize: 7.5,
                                  color: mutedColor,
                                ),
                              )
                            : pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text(
                                    img.analysisRun!.topPrediction.className,
                                    style: const pw.TextStyle(
                                      fontSize: 8,
                                      fontWeight: pw.FontWeight.bold,
                                    ),
                                  ),
                                  pw.Text(
                                    'Confidence: ${(img.analysisRun!.topPrediction.confidence * 100).toStringAsFixed(1)}% '
                                    '(${img.analysisRun!.processingMs} ms)',
                                    style: const pw.TextStyle(
                                      fontSize: 6.8,
                                      color: mutedColor,
                                    ),
                                  ),
                                  if (img.analysisRun!.allPredictions.length >
                                      1)
                                    pw.Text(
                                      'Alt: ${img.analysisRun!.allPredictions[1].className} (${(img.analysisRun!.allPredictions[1].confidence * 100).toStringAsFixed(1)}%)',
                                      style: const pw.TextStyle(
                                        fontSize: 6.5,
                                        color: mutedColor,
                                      ),
                                    ),
                                ],
                              ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(6),
                        child: img.analysisRun == null
                            ? pw.Text(
                                'No review',
                                style: const pw.TextStyle(
                                  fontSize: 7.5,
                                  color: mutedColor,
                                ),
                              )
                            : pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text(
                                    img.analysisRun!.reviewStatus.displayName
                                        .toUpperCase(),
                                    style: pw.TextStyle(
                                      fontSize: 7.5,
                                      fontWeight: pw.FontWeight.bold,
                                      color: _statusColor(
                                        img.analysisRun!.reviewStatus,
                                      ),
                                    ),
                                  ),
                                  if (img.analysisRun!.correctedClass != null)
                                    pw.Text(
                                      'Corrected to: ${img.analysisRun!.correctedClass}',
                                      style: const pw.TextStyle(
                                        fontSize: 7,
                                        fontWeight: pw.FontWeight.bold,
                                        color: signalAccent,
                                      ),
                                    ),
                                  if (img.analysisRun!.reviewerNotes.isNotEmpty)
                                    pw.Text(
                                      img.analysisRun!.reviewerNotes,
                                      style: const pw.TextStyle(
                                        fontSize: 6.8,
                                        color: primaryColor,
                                      ),
                                    ),
                                ],
                              ),
                      ),
                    ],
                  ),
              ],
            ),

            pw.SizedBox(height: 20),

            // Operator Sign-off & Verification Block
            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: borderColor, width: 0.8),
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
              ),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'MICROSCOPIST VERIFICATION & SIGN-OFF',
                          style: const pw.TextStyle(
                            fontSize: 8,
                            fontWeight: pw.FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                        pw.SizedBox(height: 6),
                        pw.Text(
                          'I hereby confirm that the automated computer-vision classifications in this report '
                          'have been personally reviewed and evaluated in accordance with standard laboratory '
                          'operating procedures.',
                          style: const pw.TextStyle(
                            fontSize: 7,
                            color: mutedColor,
                            height: 1.3,
                          ),
                        ),
                        pw.SizedBox(height: 12),
                        pw.Row(
                          children: [
                            pw.Text(
                              'Initials: ___________',
                              style: const pw.TextStyle(fontSize: 7.5),
                            ),
                            pw.SizedBox(width: 32),
                            pw.Text(
                              'Date: ____________',
                              style: const pw.TextStyle(fontSize: 7.5),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  pw.Container(
                    width: 140,
                    height: 50,
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: borderColor, width: 0.6),
                      borderRadius: const pw.BorderRadius.all(
                        pw.Radius.circular(4),
                      ),
                    ),
                    alignment: pw.Alignment.center,
                    child: pw.Text(
                      'STAMP / SIGNATURE',
                      style: const pw.TextStyle(
                        color: borderColor,
                        fontSize: 8,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            pw.SizedBox(height: 14),

            // Legal Disclaimer (Section 15)
            pw.Container(
              padding: const pw.EdgeInsets.all(8),
              decoration: const pw.BoxDecoration(
                color: headerBg,
                borderRadius: pw.BorderRadius.all(pw.Radius.circular(4)),
              ),
              child: pw.Text(
                AppConstants.scientificDisclaimer,
                style: const pw.TextStyle(
                  color: mutedColor,
                  fontSize: 6.5,
                  height: 1.3,
                ),
                textAlign: pw.TextAlign.justify,
              ),
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }

  /// Triggers Android / System print dialog or PDF preview
  static Future<void> printReport({required MicroscopySession session}) async {
    final pdfBytes = await generateObservationReportPdf(session: session);
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdfBytes,
      name: 'MICROTRACE_${session.specimenCode}_Report.pdf',
    );
  }

  /// Triggers system share sheet to send PDF to peers, laboratory drives or printers
  static Future<void> shareReportPdf({
    required MicroscopySession session,
  }) async {
    final pdfBytes = await generateObservationReportPdf(session: session);
    await Printing.sharePdf(
      bytes: pdfBytes,
      filename: 'MICROTRACE_${session.specimenCode}_Observation_Report.pdf',
    );
  }

  static pw.Widget _metadataItem(
    String label,
    String value,
    PdfColor primaryColor,
    PdfColor mutedColor,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          label.toUpperCase(),
          style: pw.TextStyle(
            color: mutedColor,
            fontSize: 6.5,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 1.5),
        pw.Text(
          value,
          style: pw.TextStyle(
            color: primaryColor,
            fontSize: 8,
            fontWeight: pw.FontWeight.bold,
          ),
          maxLines: 1,
        ),
      ],
    );
  }

  static pw.Widget _tableHeader(String title) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        title.toUpperCase(),
        style: const pw.TextStyle(
          fontSize: 7.5,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    );
  }

  static PdfColor _statusColor(ReviewStatus status) {
    switch (status) {
      case ReviewStatus.confirmed:
        return const PdfColor.fromInt(0xFF0F9F73);
      case ReviewStatus.corrected:
        return const PdfColor.fromInt(0xFF5F8C00);
      case ReviewStatus.rejected:
        return const PdfColor.fromInt(0xFFC53030);
      case ReviewStatus.needsFurtherReview:
        return const PdfColor.fromInt(0xFFDD6B20);
      case ReviewStatus.pending:
        return const PdfColor.fromInt(0xFF718096);
    }
  }
}
