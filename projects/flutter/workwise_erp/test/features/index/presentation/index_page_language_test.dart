import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:workwise_erp/features/index/presentation/pages/index_page.dart';
import 'package:workwise_erp/l10n/app_localizations.dart';
import 'package:workwise_erp/core/provider/locale_provider.dart';
import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/features/auth/domain/entities/user.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:workwise_erp/features/auth/presentation/providers/auth_providers.dart';

void main() {
  testWidgets('IndexPage uses localized greetings and app name', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});

    const user = User(id: 1, name: 'Test User', lang: 'en');

    final container = ProviderContainer(
      overrides: [
        // use english locale initially
        appLocaleProvider.overrideWithValue('en'),
        // supply an authenticated user so greeting picks up the name
        currentUserProvider.overrideWithValue(
          FutureProvider((ref) async => const Either.right(user)),
        ),
      ],
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [Locale('en'), Locale('sw'), Locale('fr')],
          home: IndexPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // compute greeting using same algorithm as UI so we can assert exact text
    final hour = DateTime.now().toLocal().hour;
    final engGreeting = hour < 5
        ? 'Good Night'
        : (hour < 12
              ? 'Good Morning'
              : (hour < 17
                    ? 'Good Afternoon'
                    : (hour < 21 ? 'Good Evening' : 'Good Night')));

    // greeting line should include the computed English phrase and username
    expect(find.text('$engGreeting, Test'), findsOneWidget);

    // welcome text should contain the english app name
    expect(find.textContaining('Welcome to Workwise'), findsOneWidget);

    // switch language to Swahili and rebuild via provider
    await container.read(appLocaleProvider.notifier).setLocale('sw');
    await tester.pumpAndSettle();

    // after switch the welcome text should update and use Moduli
    expect(find.textContaining('Moduli'), findsWidgets);
    expect(find.textContaining('Karibu'), findsWidgets);
    // greeting line should now be in Swahili (contains "Habari" or "Usiku")
    expect(find.textContaining('Habari'), findsWidgets);
  });
}
