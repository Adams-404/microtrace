/// Settings for the on-device OpenAI-compatible model server.
///
/// Defaults match the Clearport / llama.cpp Termux setup used on the phone:
/// `clearport start` serves an OpenAI-compatible API at 127.0.0.1:8080/v1.
class AssistantSettings {
  final String baseUrl;
  final String model;
  final String apiKey;
  final double temperature;

  const AssistantSettings({
    this.baseUrl = defaultBaseUrl,
    this.model = '',
    this.apiKey = '',
    this.temperature = 0.5,
  });

  static const String defaultBaseUrl = 'http://127.0.0.1:8080/v1';

  static String normalizeBaseUrl(String raw) {
    var value = raw.trim();
    if (value.isEmpty) return defaultBaseUrl;
    if (!value.contains('://')) value = 'http://$value';
    while (value.endsWith('/')) {
      value = value.substring(0, value.length - 1);
    }
    const suffixes = ['/chat/completions', '/completions', '/models'];
    for (final suffix in suffixes) {
      if (value.endsWith(suffix)) {
        value = value.substring(0, value.length - suffix.length);
        break;
      }
    }
    while (value.endsWith('/')) {
      value = value.substring(0, value.length - 1);
    }
    return value;
  }

  AssistantSettings copyWith({
    String? baseUrl,
    String? model,
    String? apiKey,
    double? temperature,
  }) {
    return AssistantSettings(
      baseUrl: baseUrl ?? this.baseUrl,
      model: model ?? this.model,
      apiKey: apiKey ?? this.apiKey,
      temperature: temperature ?? this.temperature,
    );
  }

  Map<String, dynamic> toJson() => {
    'baseUrl': baseUrl,
    'model': model,
    'apiKey': apiKey,
    'temperature': temperature,
  };

  static AssistantSettings fromJson(Map<String, dynamic> json) {
    return AssistantSettings(
      baseUrl: (json['baseUrl'] as String?) ?? defaultBaseUrl,
      model: (json['model'] as String?) ?? '',
      apiKey: (json['apiKey'] as String?) ?? '',
      temperature: (json['temperature'] as num?)?.toDouble() ?? 0.5,
    );
  }
}
