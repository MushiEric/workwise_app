import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workwise_erp/core/storage/tenant_local_data_source.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('save/read/clear tenant works', () async {
    final ds = TenantLocalDataSource();

    expect(await ds.readTenant(), isNull);

    await ds.saveTenant('https://acme.workwise.africa/api');
    expect(await ds.readTenant(), equals('https://acme.workwise.africa/api'));

    await ds.clearTenant();
    expect(await ds.readTenant(), isNull);
  });
}
