import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/ai_chat_data_source.dart';
import '../../domain/entities/chat_message.dart';
import '../state/ai_chat_state.dart';

class AiChatNotifier extends StateNotifier<AiChatState> {
  final AiChatDataSource _dataSource;

  AiChatNotifier(this._dataSource) : super(const AiChatState());

  Future<void> sendMessage(String content) async {
    final text = content.trim();
    if (text.isEmpty) return;

    final userMsg = ChatMessage(
      id: '${DateTime.now().millisecondsSinceEpoch}_user',
      role: MessageRole.user,
      content: text,
      timestamp: DateTime.now(),
    );

    // Append user message and start typing indicator
    state = state.copyWith(
      messages: [...state.messages, userMsg],
      isTyping: true,
      clearError: true,
    );

    try {
      // Pass only the conversation history (excluding the just-added user msg
      // because the data source appends newUserMessage separately)
      final history = state.messages
          .where((m) => m.id != userMsg.id)
          .toList();

      final reply = await _dataSource.sendMessage(history, text);

      final aiMsg = ChatMessage(
        id: '${DateTime.now().millisecondsSinceEpoch}_ai',
        role: MessageRole.assistant,
        content: reply,
        timestamp: DateTime.now(),
      );

      state = state.copyWith(
        messages: [...state.messages, aiMsg],
        isTyping: false,
      );
    } catch (e, st) {
      debugPrint('[AiChat] Notifier caught error: $e\n$st');
      final msg = e is AiChatException
          ? e.message
          : 'Could not reach the assistant. Please try again.';
      state = state.copyWith(isTyping: false, error: msg);
    }
  }

  void clearChat() => state = const AiChatState();

  void dismissError() => state = state.copyWith(clearError: true);
}
