class ModuleInfo {
  final String id;
  final String name;
  final String category;
  final String shortDescription;
  final String fullDescription;
  final List<String> supportedSpecimens;
  final String supportedTask;
  final bool isInstalled;
  final bool isAvailable;
  final String version;
  final String recommendedMagnification;
  final String datasetReference;
  final String license;

  const ModuleInfo({
    required this.id,
    required this.name,
    required this.category,
    required this.shortDescription,
    required this.fullDescription,
    required this.supportedSpecimens,
    required this.supportedTask,
    required this.isInstalled,
    required this.isAvailable,
    required this.version,
    required this.recommendedMagnification,
    required this.datasetReference,
    required this.license,
  });

  ModuleInfo copyWith({
    String? id,
    String? name,
    String? category,
    String? shortDescription,
    String? fullDescription,
    List<String>? supportedSpecimens,
    String? supportedTask,
    bool? isInstalled,
    bool? isAvailable,
    String? version,
    String? recommendedMagnification,
    String? datasetReference,
    String? license,
  }) {
    return ModuleInfo(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      shortDescription: shortDescription ?? this.shortDescription,
      fullDescription: fullDescription ?? this.fullDescription,
      supportedSpecimens: supportedSpecimens ?? this.supportedSpecimens,
      supportedTask: supportedTask ?? this.supportedTask,
      isInstalled: isInstalled ?? this.isInstalled,
      isAvailable: isAvailable ?? this.isAvailable,
      version: version ?? this.version,
      recommendedMagnification: recommendedMagnification ?? this.recommendedMagnification,
      datasetReference: datasetReference ?? this.datasetReference,
      license: license ?? this.license,
    );
  }
}
