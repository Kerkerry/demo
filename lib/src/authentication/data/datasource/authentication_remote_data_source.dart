import 'dart:convert';

import 'package:demo/core/errors/exceptions.dart';
import 'package:demo/core/utils/constants.dart';
import 'package:demo/core/utils/typedef.dart';
import 'package:demo/src/authentication/data/models/user_model.dart';
import 'package:http/http.dart' as http;

abstract class AuthenticationRemoteDataSource {
  Future<void> createUser(
      {required String createdAt,
      required String name,
      required String avatar});

  Future<List<UserModel>> getUsers();
}

const kCreateUsersEndpoint = '/test-api/users';
const kGetusersEndpoint = '/test-api/users';

class AuthenticationRemoteDataSourceImplementation
    implements AuthenticationRemoteDataSource {
  const AuthenticationRemoteDataSourceImplementation(this._client);
  final http.Client _client;

  @override
  Future<void> createUser(
      {required String createdAt,
      required String name,
      required String avatar}) async {
    // **************-When Performing Testing-*****************
    // Check to make sure that it returns the right data whe the response code is 200 or the proper response code
    // Check to make sure that it "THROWS A CUSTOM EXCEPTION" with the right message when status code is the bad one.

    final response = await _client.post(
      Uri.https(kBaseUrl, kCreateUsersEndpoint),
      body:
          jsonEncode({'createdAt': createdAt, "name": name}),
          headers: {
            'Content-Type':'application/json'
          }
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw APIException(
          message: response.body, statusCode: response.statusCode);
    }
  }

  @override
  Future<List<UserModel>> getUsers() async {
    try {
      final response =
          await _client.get(Uri.https(kBaseUrl, kGetusersEndpoint));

      if (response.statusCode != 200) {
        throw APIException(
            message: response.body, statusCode: response.statusCode);
      }
      return List<DataMap>.from(jsonDecode(response.body) as List)
          .map((userData) => UserModel.fromMap(userData))
          .toList();
    } 
    on APIException{
      rethrow;
    }
    catch (e) {
      throw(APIException(message: e.toString(), statusCode: 505));
    }
  }
}
