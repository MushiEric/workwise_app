import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/core/errors/failure.dart';
import 'package:workwise_erp/features/auth/domain/usecases/forgot_password.dart';
import 'package:workwise_erp/features/auth/presentation/providers/auth_providers.dart';
import 'package:workwise_erp/features/auth/presentation/pages/forgot_password_page.dart';

class MockForgotPasswordUsecase extends Mock implements ForgotPassword {}

void main() {
  late MockForgotPasswordUsecase mockUsecase;

  setUpAll(() {
    registerFallbackValue(ForgotPasswordParams(emailOrPhone: 'fallback'));
  });

  setUp(() {
    mockUsecase = MockForgotPasswordUsecase();
  });

  Widget buildTestable() {
    return ProviderScope(
      overrides: [forgotPasswordUseCaseProvider.overrideWithValue(mockUsecase)],
      child: MaterialApp(home: const ForgotPasswordPage()),
    );
  }

  testWidgets('shows validation error for invalid input', (tester) async {
    await tester.pumpWidget(buildTestable());

    final submitBtn = find.text('Send Reset Code');
    expect(submitBtn, findsOneWidget);

    await tester.tap(submitBtn);
    await tester.pumpAndSettle();

    expect(find.text('Email or phone is required'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).first, 'invalid');
    await tester.tap(submitBtn);
    await tester.pumpAndSettle();

    expect(find.text('Enter a valid email or phone'), findsOneWidget);
  });

  testWidgets('shows success dialog when usecase succeeds', (tester) async {
    when(() => mockUsecase.call(any())).thenAnswer((_) async => const Either.right(null));

    await tester.pumpWidget(buildTestable());

    await tester.enterText(find.byType(TextFormField).first, 'user@example.com');
    await tester.tap(find.text('Send Reset Code'));
    await tester.pump();

    // loader dialog appears then success dialog; settle all animations
    await tester.pumpAndSettle();

    expect(find.textContaining('If an account exists'), findsOneWidget);
    expect(find.text('Verify OTP'), findsOneWidget);
  });

  testWidgets('shows error dialog when usecase fails', (tester) async {
    when(() => mockUsecase.call(any())).thenAnswer((_) async => Either.left(ServerFailure('server error')));

    await tester.pumpWidget(buildTestable());

    await tester.enterText(find.byType(TextFormField).first, 'user@example.com');
    await tester.tap(find.text('Send Reset Code'));
    await tester.pumpAndSettle();

    expect(find.text('Request Failed'), findsOneWidget);
    expect(find.text('server error'), findsOneWidget);
  });
}
