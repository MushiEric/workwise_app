import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/ai_chat_data_source.dart';
import '../notifier/ai_chat_notifier.dart';
import '../state/ai_chat_state.dart';

final aiChatDataSourceProvider = Provider<AiChatDataSource>(
  (_) => AiChatDataSource(),
);

final aiChatProvider =
    StateNotifierProvider.autoDispose<AiChatNotifier, AiChatState>(
  (ref) {
    final ds = ref.watch(aiChatDataSourceProvider);
    return AiChatNotifier(ds);
  },
);
