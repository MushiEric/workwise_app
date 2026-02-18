import 'package:flutter_test/flutter_test.dart';
import 'package:workwise_erp/features/jobcard/data/models/jobcard_model.dart';

void main() {
  test('JobcardModel.fromJson parses essential fields', () {
    final json = {
      'id': 29,
      'jobcard_number': 'JB-2025/228217',
      'status': '2',
      'service': 'NEEDING BRAKES 7',
      'reported_date': '2025-11-27 10:22:08',
      'grand_total': '0.00',
      'items': [1, 2],
      'status_row': {'id': 2, 'name': 'In progress'}
    };

    final model = JobcardModel.fromJson(json);
    expect(model.id, 29);
    expect(model.jobcardNumber, 'JB-2025/228217');
    expect(model.status, '2');
    expect(model.service, 'NEEDING BRAKES 7');
    expect(model.itemsCount, 2);
    expect(model.statusRow?['name'], 'In progress');
  });
}
