import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/core/errors/failure.dart';

import '../repositories/support_repository.dart';
import '../entities/support_create_params.dart';

class CreateSupportTicket {
  final SupportRepository repository;
  CreateSupportTicket(this.repository);

  Future<Either<Failure, void>> call(SupportCreateParams params) async {
    return repository.createTicket(params: params);
  }
}
