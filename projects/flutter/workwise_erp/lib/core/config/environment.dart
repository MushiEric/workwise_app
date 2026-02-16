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

  const EnvConfig._({
    required this.env,
    required this.baseUrl,
    required this.connectTimeout,
    required this.receiveTimeout,
    required this.sendTimeout,
    required this.maxRetries,
    required this.retryBaseDelay,
    required this.cacheTtlSeconds,
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

  /// Read at compile-time using `--dart-define=APP_ENV=prod` (default: staging)
  static final AppEnvironment currentEnv = _envFromString(const String.fromEnvironment('APP_ENV', defaultValue: 'staging'));

  /// Optional Sentry DSN passed at build-time: --dart-define=SENTRY_DSN=\"...\"
  static final String sentryDsn = const String.fromEnvironment('SENTRY_DSN', defaultValue: '');

  // --- Runtime override support -------------------------------------------------
  // Call `EnvConfig.init(AppEnvironment.dev)` early in `main()` to override the
  // compile-time environment for local/testing runs. `resetOverride()` clears
  // the runtime override.
  static AppEnvironment? _runtimeOverride;

  /// Programmatically set the active environment at runtime. Useful for local
  /// testing where you want to switch endpoints without rebuilding with
  /// `--dart-define`.
  static void init(AppEnvironment env) => _runtimeOverride = env;

  /// Clear any runtime override and fall back to compile-time `APP_ENV`.
  static void resetOverride() => _runtimeOverride = null;

  /// Parse a string into an [AppEnvironment] (public wrapper for tests/usage).
  static AppEnvironment parseEnv(String s) => _envFromString(s);

  static EnvConfig get current {
    final activeEnv = _runtimeOverride ?? currentEnv;

    switch (activeEnv) {
      case AppEnvironment.dev:
        return const EnvConfig._(
          env: AppEnvironment.dev,
          baseUrl: 'http://10.86.58.81:8000/api',
          connectTimeout: Duration(seconds: 15),
          receiveTimeout: Duration(seconds: 15),
          sendTimeout: Duration(seconds: 15),
          maxRetries: 1,
          retryBaseDelay: Duration(milliseconds: 300),
          cacheTtlSeconds: 60,
        );
      case AppEnvironment.prod:
        return const EnvConfig._(
          env: AppEnvironment.prod,
          baseUrl: 'https://api.workwise.africa/api',
          connectTimeout: Duration(seconds: 30),
          receiveTimeout: Duration(seconds: 30),
          sendTimeout: Duration(seconds: 30),
          maxRetries: 3,
          retryBaseDelay: Duration(milliseconds: 500),
          cacheTtlSeconds: 3600,
        );
      case AppEnvironment.staging:
      default:
        return const EnvConfig._(
          env: AppEnvironment.staging,
          baseUrl: 'https://staging.workwise.africa/api',
          connectTimeout: Duration(seconds: 30),
          receiveTimeout: Duration(seconds: 30),
          sendTimeout: Duration(seconds: 30),
          maxRetries: 2,
          retryBaseDelay: Duration(milliseconds: 400),
          cacheTtlSeconds: 300,
        );
    }
  }
}
