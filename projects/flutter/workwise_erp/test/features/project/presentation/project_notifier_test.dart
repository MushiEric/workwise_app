import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:workwise_erp/features/project/presentation/notifier/project_notifier.dart';
import 'package:workwise_erp/features/project/domain/usecases/get_projects.dart';
import 'package:workwise_erp/features/project/domain/usecases/get_project_by_id.dart';
import 'package:workwise_erp/features/project/presentation/state/project_state.dart';
import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/core/errors/failure.dart';

class MockGetProjects extends Mock implements GetProjects {}
class MockGetProjectById extends Mock implements GetProjectById {}

void main() {
  late MockGetProjects mockGetProjects;
  late MockGetProjectById mockGetProjectById;
  late ProjectNotifier notifier;

  setUp(() {
    mockGetProjects = MockGetProjects();
    mockGetProjectById = MockGetProjectById();
    when(() => mockGetProjects.call()).thenAnswer((_) async => const Either.right([]));
    notifier = ProjectNotifier(getProjects: mockGetProjects, getProjectById: mockGetProjectById);
  });

  test('loadProjectDetail sets error state when usecase throws', () async {
    when(() => mockGetProjectById.call(any())).thenThrow(Exception('boom'));

    await notifier.loadProjectDetail(1);

    expect(notifier.state, isA<ProjectState>());
    notifier.state.maybeWhen(
      error: (m) => expect(m, contains('Failed to load project')),
      orElse: () => fail('expected error state'),
    );
  });

  test('loadProjectDetail sets error state when usecase returns left', () async {
    when(() => mockGetProjectById.call(any())).thenAnswer((_) async => Either.left(ServerFailure('not found')));

    await notifier.loadProjectDetail(2);

    notifier.state.maybeWhen(
      error: (m) => expect(m, 'not found'),
      orElse: () => fail('expected error state'),
    );
  });
}
