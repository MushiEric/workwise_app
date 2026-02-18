import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:workwise_erp/features/project/presentation/notifier/project_tasks_notifier.dart';
import 'package:workwise_erp/features/project/domain/usecases/get_project_tasks.dart';
import 'package:workwise_erp/features/project/presentation/state/project_tasks_state.dart';
import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/core/errors/failure.dart';

class MockGetProjectTasks extends Mock implements GetProjectTasks {}

void main() {
  late MockGetProjectTasks mockGetProjectTasks;
  late ProjectTasksNotifier notifier;

  setUp(() {
    mockGetProjectTasks = MockGetProjectTasks();
    notifier = ProjectTasksNotifier(getProjectTasks: mockGetProjectTasks);
  });

  test('loadTasks sets error state when usecase throws', () async {
    when(() => mockGetProjectTasks.call(any())).thenThrow(Exception('boom'));

    await notifier.loadTasks(1);

    expect(notifier.state, isA<ProjectTasksState>());
    notifier.state.maybeWhen(
      error: (m) => expect(m, contains('Failed to load tasks')),
      orElse: () => fail('expected error state'),
    );
  });

  test('loadTasks sets error state when usecase returns left', () async {
    when(() => mockGetProjectTasks.call(any())).thenAnswer((_) async => Either.left(ServerFailure('no tasks')));

    await notifier.loadTasks(2);

    notifier.state.maybeWhen(
      error: (m) => expect(m, 'no tasks'),
      orElse: () => fail('expected error state'),
    );
  });
}
