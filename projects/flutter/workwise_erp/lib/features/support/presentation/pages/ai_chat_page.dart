import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:workwise_erp/core/themes/app_colors.dart';
import '../../../../core/widgets/app_bar.dart';
import '../../domain/entities/chat_message.dart';
import '../providers/ai_chat_providers.dart';

class AiChatPage extends ConsumerStatefulWidget {
  const AiChatPage({super.key});

  @override
  ConsumerState<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends ConsumerState<AiChatPage>
    with TickerProviderStateMixin {
  final _inputController = TextEditingController();
  final _scrollController = ScrollController();
  final _inputFocus = FocusNode();

  late final AnimationController _dotController;

  static const _suggestions = [
    'What is Workwise ERP?',
    'What modules are available?',
    'How do I create a support ticket?',
    'How does GPS tracking work?',
    'How do I contact support?',
  ];

  @override
  void initState() {
    super.initState();
    _dotController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    _inputFocus.dispose();
    _dotController.dispose();
    super.dispose();
  }

  void _scrollToBottom({bool animated = true}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      if (animated) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 80,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      } else {
        _scrollController.jumpTo(
          _scrollController.position.maxScrollExtent + 80,
        );
      }
    });
  }

  Future<void> _send([String? override]) async {
    final text = override ?? _inputController.text;
    if (text.trim().isEmpty) return;
    _inputController.clear();
    _inputFocus.unfocus();
    await ref.read(aiChatProvider.notifier).sendMessage(text);
    _scrollToBottom();
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final state = ref.watch(aiChatProvider);

    // Scroll when new messages arrive
    ref.listen(aiChatProvider, (_, __) => _scrollToBottom());

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: _buildAppBar(isDark),
      body: Column(
        children: [
          // Error banner
          if (state.error != null) _buildErrorBanner(state.error!, isDark),

          // Messages list
          Expanded(
            child: state.messages.isEmpty
                ? _buildEmptyState(isDark)
                : _buildMessageList(state, isDark),
          ),

          // Typing indicator
          if (state.isTyping) _buildTypingIndicator(isDark),

          // Input bar
          _buildInputBar(isDark),
        ],
      ),
    );
  }

  // ── App bar ────────────────────────────────────────────────────────────────

  PreferredSizeWidget _buildAppBar(bool isDark) {
    return CustomAppBar(
      title: 'AI Assistant',
      titleWidget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'AI Assistant',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          Text(
            'Workwise ERP Support',
            style: TextStyle(
              fontSize: 11,
              color: Colors.white.withOpacity(0.75),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
      centerTitle: false,
      actions: [
        IconButton(
          tooltip: 'Clear conversation',
          icon: const Icon(Icons.delete_sweep_outlined, color: Colors.white),
          onPressed: () => _confirmClear(isDark),
        ),
      ],
    );
  }

  void _confirmClear(bool isDark) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        title: const Text('Clear conversation'),
        content:
            const Text('All messages will be removed. This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(aiChatProvider.notifier).clearChat();
              Navigator.pop(context);
            },
            child: Text('Clear', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  // ── Empty state ────────────────────────────────────────────────────────────

  Widget _buildEmptyState(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        children: [
          // Bot avatar
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.12),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: const Icon(
              LucideIcons.bot,
              size: 40,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Hello! I\'m your Workwise\nAI Assistant',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
              height: 1.3,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Ask me anything about Workwise ERP system and Getcore Company.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white54 : Colors.black45,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          // Suggestion chips
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: _suggestions
                .map((s) => _suggestionChip(s, isDark))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _suggestionChip(String text, bool isDark) {
    return GestureDetector(
      onTap: () => _send(text),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark
                ? AppColors.primary.withOpacity(0.4)
                : AppColors.primary.withOpacity(0.25),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 13,
            color: isDark ? Colors.white70 : const Color(0xFF334155),
          ),
        ),
      ),
    );
  }

  // ── Message list ───────────────────────────────────────────────────────────

  Widget _buildMessageList(state, bool isDark) {
    final messages = state.messages as List<ChatMessage>;
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: messages.length,
      itemBuilder: (_, i) {
        final msg = messages[i];
        final prev = i > 0 ? messages[i - 1] : null;
        final showAvatar =
            msg.isAssistant && (prev == null || prev.isUser);
        return _MessageBubble(
          message: msg,
          showAvatar: showAvatar,
          isDark: isDark,
        );
      },
    );
  }

  // ── Typing indicator ───────────────────────────────────────────────────────

  Widget _buildTypingIndicator(bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 4, right: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _botAvatar(size: 28),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomRight: Radius.circular(18),
                bottomLeft: Radius.circular(4),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: _TypingDots(controller: _dotController, isDark: isDark),
          ),
        ],
      ),
    );
  }

  // ── Error banner ───────────────────────────────────────────────────────────

  Widget _buildErrorBanner(String message, bool isDark) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.error.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, size: 18, color: AppColors.error),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.error,
              ),
            ),
          ),
          GestureDetector(
            onTap: () =>
                ref.read(aiChatProvider.notifier).dismissError(),
            child: Icon(Icons.close, size: 18, color: AppColors.error),
          ),
        ],
      ),
    );
  }

  // ── Input bar ──────────────────────────────────────────────────────────────

  Widget _buildInputBar(bool isDark) {
    return Container(
      padding: EdgeInsets.only(
        left: 12,
        right: 8,
        top: 10,
        bottom: MediaQuery.of(context).viewInsets.bottom > 0 ? 10 : 20,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              constraints: const BoxConstraints(maxHeight: 120),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF0F172A)
                    : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _inputController,
                focusNode: _inputFocus,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                textCapitalization: TextCapitalization.sentences,
                style: TextStyle(
                  fontSize: 15,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
                decoration: InputDecoration(
                  hintText: 'Ask me anything about Workwise…',
                  hintStyle: TextStyle(
                    color: isDark ? Colors.white38 : Colors.black38,
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                ),
                onSubmitted: (_) => _send(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: _inputController,
            builder: (_, value, __) {
              final hasText = value.text.trim().isNotEmpty;
              return AnimatedScale(
                scale: hasText ? 1.0 : 0.85,
                duration: const Duration(milliseconds: 200),
                child: GestureDetector(
                  onTap: hasText ? _send : null,
                  child: Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: hasText
                          ? AppColors.primary
                          : (isDark
                              ? Colors.white12
                              : Colors.black12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.send_rounded,
                      size: 20,
                      color: hasText
                          ? Colors.white
                          : (isDark ? Colors.white38 : Colors.black38),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  Widget _botAvatar({double size = 32}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.15),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.smart_toy_rounded,
        size: size * 0.55,
        color: AppColors.primary,
      ),
    );
  }
}

// ── Message bubble widget ──────────────────────────────────────────────────────

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool showAvatar;
  final bool isDark;

  const _MessageBubble({
    required this.message,
    required this.showAvatar,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    return Padding(
      padding: EdgeInsets.only(
        top: 4,
        bottom: 4,
        left: isUser ? 48 : 0,
        right: isUser ? 0 : 48,
      ),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            showAvatar
                ? _botAvatarWidget()
                : const SizedBox(width: 32),
            const SizedBox(width: 8),
          ],
          Flexible(child: _bubble(context)),
          if (isUser) ...[
            const SizedBox(width: 8),
            _userAvatarWidget(),
          ],
        ],
      ),
    );
  }

  Widget _bubble(BuildContext context) {
    final isUser = message.isUser;
    final timeStr = DateFormat('HH:mm').format(message.timestamp);

    return Column(
      crossAxisAlignment:
          isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: isUser
                ? AppColors.primary
                : (isDark ? const Color(0xFF1E293B) : Colors.white),
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(18),
              topRight: const Radius.circular(18),
              bottomLeft: Radius.circular(isUser ? 18 : 4),
              bottomRight: Radius.circular(isUser ? 4 : 18),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.07),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            message.content,
            style: TextStyle(
              fontSize: 14.5,
              height: 1.45,
              color: isUser
                  ? Colors.white
                  : (isDark ? const Color(0xDEFFFFFF) : const Color(0xFF1E293B)),
            ),
          ),
        ),
        const SizedBox(height: 3),
        Text(
          timeStr,
          style: TextStyle(
            fontSize: 10.5,
            color: isDark ? Colors.white30 : Colors.black38,
          ),
        ),
      ],
    );
  }

  Widget _botAvatarWidget() {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.15),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.smart_toy_rounded,
        size: 17,
        color: AppColors.primary,
      ),
    );
  }

  Widget _userAvatarWidget() {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.person_rounded,
        size: 17,
        color: AppColors.primary,
      ),
    );
  }
}

// ── Animated typing dots ───────────────────────────────────────────────────────

class _TypingDots extends StatelessWidget {
  final AnimationController controller;
  final bool isDark;

  const _TypingDots({required this.controller, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final delay = i / 3;
            final t = ((controller.value + (1 - delay)) % 1.0);
            final scale = 0.6 + 0.4 * sin(t * pi);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.5),
              child: Transform.scale(
                scale: scale,
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white54
                        : Colors.black38,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
