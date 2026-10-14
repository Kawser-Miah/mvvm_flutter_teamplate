import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_client.dart';
import '../repositories/auth_repository.dart';
import '../services/auth_api_service.dart';

final authApiServiceProvider = Provider<AuthApiService>((ref) {
  final dioClient = ref.read(dioClientProvider);
  return AuthApiService(dioClient.dio);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final apiService = ref.read(authApiServiceProvider);
  return AuthRepository(apiService);
});
