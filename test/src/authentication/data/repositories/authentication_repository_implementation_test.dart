import 'package:dartz/dartz.dart';
import 'package:demo/core/errors/exceptions.dart';
import 'package:demo/core/errors/failure.dart';
import 'package:demo/src/authentication/data/datasource/authentication_remote_data_source.dart';
import 'package:demo/src/authentication/data/repositories/authentication_repository_implementation.dart';
import 'package:demo/src/authentication/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthenticationRemoteDataSource extends Mock
    implements AuthenticationRemoteDataSource {}

void main() {
  late AuthenticationRemoteDataSource remoteDataSource;
  late AuthenticationRepositoryImplementation repoImpl;
  setUp(() {
    remoteDataSource = MockAuthenticationRemoteDataSource();
    repoImpl = AuthenticationRepositoryImplementation(remoteDataSource);
  });

  const createdAt = "whatever.createdAt";
  const name = "whatever.name";
  const avatar = "whatever.avatar";
  const tException =
      APIException(message: "Unknown error occured", statusCode: 500);
  group("createUser", () {
    test('''should call [remoteDataSource.createUser] and complete successfully
     when the call to the remote source is successful''', () async {
      // Arrange
      when(
        () => remoteDataSource.createUser(
            createdAt: any(named: 'createdAt'),
            name: any(named: 'name'),
            avatar: any(named: 'avatar')),
      ).thenAnswer((_) async => Future.value());
      // Act
      final result = await repoImpl.createUser(
          createdAt: createdAt, name: name, avatar: avatar);

      // Assert
      expect(result, equals(const Right(null)));
      verify(
        () => remoteDataSource.createUser(
            createdAt: createdAt, name: name, avatar: avatar),
      ).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });

    test(
        "should return  [APIFailure] when call to the remote data source is unsuccessful",
        () async {
      // Arrange
      when(
        () => remoteDataSource.createUser(
            createdAt: any(named: 'createdAt'),
            name: any(named: 'name'),
            avatar: any(named: 'avatar')),
      ).thenThrow(tException);

      // Act
      final result = await repoImpl.createUser(
          createdAt: createdAt, name: name, avatar: avatar);

      // Assert
      expect(
        result,
        Left(
          APIFailure(
              message: tException.message, statusCode: tException.statusCode),
        ),
      );
      verify(
        () => remoteDataSource.createUser(
            createdAt: createdAt, name: name, avatar: avatar),
      ).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });
  });

  group("getUsers", () { 
    test("Should call [RemoteDatasource.getUsers] and return [List<User>] when call to remote data source is successful", ()async{
      // Arrange
        when(() => remoteDataSource.getUsers(),).thenAnswer((_) async=>[]);
      // Act
        final result=await repoImpl.getUsers();
      // Assert
      expect(result, isA<Right<dynamic,List<User>>>());
      verify(() => remoteDataSource.getUsers(),).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });

    test("should return  [APIFailure] when call to the remote data source is unsuccessful", ()async{
      // Arrange
        when(() => remoteDataSource.getUsers(),).thenThrow(tException);
      // Act
      final result=await repoImpl.getUsers();
      // Assert
      expect(result, equals(Left(APIFailure(message: tException.message,statusCode: tException.statusCode))));
      verify(() => remoteDataSource.getUsers(),).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });
  });
}