class ModelInstallation {
  final String modelId;
  final String name;
  final String version;
  final String moduleId;
  final String runtime;
  final String taskType;
  final int sizeBytes;
  final String sha256Checksum;
  final bool isInstalled;
  final DateTime installedAt;
  final String accuracyReport;
  final String inputDimensions;

  const ModelInstallation({
    required this.modelId,
    required this.name,
    required this.version,
    required this.moduleId,
    required this.runtime,
    required this.taskType,
    required this.sizeBytes,
    required this.sha256Checksum,
    required this.isInstalled,
    required this.installedAt,
    required this.accuracyReport,
    required this.inputDimensions,
  });

  ModelInstallation copyWith({
    String? modelId,
    String? name,
    String? version,
    String? moduleId,
    String? runtime,
    String? taskType,
    int? sizeBytes,
    String? sha256Checksum,
    bool? isInstalled,
    DateTime? installedAt,
    String? accuracyReport,
    String? inputDimensions,
  }) {
    return ModelInstallation(
      modelId: modelId ?? this.modelId,
      name: name ?? this.name,
      version: version ?? this.version,
      moduleId: moduleId ?? this.moduleId,
      runtime: runtime ?? this.runtime,
      taskType: taskType ?? this.taskType,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      sha256Checksum: sha256Checksum ?? this.sha256Checksum,
      isInstalled: isInstalled ?? this.isInstalled,
      installedAt: installedAt ?? this.installedAt,
      accuracyReport: accuracyReport ?? this.accuracyReport,
      inputDimensions: inputDimensions ?? this.inputDimensions,
    );
  }
}
