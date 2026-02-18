import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/core/errors/failure.dart';
import 'package:workwise_erp/features/auth/domain/repositories/auth_repository.dart';
import 'package:workwise_erp/features/auth/domain/usecases/verify_forgot_password_otp.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockRepo;
  late VerifyForgotPasswordOtp usecase;

  setUp(() {
    mockRepo = MockAuthRepository();
    usecase = VerifyForgotPasswordOtp(mockRepo);
  });

  test('returns Right(null) when repository succeeds', () async {
    when(() => mockRepo.verifyForgotPasswordOtp(emailOrPhone: any(named: 'emailOrPhone'), otp: any(named: 'otp')))
        .thenAnswer((_) async => const Either.right(null));

    final res = await usecase.call(VerifyForgotPasswordOtpParams(emailOrPhone: 'a@b.com', otp: '123456'));

    expect(res.isRight, true);
    verify(() => mockRepo.verifyForgotPasswordOtp(emailOrPhone: 'a@b.com', otp: '123456')).called(1);
  });

  test('forwards Failure when repository returns Left', () async {
    final failure = ServerFailure('invalid otp');
    when(() => mockRepo.verifyForgotPasswordOtp(emailOrPhone: any(named: 'emailOrPhone'), otp: any(named: 'otp')))
        .thenAnswer((_) async => Either.left(failure));

    final res = await usecase.call(VerifyForgotPasswordOtpParams(emailOrPhone: '+12345678901', otp: '000000'));

    expect(res.isLeft, true);
    res.fold(
      (l) => expect(l, failure),
      (r) => fail('Expected Left'),
    );

    verify(() => mockRepo.verifyForgotPasswordOtp(emailOrPhone: '+12345678901', otp: '000000')).called(1);
  });
}
