import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/core/errors/failure.dart';
import 'package:workwise_erp/features/auth/domain/usecases/verify_forgot_password_otp.dart';
import 'package:workwise_erp/features/auth/presentation/providers/auth_providers.dart';
import 'package:workwise_erp/features/auth/presentation/pages/verify_forgot_password_otp_page.dart';
import 'package:workwise_erp/features/auth/presentation/pages/change_password_using_otp_page.dart';

class MockVerifyUsecase extends Mock implements VerifyForgotPasswordOtp {}

void main() {
  late MockVerifyUsecase mockUsecase;

  setUpAll(() {
    registerFallbackValue(VerifyForgotPasswordOtpParams(emailOrPhone: 'fallback', otp: '000000'));
  });

  setUp(() {
    mockUsecase = MockVerifyUsecase();
  });

  Widget buildApp() {
    return ProviderScope(
      overrides: [verifyForgotPasswordOtpUseCaseProvider.overrideWithValue(mockUsecase)],
      child: MaterialApp(
        routes: {
          '/forgot-password/change': (context) => const ChangePasswordUsingOtpPage(),
        },
        home: const VerifyForgotPasswordOtpPage(),
      ),
    );
  }

  testWidgets('validation errors shown', (tester) async {
    await tester.pumpWidget(buildApp());

    await tester.tap(find.text('Verify'));
    await tester.pumpAndSettle();

    expect(find.text('Identifier is required'), findsOneWidget);
    expect(find.text('OTP is required'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).first, 'invalid');
    await tester.enterText(find.byType(TextFormField).at(1), 'abc');
    await tester.tap(find.text('Verify'));
    await tester.pumpAndSettle();

    expect(find.text('Enter a valid numeric OTP'), findsOneWidget);
  });

  testWidgets('navigates to change page on success', (tester) async {
    when(() => mockUsecase.call(any())).thenAnswer((_) async => const Either.right(null));

    await tester.pumpWidget(buildApp());

    await tester.enterText(find.byType(TextFormField).first, 'user@example.com');
    await tester.enterText(find.byType(TextFormField).at(1), '123456');
    await tester.tap(find.text('Verify'));
    await tester.pumpAndSettle();

    expect(find.text('Set New Password'), findsOneWidget);
  });

  testWidgets('shows error dialog on failure', (tester) async {
    when(() => mockUsecase.call(any())).thenAnswer((_) async => Either.left(ServerFailure('invalid code')));

    await tester.pumpWidget(buildApp());

    await tester.enterText(find.byType(TextFormField).first, 'user@example.com');
    await tester.enterText(find.byType(TextFormField).at(1), '123456');
    await tester.tap(find.text('Verify'));
    await tester.pumpAndSettle();

    expect(find.text('Verification failed'), findsOneWidget);
    expect(find.text('invalid code'), findsOneWidget);
  });
}
