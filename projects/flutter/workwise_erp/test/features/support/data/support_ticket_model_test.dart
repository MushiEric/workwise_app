import 'package:flutter_test/flutter_test.dart';
import 'package:workwise_erp/features/support/data/models/support_ticket_model.dart';

void main() {
  test('SupportTicketModel maps JSON (minimal) to domain correctly', () {
    final json = {
      'id': 3,
      'subject': 'Test ticket',
      'ticket_code': '030159',
      'priority': {'id': 1, 'priority': 'Low', 'color': '#00FF00'},
      'statuses': {'id': 1, 'status': 'Active', 'color': '#45d411'},
      'customer_name': {'id': 10, 'name': 'KISSIMA', 'email': 'kissima@gmail.com', 'phone': '0613334247'},
      'replies': []
    };

    final model = SupportTicketModel.fromJson(json);
    final domain = model.toDomain();

    expect(domain.id, 3);
    expect(domain.subject, 'Test ticket');
    expect(domain.priority?.priority, 'Low');
    expect(domain.status?.status, 'Active');
    expect(domain.customer?.name, 'KISSIMA');
  });
}
