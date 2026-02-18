import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/core/errors/failure.dart';
import 'package:workwise_erp/features/auth/domain/repositories/auth_repository.dart';
import 'package:workwise_erp/features/auth/domain/usecases/forgot_password.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockRepo;
  late ForgotPassword usecase;

  setUp(() {
    mockRepo = MockAuthRepository();
    usecase = ForgotPassword(mockRepo);
  });

  test('returns Right(null) when repository succeeds', () async {
    when(() => mockRepo.forgotPassword(emailOrPhone: any(named: 'emailOrPhone')))
        .thenAnswer((_) async => const Either.right(null));

    final res = await usecase.call(ForgotPasswordParams(emailOrPhone: 'a@b.com'));

    expect(res.isRight, true);
    verify(() => mockRepo.forgotPassword(emailOrPhone: 'a@b.com')).called(1);
  });

  test('forwards Failure when repository returns Left', () async {
    final failure = ServerFailure('not found');
    when(() => mockRepo.forgotPassword(emailOrPhone: any(named: 'emailOrPhone')))
        .thenAnswer((_) async => Either.left(failure));

    final res = await usecase.call(ForgotPasswordParams(emailOrPhone: '+12345678901'));

    expect(res.isLeft, true);
    res.fold(
      (l) => expect(l, failure),
      (r) => fail('Expected Left'),
    );

    verify(() => mockRepo.forgotPassword(emailOrPhone: '+12345678901')).called(1);
  });
}
