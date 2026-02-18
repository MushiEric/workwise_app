import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/core/errors/failure.dart';
import 'package:workwise_erp/features/auth/domain/entities/user.dart';
import 'package:workwise_erp/features/auth/domain/repositories/auth_repository.dart';
import 'package:workwise_erp/features/auth/domain/usecases/get_current_user.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockRepo;
  late GetCurrentUser usecase;

  setUp(() {
    mockRepo = MockAuthRepository();
    usecase = GetCurrentUser(mockRepo);
  });

  final testUser = User(id: 1, name: 'Bob', email: 'bob@example.com');

  test('returns Right(User) when repository succeeds', () async {
    when(() => mockRepo.fetchCurrentUser())
        .thenAnswer((_) async => Either.right(testUser));

    final result = await usecase.call();

    expect(result.isRight, true);
    result.fold(
      (l) => fail('Expected Right, got Failure'),
      (r) => expect(r, testUser),
    );

    verify(() => mockRepo.fetchCurrentUser()).called(1);
    verifyNoMoreInteractions(mockRepo);
  });

  test('forwards Failure when repository returns Left', () async {
    final failure = ServerFailure('server down');
    when(() => mockRepo.fetchCurrentUser())
        .thenAnswer((_) async => Either.left(failure));

    final result = await usecase.call();

    expect(result.isLeft, true);
    result.fold(
      (l) => expect(l, failure),
      (r) => fail('Expected Left, got Right'),
    );

    verify(() => mockRepo.fetchCurrentUser()).called(1);
    verifyNoMoreInteractions(mockRepo);
  });
}
