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

    final localeNotifier = LocaleNotifier();
    localeNotifier.state = 'en';

    final container = ProviderContainer(
      overrides: [
        // use english locale initially
        appLocaleProvider.overrideWith((ref) => localeNotifier),
        // supply an authenticated user so greeting picks up the name
        currentUserProvider.overrideWith(
          (ref) => Future.value(const Either.right(user)),
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

    // Greeting line should include the username (and is localized by the UI).
    expect(find.textContaining('Test'), findsWidgets);

    // welcome text should contain the english app name
    expect(find.textContaining('Welcome to Workwise'), findsOneWidget);

    // switch language to Swahili and rebuild via provider
    await container.read(appLocaleProvider.notifier).setLocale('sw');
    await tester.pumpAndSettle();

    // after switch the welcome text should update and use Workwise
    expect(find.textContaining('Workwise'), findsWidgets);
    expect(find.textContaining('Karibu'), findsWidgets);
    // greeting line should now be in Swahili (contains "Habari" or "Usiku")
    expect(find.textContaining('Habari'), findsWidgets);
  });
}
