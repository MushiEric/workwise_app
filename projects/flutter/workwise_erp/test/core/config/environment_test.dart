import 'package:flutter_test/flutter_test.dart';
import 'package:workwise_erp/core/config/environment.dart';

void main() {
  setUp(() {
    EnvConfig.resetOverride();
  });

  test('runtime init overrides current environment', () {
    // default (when running tests) is staging per EnvConfig implementation
    expect(EnvConfig.current.env, isNot(AppEnvironment.dev));

    EnvConfig.init(AppEnvironment.dev);
    expect(EnvConfig.current.env, AppEnvironment.dev);
    expect(EnvConfig.current.baseUrl, contains('10.86.58.81'));

    EnvConfig.resetOverride();
    expect(EnvConfig.current.env, isNot(AppEnvironment.dev));
  });

  test('parseEnv accepts common strings', () {
    expect(EnvConfig.parseEnv('dev'), AppEnvironment.dev);
    expect(EnvConfig.parseEnv('production'), AppEnvironment.prod);
    expect(EnvConfig.parseEnv('staging'), AppEnvironment.staging);
  });
}
