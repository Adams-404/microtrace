/// Core constants for MICROTRACE
class AppConstants {
  static const String appName = 'MICROTRACE';
  static const String appVersion = '0.1.0-alpha.preview';
  static const String appTagline = 'Smartphone-Assisted Microscopy Workstation';

  // Scientific & Medical Disclaimer
  static const String scientificDisclaimer =
      'MICROTRACE is an offline-first research and laboratory decision-support tool. '
      'It is not certified as an in-vitro diagnostic medical device and does not '
      'replace professional histological, mycological, or pathological examination. '
      'All automated computer-vision predictions must be reviewed, verified, or corrected '
      'by qualified laboratory personnel.';

  // Storage and offline limits
  static const String defaultStoragePath =
      '/data/user/0/com.microtrace/app_data';
  static const int maxFieldsPerSession = 50;

  // Initial Supported Module IDs
  static const String moduleMycologyId = 'module_mycology_v1';
  static const String moduleParasitologyId = 'module_parasitology_v1';
  static const String moduleCellAnalysisId = 'module_cell_analysis_v1';
  static const String moduleMalariaSmearId = 'module_malaria_smear_v1';
}
