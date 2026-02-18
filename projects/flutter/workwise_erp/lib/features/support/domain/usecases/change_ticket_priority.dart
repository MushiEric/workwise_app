import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/core/errors/failure.dart';

import '../repositories/support_repository.dart';

class ChangeTicketPriority {
  final SupportRepository repository;
  ChangeTicketPriority(this.repository);

  Future<Either<Failure, void>> call({required int ticketId, required int priorityId}) async {
    return repository.changeTicketPriority(ticketId: ticketId, priorityId: priorityId);
  }
}
