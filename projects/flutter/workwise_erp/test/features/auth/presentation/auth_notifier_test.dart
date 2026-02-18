import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/features/auth/domain/entities/user.dart';
import 'package:workwise_erp/features/auth/domain/repositories/auth_repository.dart';
import 'package:workwise_erp/features/auth/domain/usecases/login.dart';
import 'package:workwise_erp/features/auth/domain/usecases/get_current_user.dart';
import 'package:workwise_erp/features/auth/presentation/notifier/auth_notifier.dart';

class MockRepo extends Mock implements AuthRepository {}

void main() {
  late MockRepo mockRepo;
  late AuthNotifier notifier;

  setUp(() {
    mockRepo = MockRepo();
    notifier = AuthNotifier(loginUseCase: Login(mockRepo), getCurrentUserUseCase: GetCurrentUser(mockRepo));
  });

  test('login updates state to authenticated on success', () async {
    final user = User(id: 1, name: 'Test');
    when(() => mockRepo.login(email: any(named: 'email'), password: any(named: 'password')))
        .thenAnswer((_) async => Either.right(user));

    await notifier.login(email: 'a@b.com', password: 'pass');

    notifier.state.when(
      initial: () => fail('expected authenticated'),
      loading: (_) => fail('expected authenticated'),
      authenticated: (u) => expect(u, user),
      error: (m) => fail('expected authenticated'),
    );
  });

  test('login shows server message on failure', () async {
    when(() => mockRepo.login(email: any(named: 'email'), password: any(named: 'password')))
        .thenAnswer((_) async => Either.left(ServerFailure('Wrong credentials')));

    await notifier.login(email: 'bad', password: 'bad');

    notifier.state.maybeWhen(
      error: (m) => expect(m, 'Wrong credentials'),
      orElse: () => fail('expected error state'),
    );
  });
}
