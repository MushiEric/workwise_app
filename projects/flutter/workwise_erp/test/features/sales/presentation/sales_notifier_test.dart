import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/core/errors/failure.dart';
import 'package:workwise_erp/features/sales/domain/entities/sales_order.dart';
import 'package:workwise_erp/features/sales/domain/usecases/get_recent_orders.dart';
import 'package:workwise_erp/features/sales/presentation/notifier/sales_notifier.dart';
import 'package:workwise_erp/features/sales/presentation/state/sales_state.dart';

class MockGetRecentOrders extends Mock implements GetRecentOrders {}

void main() {
  late MockGetRecentOrders mockUsecase;
  late SalesNotifier notifier;

  setUp(() {
    mockUsecase = MockGetRecentOrders();
    notifier = SalesNotifier(getRecentOrders: mockUsecase);
  });

  final sample = SalesOrder(id: 1, orderNumber: 'ORD/1', amount: 100);

  test('loads orders on success', () async {
    when(() => mockUsecase.call()).thenAnswer((_) async => Either.right([sample]));

    await notifier.loadOrders();

    final loaded = notifier.state.maybeWhen(loaded: (l) => l, orElse: () => null);
    expect(loaded, isNotNull);
    expect(loaded, [sample]);
  });

  test('emits error on failure', () async {
    final failure = ServerFailure('server');
    when(() => mockUsecase.call()).thenAnswer((_) async => Either.left(failure));

    await notifier.loadOrders();

    final err = notifier.state.maybeWhen(error: (m) => m, orElse: () => null);
    expect(err, 'server');
  });
}
