import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/core/errors/failure.dart';

import '../repositories/support_repository.dart';
import '../entities/support_ticket.dart';

class GetSupportTickets {
  final SupportRepository repository;
  GetSupportTickets(this.repository);

  Future<Either<Failure, List<SupportTicket>>> call() async {
    return repository.getTickets();
  }
}
