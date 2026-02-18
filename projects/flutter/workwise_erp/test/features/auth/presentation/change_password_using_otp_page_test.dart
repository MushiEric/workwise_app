import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/core/errors/failure.dart';
import 'package:workwise_erp/features/auth/domain/usecases/change_password_using_otp.dart';
import 'package:workwise_erp/features/auth/presentation/providers/auth_providers.dart';
import 'package:workwise_erp/features/auth/presentation/pages/change_password_using_otp_page.dart';

class MockChangeUsecase extends Mock implements ChangePasswordUsingOtp {}

void main() {
  late MockChangeUsecase mockUsecase;

  setUpAll(() {
    registerFallbackValue(ChangePasswordUsingOtpParams(emailOrPhone: 'f', otp: '0', newPassword: 'p'));
  });

  setUp(() {
    mockUsecase = MockChangeUsecase();
  });

  Widget _buildApp() {
    return ProviderScope(
      overrides: [changePasswordUsingOtpUseCaseProvider.overrideWithValue(mockUsecase)],
      child: MaterialApp(
        routes: {
          '/forgot-password/change': (context) => const ChangePasswordUsingOtpPage(),
        },
        home: Builder(builder: (context) {
          return Center(
            child: ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/forgot-password/change', arguments: {'identifier': 'user@example.com', 'otp': '123456'}),
              child: const Text('open'),
            ),
          );
        }),
      ),
    );
  }

  testWidgets('validation and mismatch checks', (tester) async {
    await tester.pumpWidget(_buildApp());
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Set password'));
    await tester.pumpAndSettle();

    expect(find.text('Password is required'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).first, 'short');
    await tester.enterText(find.byType(TextFormField).at(1), 'short');
    await tester.tap(find.text('Set password'));
    await tester.pumpAndSettle();

    expect(find.text('Password must be at least 6 characters'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).first, 'longenough');
    await tester.enterText(find.byType(TextFormField).at(1), 'different');
    await tester.tap(find.text('Set password'));
    await tester.pumpAndSettle();

    expect(find.text('Passwords do not match'), findsOneWidget);
  });

  testWidgets('shows success dialog on success', (tester) async {
    when(() => mockUsecase.call(any())).thenAnswer((_) async => const Either.right(null));

    await tester.pumpWidget(_buildApp());
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).first, 'longenough');
    await tester.enterText(find.byType(TextFormField).at(1), 'longenough');
    await tester.tap(find.text('Set password'));
    await tester.pumpAndSettle();

    expect(find.text('Password changed'), findsOneWidget);
  });

  testWidgets('shows error dialog on failure', (tester) async {
    when(() => mockUsecase.call(any())).thenAnswer((_) async => Either.left(ServerFailure('expired')));

    await tester.pumpWidget(_buildApp());
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).first, 'longenough');
    await tester.enterText(find.byType(TextFormField).at(1), 'longenough');
    await tester.tap(find.text('Set password'));
    await tester.pumpAndSettle();

    expect(find.text('Reset failed'), findsOneWidget);
    expect(find.text('expired'), findsOneWidget);
  });
}
