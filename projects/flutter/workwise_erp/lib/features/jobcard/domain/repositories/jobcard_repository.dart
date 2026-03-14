import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/core/models/paginated_response.dart';
import '../../domain/entities/jobcard.dart';
import '../../domain/entities/jobcard_detail.dart';
import '../../domain/entities/jobcard_form_data.dart';
import '../../domain/entities/jobcard_status.dart';

abstract class JobcardRepository {
  Future<Either<dynamic, PaginatedResponse<Jobcard>>> getJobcards({
    int page = 1,
    int perPage = 50,
    String? status,
    bool force = false,
  });

  Future<Either<dynamic, JobcardDetail>> getJobcardById(int id);

  Future<Either<dynamic, List<JobcardStatus>>> getSettings();

  // Return general jobcard configuration (may be a map of settings)
  Future<Either<dynamic, Map<String, dynamic>>> getConfig();

  // Delete a jobcard by id
  Future<Either<dynamic, void>> deleteJobcard({required int id});

  // placeholder for status change (implement when endpoint provided)
  Future<Either<dynamic, void>> changeJobcardStatus({
    required int id,
    required String status,
    String? note,
  });

  /// Create a jobcard. Returns created jobcard id on success.
  Future<Either<dynamic, int>> createJobcard({required dynamic params});

  /// Request the server to generate a unique jobcard number.
  Future<Either<dynamic, String>> generateUniqueNumber();

  /// Fetch all dropdown/catalog data required to render the creation form.
  Future<Either<dynamic, JobcardFormData>> getFormData({int? creatorId});

  /// Fetch receivers filtered by [type] (customer | vendor | user | employee).
  Future<Either<dynamic, List<Map<String, dynamic>>>> getReceiversByType(
    String type,
  );

  /// Fetch dashboard statistics: list of statuses with their totals.
  Future<Either<dynamic, List<Map<String, dynamic>>>> getDashboardData();

  /// Check if the current user is eligible to approve a jobcard.
  Future<Either<dynamic, Map<String, dynamic>>> checkApprovalEligibility(
    int jobcardId,
  );

  /// Approve a jobcard.
  Future<Either<dynamic, void>> approveJobcard(int jobcardId);

  /// Reject a jobcard with an optional reason.
  Future<Either<dynamic, void>> rejectJobcard(int jobcardId, {String? reason});
}
