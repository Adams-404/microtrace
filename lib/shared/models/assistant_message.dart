enum AssistantRole { user, assistant }

extension AssistantRoleWire on AssistantRole {
  String get wireName => this == AssistantRole.user ? 'user' : 'assistant';
}

class AssistantMessage {
  final AssistantRole role;
  final String content;
  final bool isError;

  const AssistantMessage({
    required this.role,
    required this.content,
    this.isError = false,
  });

  AssistantMessage copyWith({String? content, bool? isError}) {
    return AssistantMessage(
      role: role,
      content: content ?? this.content,
      isError: isError ?? this.isError,
    );
  }
}
