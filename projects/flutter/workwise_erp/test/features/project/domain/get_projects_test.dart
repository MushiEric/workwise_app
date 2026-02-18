import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/features/project/domain/entities/project.dart';
import 'package:workwise_erp/features/project/domain/repositories/project_repository.dart';
import 'package:workwise_erp/features/project/domain/usecases/get_projects.dart';

class MockRepo extends Mock implements ProjectRepository {}

void main() {
  late MockRepo mockRepo;
  late GetProjects usecase;

  setUp(() {
    mockRepo = MockRepo();
    usecase = GetProjects(mockRepo);
  });

  test('forwards projects from repository', () async {
    final projects = [Project(id: 1, name: 'P1')];
    when(() => mockRepo.getProjects()).thenAnswer((_) async => Either.right(projects));

    final res = await usecase.call();

    expect(res.isRight, true);
    res.fold((l) => fail('expected right'), (r) => expect(r, projects));
    verify(() => mockRepo.getProjects()).called(1);
  });
}
