import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/core/errors/failure.dart';
import 'package:workwise_erp/features/auth/domain/repositories/auth_repository.dart';
import 'package:workwise_erp/features/auth/domain/usecases/change_password_using_otp.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockRepo;
  late ChangePasswordUsingOtp usecase;

  setUp(() {
    mockRepo = MockAuthRepository();
    usecase = ChangePasswordUsingOtp(mockRepo);
  });

  test('returns Right(null) when repository succeeds', () async {
    when(() => mockRepo.changePasswordUsingOtp(emailOrPhone: any(named: 'emailOrPhone'), otp: any(named: 'otp'), newPassword: any(named: 'newPassword')))
        .thenAnswer((_) async => const Either.right(null));

    final res = await usecase.call(ChangePasswordUsingOtpParams(emailOrPhone: 'a@b.com', otp: '123456', newPassword: 'newpass'));

    expect(res.isRight, true);
    verify(() => mockRepo.changePasswordUsingOtp(emailOrPhone: 'a@b.com', otp: '123456', newPassword: 'newpass')).called(1);
  });

  test('forwards Failure when repository returns Left', () async {
    final failure = ServerFailure('expired otp');
    when(() => mockRepo.changePasswordUsingOtp(emailOrPhone: any(named: 'emailOrPhone'), otp: any(named: 'otp'), newPassword: any(named: 'newPassword')))
        .thenAnswer((_) async => Either.left(failure));

    final res = await usecase.call(ChangePasswordUsingOtpParams(emailOrPhone: '+12345678901', otp: '000000', newPassword: 'x'));

    expect(res.isLeft, true);
    res.fold(
      (l) => expect(l, failure),
      (r) => fail('Expected Left'),
    );

    verify(() => mockRepo.changePasswordUsingOtp(emailOrPhone: '+12345678901', otp: '000000', newPassword: 'x')).called(1);
  });
}
