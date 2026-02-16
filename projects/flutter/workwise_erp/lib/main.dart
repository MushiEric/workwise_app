import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';

import 'core/themes/app_colors.dart';
import 'core/provider/locale_provider.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/forgot_password_page.dart';
import 'features/auth/presentation/pages/verify_forgot_password_otp_page.dart';
import 'features/auth/presentation/pages/change_password_using_otp_page.dart';
import 'features/auth/presentation/pages/profile_page.dart';
import 'features/project/presentation/pages/projects_page.dart';
import 'features/project/presentation/pages/project_detail_page.dart';
import 'features/index/presentation/pages/index_page.dart';
import 'features/sales/presentation/pages/sales_page.dart';
import 'features/logistic/presentation/pages/logistic_page.dart';
import 'features/logistic/presentation/pages/operators_page.dart';
import 'features/logistic/presentation/pages/operator_detail_page.dart';
import 'features/jobcard/presentation/pages/jobcard_list_page.dart';
import 'features/jobcard/presentation/pages/jobcard_create_page.dart';
import 'features/jobcard/presentation/pages/jobcard_detail_page.dart';
import 'features/jobcard/presentation/pages/jobcard_settings_page.dart';
import 'features/assets/presentation/pages/assets_page.dart';
import 'features/assets/presentation/pages/asset_detail_page.dart';
import 'features/inventory/presentation/pages/inventory_page.dart';
import 'features/project/presentation/pages/project_page.dart';
import 'features/documents/presentation/pages/documents_page.dart';
import 'features/support/presentation/pages/support_list_page.dart';
import 'features/notification/presentation/pages/notifications_page.dart';
import 'features/pfi/presentation/pages/pfi_page.dart';
import 'features/hr/presentation/pages/hr_page.dart';
import '../../../core/constants/app_constant.dart';

import 'package:sentry_flutter/sentry_flutter.dart';
import 'core/config/environment.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // OPTIONAL RUNTIME OVERRIDE (useful during local development):
  // Uncomment the following line to force a specific environment without
  // rebuilding with --dart-define=APP_ENV=...
  // EnvConfig.init(AppEnvironment.dev);

  // You can also override using a build-time dart-define `RUNTIME_ENV` like:
  // flutter run --dart-define=RUNTIME_ENV=dev
  const _runtimeEnv = String.fromEnvironment('RUNTIME_ENV', defaultValue: '');
  if (_runtimeEnv.isNotEmpty) {
    EnvConfig.init(EnvConfig.parseEnv(_runtimeEnv));
  }

  // Initialize Sentry only when DSN is provided via --dart-define
  final sentryDsn = EnvConfig.sentryDsn;
  if (sentryDsn.isNotEmpty) {
    await SentryFlutter.init(
      (options) {
        options.dsn = sentryDsn;
        options.environment = EnvConfig.current.env.name;
        options.tracesSampleRate = 0.05; // low default; increase if needed
        options.release = '${AppConstant.appName}@${AppConstant.appVersion}';
      },
      appRunner: () => runApp(const ProviderScope(child: MyApp())),
    );
  } else {
    runApp(const ProviderScope(child: MyApp()));
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

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

    return MaterialApp(
      title: AppConstant.appName,
      debugShowCheckedModeBanner: false,
      locale: Locale(localeCode),
      localizationsDelegates: const [
        // Provides default Flutter localizations for widgets (dates, etc.)
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('sw'), Locale('fr')],
      theme: ThemeData(
        primaryColor: AppColors.primary,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        appBarTheme: AppBarTheme(backgroundColor: AppColors.primary),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
        ),
      ),
      routes: {
        '/': (context) => const LoginPage(),
        '/forgot-password': (context) => const ForgotPasswordPage(),
        '/forgot-password/verify': (context) => const VerifyForgotPasswordOtpPage(),
        '/forgot-password/change': (context) => const ChangePasswordUsingOtpPage(),
        '/index': (context) => const IndexPage(),
        '/profile': (context) => const ProfilePage(),
        '/sales': (context) => const SalesPage(),
        '/pfi': (context) => const PfiPage(),
        '/logistic': (context) => const LogisticPage(),
        '/logistic/operators': (context) => const OperatorsPage(),
        '/logistic/operators/detail': (context) => const OperatorDetailPage(),
        '/assets': (context) => const AssetsPage(),
        '/assets/detail': (context) => const AssetDetailPage(),
        '/inventory': (context) => const InventoryPage(),
        '/project': (context) => const ProjectPage(),
        '/projects': (context) => const ProjectsPage(),
        '/projects/detail': (context) => const ProjectDetailPage(),
        '/jobcards': (context) => const JobcardListPage(),
        '/jobcards/create': (context) => const JobcardCreatePage(),
        '/jobcards/detail': (context) => const JobcardDetailPage(),
        '/jobcards/settings': (context) => const JobcardSettingsPage(),
        '/documents': (context) =>  const DocumentPage(),
        '/support': (context) => SupportListPage(),
        '/notifications': (context) => const NotificationsPage(),
        '/hr': (context) => const HRPage(),
      },
      initialRoute: '/',
    );
  }
}
