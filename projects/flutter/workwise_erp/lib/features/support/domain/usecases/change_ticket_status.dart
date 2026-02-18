import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/core/errors/failure.dart';

import '../repositories/support_repository.dart';

class ChangeTicketStatus {
  final SupportRepository repository;
  ChangeTicketStatus(this.repository);

  Future<Either<Failure, void>> call({required int ticketId, required int statusId}) async {
    return repository.changeTicketStatus(ticketId: ticketId, statusId: statusId);
  }
}
