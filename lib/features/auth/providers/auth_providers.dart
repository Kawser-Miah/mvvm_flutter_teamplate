import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/network/dio_client.dart';
import '../../../core/services/secure_storage_service/secure_storage_service.dart';
import '../../../core/services/sp_service/sp_service.dart';
import '../data_sources/auth_remote_data_source.dart';
import '../repositories/auth_repository.dart';
import '../repositories/auth_repository_impl.dart';

/// Whether a stored access token existed when the app started. Resolved in
/// `main()` before `runApp` and used once by the router for its
/// `initialLocation`. Login/register/logout navigate explicitly afterwards.
final signedInAtLaunchProvider = Provider<bool>((ref) => false);

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSource(ref.watch(dioClientProvider).dio);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    ref.watch(authRemoteDataSourceProvider),
    ref.watch(secureStorageServiceProvider),
    ref.watch(spServiceProvider),
  );
});
