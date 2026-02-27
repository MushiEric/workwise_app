import '../../domain/entities/chat_message.dart';

class AiChatState {
  final List<ChatMessage> messages;
  final bool isTyping;
  final String? error;

  const AiChatState({
    this.messages = const [],
    this.isTyping = false,
    this.error,
  });

  AiChatState copyWith({
    List<ChatMessage>? messages,
    bool? isTyping,
    String? error,
    bool clearError = false,
  }) {
    return AiChatState(
      messages: messages ?? this.messages,
      isTyping: isTyping ?? this.isTyping,
      error: clearError ? null : (error ?? this.error),
    );
  }
}
