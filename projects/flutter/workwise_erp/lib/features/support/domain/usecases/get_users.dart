import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/core/errors/failure.dart';
import '../repositories/support_repository.dart';
import '../../../auth/domain/entities/user.dart';

class GetUsers {
  final SupportRepository repository;

  GetUsers(this.repository);

  Future<Either<Failure, List<User>>> call() async {
    return repository.getUsers();
  }
}
