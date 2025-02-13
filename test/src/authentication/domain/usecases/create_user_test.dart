// What does the class depend on
//Answer---AuthenticationRepository
// How can we create a fake version of the dependency
// Answer---use Mocktail
// How do we coontrol what our dependency do
// Answer---using mocktail's APIs

import 'package:dartz/dartz.dart';
import 'package:demo/src/authentication/domain/repositories/authentication_repository.dart';
import 'package:demo/src/authentication/domain/usecases/create_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'authentication_repository.mock.dart';

void main() {
  late CreateUser usecase;
  late AuthenticationRepository repository;
  setUp(
    () {
      repository = MockAuthenticationRepository();
      usecase = CreateUser(repository);
    },
  );

  const params = CreateUserParams.empty();
  test('should call [AuthRepo.createUser]', () async {
    // Arrange
    when(() => repository.createUser(
            createdAt: any(named: "createdAt"),
            name: any(named: "name"),
            avatar: any(named: "avatar")))
        .thenAnswer((_) async => const Right(null));
    // Act
    final result = await usecase(params);
    // Assert
    expect(result, equals(const Right<dynamic, void>(null)));
    verify(() => repository.createUser(
        createdAt: params.createdAt,
        name: params.name,
        avatar: params.avatar)).called(1);
    verifyNoMoreInteractions(repository);
  });
}
