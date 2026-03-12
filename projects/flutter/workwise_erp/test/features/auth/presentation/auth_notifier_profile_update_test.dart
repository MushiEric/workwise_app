import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:workwise_erp/core/errors/either.dart';
import 'package:workwise_erp/features/auth/domain/entities/user.dart';
import 'package:workwise_erp/features/auth/domain/entities/role.dart';
import 'package:workwise_erp/features/auth/domain/repositories/auth_repository.dart';
import 'package:workwise_erp/features/auth/domain/usecases/login.dart';
import 'package:workwise_erp/features/auth/domain/usecases/get_current_user.dart';
import 'package:workwise_erp/features/auth/domain/usecases/update_profile.dart';
import 'package:workwise_erp/features/auth/presentation/notifier/auth_notifier.dart';
import 'package:workwise_erp/features/auth/domain/entities/permission.dart';
import 'package:workwise_erp/features/auth/domain/entities/permission.dart';
import 'package:workwise_erp/features/auth/presentation/state/auth_state.dart';

class MockRepo extends Mock implements AuthRepository {}

void main() {
  late MockRepo mockRepo;
  late AuthNotifier notifier;

  setUp(() {
    mockRepo = MockRepo();
    notifier = AuthNotifier(
      loginUseCase: Login(mockRepo),
      getCurrentUserUseCase: GetCurrentUser(mockRepo),
      updateProfileUseCase: UpdateProfile(mockRepo),
    );
  });

  test('updateProfile preserves roles and isAdmin when response lacks them', () async {
    // 1. Arrange: User is already authenticated with roles and isAdmin=true
    final initialRoles = [const Role(id: 1, name: 'Admin')];
    final initialUser = User(
      id: 1,
      name: 'Original Name',
      email: 'test@example.com',
      isAdmin: true,
      roles: initialRoles,
    );
    
    // Set initial state
    notifier.state = AuthState.authenticated(initialUser);

    // 2. Prepare update response (incomplete: missing roles and isAdmin)
    final updatedUserResponse = User(
      id: 1,
      name: 'Updated Name',
      email: 'test@example.com',
      // isAdmin and roles are null in this mock response
    );

    when(() => mockRepo.updateProfile(any()))
        .thenAnswer((_) async => Either.right(updatedUserResponse));

    // 3. Act
    await notifier.updateProfile({'name': 'Updated Name'});

    // 4. Assert
    notifier.state.when(
      initial: () => fail('expected authenticated'),
      loading: (_) => fail('expected authenticated'),
      authenticated: (u) {
        expect(u.name, 'Updated Name');
        expect(u.isAdmin, true, reason: 'isAdmin should be preserved from previous state');
        expect(u.roles, initialRoles, reason: 'roles should be preserved from previous state');
      },
      error: (m) => fail('expected authenticated, got error: $m'),
    );
  });

  test('updateProfile uses new roles if response provides them', () async {
    // 1. Arrange
    final initialUser = User(
      id: 1,
      name: 'Original Name',
      roles: [const Role(id: 1, name: 'User')],
    );
    notifier.state = AuthState.authenticated(initialUser);

    // 2. Response with NEW roles
    final newRoles = [const Role(id: 2, name: 'Manager')];
    final updatedUserResponse = User(
      id: 1,
      name: 'Updated Name',
      roles: newRoles,
    );

    when(() => mockRepo.updateProfile(any()))
        .thenAnswer((_) async => Either.right(updatedUserResponse));

    // 3. Act
    await notifier.updateProfile({'name': 'Updated Name'});

    // 4. Assert
    notifier.state.maybeWhen(
      authenticated: (u) {
        expect(u.roles, newRoles, reason: 'Should use roles from response if present');
      },
      orElse: () => fail('expected authenticated'),
    );
  });

  test('updateProfile preserves isAdmin=false if response lacks it', () async {
    // Arrange
    final initialUser = User(id: 1, name: 'Original', isAdmin: false);
    notifier.state = AuthState.authenticated(initialUser);

    final updatedUserResponse = User(id: 1, name: 'Updated'); // isAdmin is null
    when(() => mockRepo.updateProfile(any()))
        .thenAnswer((_) async => Either.right(updatedUserResponse));

    // Act
    await notifier.updateProfile({'name': 'Updated'});

    // Assert
    notifier.state.maybeWhen(
      authenticated: (u) => expect(u.isAdmin, false),
      orElse: () => fail('expected authenticated'),
    );
  });

  test('updateProfile preserves permissions if response roles lack them', () async {
    // 1. Arrange
    final permissions = [const Permission(id: 1, name: 'view_reports')];
    final initialRoles = [Role(id: 1, name: 'Manager', permissions: permissions)];
    final initialUser = User(id: 1, name: 'Original', roles: initialRoles);
    notifier.state = AuthState.authenticated(initialUser);

    // 2. Response with role but NO permissions
    final updatedUserResponse = User(
      id: 1,
      name: 'Updated',
      roles: [const Role(id: 1, name: 'Manager')], // No permissions
    );

    when(() => mockRepo.updateProfile(any()))
        .thenAnswer((_) async => Either.right(updatedUserResponse));

    // 3. Act
    await notifier.updateProfile({'name': 'Updated'});

    // 4. Assert
    notifier.state.maybeWhen(
      authenticated: (u) {
        expect(u.roles!.first.permissions, permissions, 
            reason: 'Permissions should be merged from previous state');
      },
      orElse: () => fail('expected authenticated'),
    );
  });
}
