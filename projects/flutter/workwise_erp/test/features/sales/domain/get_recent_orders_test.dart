import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/core/errors/failure.dart';
import 'package:workwise_erp/features/sales/domain/entities/sales_order.dart';
import 'package:workwise_erp/features/sales/domain/repositories/sales_repository.dart';
import 'package:workwise_erp/features/sales/domain/usecases/get_recent_orders.dart';

class MockSalesRepository extends Mock implements SalesRepository {}

void main() {
  late MockSalesRepository mockRepo;
  late GetRecentOrders usecase;

  setUp(() {
    mockRepo = MockSalesRepository();
    usecase = GetRecentOrders(mockRepo);
  });

  final sampleOrder = SalesOrder(id: 1, orderNumber: 'ORD/1', amount: 100);

  test('returns Right(List<SalesOrder>) when repository succeeds', () async {
    when(() => mockRepo.getRecentOrders()).thenAnswer((_) async => Either.right([sampleOrder]));

    final result = await usecase.call();

    expect(result.isRight, true);
    result.fold(
      (l) => fail('Expected Right, got Failure'),
      (r) => expect(r, [sampleOrder]),
    );

    verify(() => mockRepo.getRecentOrders()).called(1);
    verifyNoMoreInteractions(mockRepo);
  });

  test('forwards Failure when repository returns Left', () async {
    final failure = ServerFailure('server down');
    when(() => mockRepo.getRecentOrders()).thenAnswer((_) async => Either.left(failure));

    final result = await usecase.call();

    expect(result.isLeft, true);
    result.fold(
      (l) => expect(l, failure),
      (r) => fail('Expected Left, got Right'),
    );

    verify(() => mockRepo.getRecentOrders()).called(1);
    verifyNoMoreInteractions(mockRepo);
  });
}
