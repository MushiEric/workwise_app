import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/core/errors/failure.dart';

import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class UpdateProfile {
  final AuthRepository repository;
  UpdateProfile(this.repository);

  Future<Either<Failure, User>> call(Map<String, dynamic> payload) async {
    return repository.updateProfile(payload);
  }
}
