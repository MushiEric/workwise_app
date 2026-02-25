enum MessageRole { user, assistant }

class ChatMessage {
  final String id;
  final MessageRole role;
  final String content;
  final DateTime timestamp;

  const ChatMessage({
    required this.id,
    required this.role,
    required this.content,
    required this.timestamp,
  });

  bool get isUser => role == MessageRole.user;
  bool get isAssistant => role == MessageRole.assistant;
}
