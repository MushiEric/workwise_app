import 'package:workwise_erp/core/errors/either.dart';
import '../repositories/jobcard_repository.dart';

/// Fetches receiver names filtered by [type].
/// Valid types: customer | vendor | user | employee
class GetReceiversByType {
  final JobcardRepository repository;
  GetReceiversByType(this.repository);

  Future<Either<dynamic, List<Map<String, dynamic>>>> call(String type) {
    return repository.getReceiversByType(type);
  }
}
