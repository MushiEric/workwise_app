import 'package:flutter/widgets.dart';

import '../pages/jobcard_list_page.dart';
import '../pages/jobcard_create_page.dart';
import '../pages/jobcard_detail_page.dart';
import '../pages/jobcard_settings_page.dart';

abstract class JobcardRoutes {
  static const list = '/jobcards';
  static const create = '/jobcards/create';
  static const detail = '/jobcards/detail';
  static const settings = '/jobcards/settings';
}

class JobcardRouter {
  static Map<String, WidgetBuilder> get routes => {
    JobcardRoutes.list: (_) => const JobcardListPage(),
    JobcardRoutes.create: (_) => const JobcardCreatePage(),
    JobcardRoutes.detail: (_) => const JobcardDetailPage(),
    JobcardRoutes.settings: (_) => const JobcardSettingsPage(),
  };
}
