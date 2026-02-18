import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:workwise_erp/features/jobcard/domain/entities/jobcard_create_params.dart';

void main() {
  group('JobcardCreateParams', () {
    test('toMap includes attachment keys when provided', () {
      final params = JobcardCreateParams(
        jobcardNumber: 'JC-001',
        subject: 'Test',
        itemAttachmentPaths: ['/.tmp/file1.png'],
        serviceAttachmentPaths: ['/tmp/file2.pdf'],
      );

      final map = params.toMap();
      expect(map['item_attachemt'], isA<List<String>>());
      expect(map['service_attachemt'], isA<List<String>>());
      expect((map['item_attachemt'] as List).first, '/.tmp/file1.png');
    });

    test('toJson serializes to valid JSON', () {
      final params = JobcardCreateParams(
        jobcardNumber: 'JC-002',
        subject: 'Serialize',
      );
      final jsonStr = json.encode(params.toJson());
      expect(jsonStr, contains('JC-002'));
    });
  });
}
