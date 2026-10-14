import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:guard_well/core/errors/result.dart';
import 'package:guard_well/core/services/secure_storage_service/secure_storage_service.dart';
import 'package:guard_well/core/services/sp_service/sp_service.dart';
import 'package:guard_well/features/auth/data_sources/auth_remote_data_source.dart';
import 'package:guard_well/features/auth/repositories/auth_repository_impl.dart';
import 'package:guard_well/model/auth/auth_response_model.dart';
import 'package:guard_well/model/auth/login_request_model.dart';
import 'package:guard_well/model/auth/user_model.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/fake_secure_storage_service.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

void main() {
  const request = LoginRequestModel(email: 'a@b.co', password: 'secret1');
  const user = UserModel(id: '1', email: 'a@b.co', name: 'Ann');

  late MockAuthRemoteDataSource remote;
  late FakeSecureStorageService secure;
  late SpService sp;
  late AuthRepositoryImpl repository;

  setUpAll(() => registerFallbackValue(request));

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    remote = MockAuthRemoteDataSource();
    secure = FakeSecureStorageService();
    sp = SpServiceImpl(await SharedPreferences.getInstance());
    repository = AuthRepositoryImpl(remote, secure, sp);
  });

  void stubLogin(Result<AuthResponseModel> result) =>
      when(() => remote.login(any())).thenAnswer((_) async => result);

  test('a 2xx response without a token is rejected and nothing is stored',
      () async {
    // What `AuthResponseModel.fromJson({})` produces for an empty body.
    stubLogin(Result.success(AuthResponseModel.fromJson(const {})));

    final result = await repository.login(request);

    expect(result, isA<Failure<UserModel>>());
    expect((result as Failure).message, 'Invalid response from server.');
    expect(secure.values, isEmpty);
    expect(sp.contains(StorageKey.user), isFalse);
  });

  test('a network error passes through unchanged', () async {
    stubLogin(const Result.error(
      'No internet connection. Please check your connection.',
      kind: ErrorKind.network,
    ));

    final result = await repository.login(request);

    final failure = result as Failure<UserModel>;
    expect(failure.kind, ErrorKind.network);
    expect(failure.message, contains('No internet'));
    expect(secure.values, isEmpty);
  });

  test('a valid response stores tokens and user', () async {
    stubLogin(const Result.success(
      AuthResponseModel(token: 'access', refreshToken: 'refresh', user: user),
    ));

    final result = await repository.login(request);

    expect((result as Success<UserModel>).data.email, 'a@b.co');
    expect(await secure.read(SecureKey.accessToken), 'access');
    expect(await secure.read(SecureKey.refreshToken), 'refresh');
    final cached = jsonDecode(sp.read<String>(StorageKey.user)!);
    expect(cached['email'], 'a@b.co');
    expect(repository.cachedUser?.name, 'Ann');
  });

  test('register applies the same token check', () async {
    when(() => remote.register(any())).thenAnswer(
      (_) async => Result.success(AuthResponseModel.fromJson(const {})),
    );

    final result = await repository.register({'email': 'a@b.co'});

    expect(result, isA<Failure<UserModel>>());
    expect(secure.values, isEmpty);
  });

  test('logout clears tokens and cached user', () async {
    stubLogin(const Result.success(
      AuthResponseModel(token: 'access', refreshToken: 'refresh', user: user),
    ));
    await repository.login(request);

    final result = await repository.logout();

    expect(result.isSuccess, isTrue);
    expect(secure.values, isEmpty);
    expect(sp.contains(StorageKey.user), isFalse);
    expect(repository.cachedUser, isNull);
  });
}
