import 'package:flutter/widgets.dart';

import '../pages/support_list_page.dart';
import '../pages/ai_chat_page.dart';

abstract class SupportRoutes {
  static const list = '/support';
  static const ai = '/support/ai';
}

class SupportRouter {
  static Map<String, WidgetBuilder> get routes => {
    SupportRoutes.list: (_) => const SupportListPage(),
    SupportRoutes.ai: (_) => const AiChatPage(),
  };
}
