import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import 'l10n/app_localizations.dart';
import 'core/extensions/l10n_extension.dart';

import 'core/themes/app_colors.dart';
import 'core/themes/app_typography.dart';
import 'core/provider/locale_provider.dart';
import 'core/provider/navigator_key_provider.dart';
import 'core/provider/theme_provider.dart';
import 'core/routes/app_router.dart';
import '../../../core/constants/app_constant.dart';

import 'package:sentry_flutter/sentry_flutter.dart';
import 'core/config/environment.dart';
import 'core/models/tenant.dart';
import 'core/storage/tenant_local_data_source.dart';
import 'core/provider/tenant_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // OPTIONAL RUNTIME OVERRIDE (useful during local development):
  // Uncomment the following line to force a specific environment without
  // rebuilding with --dart-define=APP_ENV=...
  // EnvConfig.init(AppEnvironment.dev);

  // You can also override using a build-time dart-define `RUNTIME_ENV` like:
  // flutter run --dart-define=RUNTIME_ENV=dev
  const runtimeEnv = String.fromEnvironment(
    'RUNTIME_ENV',
    defaultValue: 'staging',
  );
  if (runtimeEnv.isNotEmpty) {
    EnvConfig.init(EnvConfig.parseEnv(runtimeEnv));
  }

  // Initialize Sentry only when DSN is provided via --dart-define
  final sentryDsn = EnvConfig.sentryDsn;

  // Load persisted tenant (if any) so Workwise can decide initial route.
  final tenantStorage = TenantLocalDataSource();
  final persistedTenant = await tenantStorage.readTenant();
  final tenantOverride = persistedTenant == null
      ? null
      : Tenant(persistedTenant);

  final providerOverrides = <Override>[];
  if (tenantOverride != null) {
    // override the provider value (StateProvider<Tenant?> expects Tenant?)
    providerOverrides.add(tenantProvider.overrideWith((ref) => tenantOverride));
  }

  // If running in a development environment and no tenant has been stored,
  // prepopulate the provider with the dev base URL. This allows developers to
  // simply launch the app with `--dart-define=RUNTIME_ENV=dev` and skip the
  // workspace entry screen entirely.
  if (tenantOverride == null && EnvConfig.current.env == AppEnvironment.dev) {
    providerOverrides.add(
      tenantProvider.overrideWith((ref) => Tenant(EnvConfig.current.baseUrl)),
    );
  }

  if (sentryDsn.isNotEmpty) {
    await SentryFlutter.init(
      (options) {
        options.dsn = sentryDsn;
        options.environment = EnvConfig.current.env.name;
        options.tracesSampleRate = 0.05; // low default; increase if needed
        options.release = '${AppConstant.appName}@${AppConstant.appVersion}';
      },
      appRunner: () => runApp(
        ProviderScope(overrides: providerOverrides, child: const Workwise()),
      ),
    );
  } else {
    runApp(
      ProviderScope(overrides: providerOverrides, child: const Workwise()),
    );
  }
}

class Workwise extends ConsumerWidget {
  const Workwise({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localeCode = ref.watch(appLocaleProvider);

    // set default for intl (used by DateFormat and other Intl APIs)
    // ignore: avoid_slow_async_io
    // Note: Intl.defaultLocale is read synchronously elsewhere; setting it here keeps formats consistent.
    // We set it every build to keep it in sync with the provider.
    // (No external localization files are required for the language switch to persist.)
    // ignore: prefer_void_to_null
    Intl.defaultLocale = localeCode;

    return ScreenUtilInit(
      // Design reference: iPhone 14 Pro (390 × 844 logical pixels)
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      // supply a dummy child so internal null-checks cannot fail
      child: const SizedBox.shrink(),
      builder: (context, child) {
        // child will be null when not provided, so guard but we don't use it
        final themeMode = ref.watch(themeModeProvider);

        final lightTheme = ThemeData(
          primaryColor: AppColors.primary,
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
          appBarTheme: AppBarTheme(backgroundColor: AppColors.primary),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          ),
          scaffoldBackgroundColor: AppColors.greyFill,
          // Centralized typography (Inter default, Figtree for titles/numbers)
          textTheme: AppTypography.textTheme,
          // Standardize icon sizing across the app
          iconTheme: const IconThemeData(size: 20),
        );

        final darkTheme = ThemeData.dark().copyWith(
          primaryColor: AppColors.primary,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            brightness: Brightness.dark,
          ),
          scaffoldBackgroundColor: const Color(0xFF0A0E21),
          cardColor: const Color(0xFF151A2E),
          appBarTheme: AppBarTheme(
            backgroundColor: const Color(0xFF0A0E21),
            foregroundColor: Colors.white,
            elevation: 0,
            systemOverlayStyle: SystemUiOverlayStyle.light,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          ),
          textTheme: AppTypography.textTheme.apply(
            bodyColor: Colors.white,
            displayColor: Colors.white,
          ),
          iconTheme: const IconThemeData(size: 20, color: Colors.white),
        );

        return MaterialApp(
          navigatorKey: ref.watch(navigatorKeyProvider),
          scaffoldMessengerKey: ref.watch(scaffoldMessengerKeyProvider),
          // title must not call context.l10n here — localizations aren't ready
          // until MaterialApp itself is built. onGenerateTitle receives a
          // properly-localized context and is the correct place for this.
          onGenerateTitle: (ctx) => ctx.l10n.appName,
          debugShowCheckedModeBanner: false,
          locale: Locale(localeCode),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('sw'),
            Locale('fr'),
            Locale('hi'),
          ],
          themeMode: themeMode,
          theme: lightTheme,
          darkTheme: darkTheme,
          routes: AppRouter.routes,
          initialRoute: '/splash',
        ); // end MaterialApp
      }, // end builder
    );
  }
}
