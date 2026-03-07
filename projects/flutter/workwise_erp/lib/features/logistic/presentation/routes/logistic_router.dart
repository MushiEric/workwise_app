import 'package:flutter/widgets.dart';

import '../pages/logistic_page.dart';
import '../pages/trips_page.dart';
import '../pages/operators_page.dart';
import '../pages/operator_detail_page.dart';

abstract class LogisticRoutes {
  static const logistic = '/logistic';
  static const trips = '/logistic/trips';
  static const operators = '/logistic/operators';
  static const operatorDetail = '/logistic/operators/detail';
}

class LogisticRouter {
  static Map<String, WidgetBuilder> get routes => {
    LogisticRoutes.logistic: (_) => const LogisticPage(),
    LogisticRoutes.trips: (_) => const TripsPage(),
    LogisticRoutes.operators: (_) => const OperatorsPage(),
    LogisticRoutes.operatorDetail: (_) => const OperatorDetailPage(),
  };
}
