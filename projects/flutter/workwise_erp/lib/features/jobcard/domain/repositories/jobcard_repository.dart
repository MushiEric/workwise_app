import 'package:workwise_erp/core/errors/either.dart';
import '../entities/jobcard.dart';
import '../entities/jobcard_detail.dart';
import '../entities/jobcard_form_data.dart';
import '../entities/jobcard_status.dart';

abstract class JobcardRepository {
  Future<Either<dynamic, List<Jobcard>>> getJobcards({int page = 1, int perPage = 20, String? status});

  Future<Either<dynamic, JobcardDetail>> getJobcardById(int id);

  Future<Either<dynamic, List<JobcardStatus>>> getSettings();

  // Return general jobcard configuration (may be a map of settings)
  Future<Either<dynamic, Map<String, dynamic>>> getConfig();

  // Delete a jobcard by id
  Future<Either<dynamic, void>> deleteJobcard({required int id});

  // placeholder for status change (implement when endpoint provided)
  Future<Either<dynamic, void>> changeJobcardStatus({required int id, required String status, String? note});

  /// Create a jobcard. Returns created jobcard id on success.
  Future<Either<dynamic, int>> createJobcard({required dynamic params});

  /// Request the server to generate a unique jobcard number.
  Future<Either<dynamic, String>> generateUniqueNumber();

  /// Fetch all dropdown/catalog data required to render the creation form.
  Future<Either<dynamic, JobcardFormData>> getFormData({int? creatorId});

  /// Fetch receivers filtered by [type] (customer | vendor | user | employee).
  Future<Either<dynamic, List<Map<String, dynamic>>>> getReceiversByType(String type);
}

