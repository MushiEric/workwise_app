enum AppEnvironment { dev, staging, prod }

class EnvConfig {
  final AppEnvironment env;
  final String baseUrl;
  final Duration connectTimeout;
  final Duration receiveTimeout;
  final Duration sendTimeout;
  final int maxRetries;
  final Duration retryBaseDelay;
  final int cacheTtlSeconds;
  final bool enableLogging;

  const EnvConfig._({
    required this.env,
    required this.baseUrl,
    required this.connectTimeout,
    required this.receiveTimeout,
    required this.sendTimeout,
    required this.maxRetries,
    required this.retryBaseDelay,
    required this.cacheTtlSeconds,
    required this.enableLogging,
  });

  static AppEnvironment _envFromString(String s) {
    switch (s.toLowerCase()) {
      case 'dev':
      case 'development':
        return AppEnvironment.dev;
      case 'prod':
      case 'production':
        return AppEnvironment.prod;
      default:
        return AppEnvironment.staging;
    }
  }

  static final AppEnvironment currentEnv = _envFromString(
    String.fromEnvironment(
      'RUNTIME_ENV',
      defaultValue: String.fromEnvironment('APP_ENV', defaultValue: 'prod'),
    ),
  );

  static const String _prodSentryDsn =
      'https://6f13134346dd0d35c1727ec20d725d8c@o4510437339299840.ingest.us.sentry.io/4510437340479488';
  static const String _stagingSentryDsn = '';

  static String get sentryDsn {
    const override = String.fromEnvironment('SENTRY_DSN');
    if (override.isNotEmpty) return override;
    return switch (currentEnv) {
      AppEnvironment.prod => _prodSentryDsn,
      AppEnvironment.staging => _stagingSentryDsn,
      AppEnvironment.dev => '',
    };
  }

  static AppEnvironment? _runtimeOverride;

  static void init(AppEnvironment env) => _runtimeOverride = env;

  /// Clear any runtime override and fall back to compile-time `APP_ENV`.
  static void resetOverride() => _runtimeOverride = null;

  /// Parse a string into an [AppEnvironment] (public wrapper for tests/usage).
  static AppEnvironment parseEnv(String s) => _envFromString(s);

  static final String _devApiHost = String.fromEnvironment(
    '192.168.1.120',
    defaultValue: '192.168.1.120',
  );

  static EnvConfig get current {
    final activeEnv = _runtimeOverride ?? currentEnv;

    switch (activeEnv) {
      case AppEnvironment.dev:
        return EnvConfig._(
          env: AppEnvironment.dev,
          baseUrl: 'http://$_devApiHost:8000/api',
          connectTimeout: Duration(seconds: 15),
          receiveTimeout: Duration(seconds: 15),
          sendTimeout: Duration(seconds: 15),
          maxRetries: 1,
          retryBaseDelay: Duration(milliseconds: 300),
          cacheTtlSeconds: 60,
          enableLogging: true,
        );
      case AppEnvironment.prod:
        return const EnvConfig._(
          env: AppEnvironment.prod,
          baseUrl: 'https://app.workwise.africa/api',
          connectTimeout: Duration(seconds: 30),
          receiveTimeout: Duration(seconds: 30),
          sendTimeout: Duration(seconds: 30),
          maxRetries: 3,
          retryBaseDelay: Duration(milliseconds: 500),
          cacheTtlSeconds: 3600,
          enableLogging: false,
        );
      case AppEnvironment.staging:
        return const EnvConfig._(
          env: AppEnvironment.staging,
          baseUrl: 'https://staging.workwise.africa/api',
          connectTimeout: Duration(seconds: 30),
          receiveTimeout: Duration(seconds: 30),
          sendTimeout: Duration(seconds: 30),
          maxRetries: 2,
          retryBaseDelay: Duration(milliseconds: 400),
          cacheTtlSeconds: 300,
          enableLogging: true,
        );
    }

    // The switch above is exhaustive, but Dart requires a return after it
    // because the analyzer can't guarantee `activeEnv` corresponds to a
    // known enum value. Throwing here prevents null from being returned.
    // ignore: dead_code
    throw StateError('Unsupported environment: $activeEnv');
  }
}
