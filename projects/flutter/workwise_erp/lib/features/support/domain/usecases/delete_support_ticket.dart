import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/core/errors/failure.dart';

import '../repositories/support_repository.dart';

class DeleteSupportTicket {
  final SupportRepository repository;
  DeleteSupportTicket(this.repository);

  Future<Either<Failure, void>> call({required int ticketId}) async {
    return repository.deleteTicket(ticketId: ticketId);
  }
}
