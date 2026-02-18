import 'package:flutter_test/flutter_test.dart';
import 'package:workwise_erp/features/support/presentation/widgets/dropdown_helpers.dart';

void main() {
  test('uniqueOptions preserves order and removes duplicates', () {
    final input = ['Open', 'In Progress', 'Open', 'Resolved', 'In Progress'];
    final out = uniqueOptions(input);

    expect(out, ['Open', 'In Progress', 'Resolved']);
  });

  test('uniqueOptions handles empty lists', () {
    expect(uniqueOptions([]), isEmpty);
  });
}
