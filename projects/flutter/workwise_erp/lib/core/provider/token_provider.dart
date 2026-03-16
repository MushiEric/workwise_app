import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../storage/token_local_data_source.dart';
import '../storage/user_local_data_source.dart';

final _tokenLocalDataSourceProvider = Provider<TokenLocalDataSource>((ref) {
  return TokenLocalDataSource(storage: const FlutterSecureStorage());
});

final tokenLocalDataSourceProvider = Provider<TokenLocalDataSource>(
  (ref) => ref.read(_tokenLocalDataSourceProvider),
);

final _userLocalDataSourceProvider = Provider<UserLocalDataSource>((ref) {
  return UserLocalDataSource(storage: const FlutterSecureStorage());
});

final userLocalDataSourceProvider = Provider<UserLocalDataSource>(
  (ref) => ref.read(_userLocalDataSourceProvider),
);
