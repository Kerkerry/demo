import 'dart:convert';

import 'package:demo/core/errors/exceptions.dart';
import 'package:demo/core/utils/constants.dart';
import 'package:demo/src/authentication/data/datasource/authentication_remote_data_source.dart';
import 'package:demo/src/authentication/data/models/user_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  late http.Client client;
  late AuthenticationRemoteDataSource authRemoteDataScImpl;

  setUp(() {
    client = MockClient();
    authRemoteDataScImpl = AuthenticationRemoteDataSourceImplementation(client);
    registerFallbackValue(Uri());
  });

  group("createUser", () {
    test("should complete successfully when the status code is 200 or 201",
        () async {
      // Arrange
      when(
        () => client.post(any(), body: any(named: 'body')),
      ).thenAnswer(
          (_) async => http.Response('User created successfully', 201));

      // Act
      final methodCall = authRemoteDataScImpl.createUser;

      // Assert
      expect(methodCall(createdAt: "createdAt", name: "name", avatar: "avatar"),
          completes);
      verify(
        () => client.post(Uri.https(kBaseUrl, kCreateUsersEndpoint),
            body: jsonEncode({
              'createdAt': "createdAt",
              'name': "name",
              'avatar': "avatar"
            })),
      ).called(1);

      verifyNoMoreInteractions(client);
    });

    test("Should throw [APIException] when status code is not 200 or 201", () {
      // Arrange
      when(
        () => client.post(any(), body: any(named: 'body')),
      ).thenAnswer((_) async => http.Response('Invalid email address', 400));
      // Act
      final methodCall = authRemoteDataScImpl.createUser;
      // Assert
      expect(
          () async => methodCall(
              createdAt: "createdAt", name: "name", avatar: "avatar"),
          throwsA(const APIException(
              message: 'Invalid email address', statusCode: 400)));
      verify(
        () => client.post(Uri.https(kBaseUrl, kCreateUsersEndpoint),
            body: jsonEncode({
              'createdAt': "createdAt",
              'name': "name",
              'avatar': "avatar"
            })),
      ).called(1);

      verifyNoMoreInteractions(client);
    });
  });

  group("getUsers", () {
    const tUsers = [UserModel.empty()];
    test("should return [List<User>] when the status code is 200", () async {
      // Arrange
      when(() => client.get(any())).thenAnswer(
        (_) async => http.Response(jsonEncode([tUsers.first.toMap()]), 200),
      );
      // Act
      final response = await authRemoteDataScImpl.getUsers();
      // Assert
      expect(response, equals(tUsers));
      verify(() => client.get(Uri.https(kBaseUrl, kGetusersEndpoint)))
          .called(1);
      verifyNoMoreInteractions(client);
    });

    test("should throw [APIException] when the status code is not 200",
        () async {
      const tMessage = '''
Server down, Server down, I repeat Server down. 
Mayday Mayday Mayday, We are going down.
AHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH
HHHHHHHHHH''';
      // Arrange
      when(
        () => client.get(any()),
      ).thenAnswer((_) async => http.Response(tMessage, 500));
      // Act
      final methodCall = authRemoteDataScImpl.getUsers;
      // Assert
      expect(
        () => methodCall(),
        throwsA(
          const APIException(message: tMessage, statusCode: 500),
        ),
      );
      verify(() => client.get(Uri.https(kBaseUrl, kGetusersEndpoint)))
          .called(1);
      verifyNoMoreInteractions(client);
    });
  });
}
