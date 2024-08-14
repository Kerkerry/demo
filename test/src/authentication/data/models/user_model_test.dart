import 'dart:convert';

import 'package:demo/core/utils/typedef.dart';
import 'package:demo/src/authentication/data/models/user_model.dart';
import 'package:demo/src/authentication/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tModel = UserModel.empty();
  test("Should be a subclass of [User] entity", () {
    // Act

    // Asert
    expect(tModel, isA<User>());
  });

  final tJson = fixture('user.json');
  final tMap = jsonDecode(tJson) as DataMap;
  group("fromMap", () {
    test("should return a [UserModel] with right data", () {
      // act
      final result = UserModel.fromMap(tMap);
      expect(result, equals(tModel));
    });
  });

  group("fromJson", () {
    test("should return a [UserModel] with right data", () {
      // act
      final result = UserModel.fromJson(tJson);
      expect(result, equals(tModel));
    });
  });

  group("toMap", () {
    test("return a [Map] with the right data", () {
      // Act
      final result = tModel.toMap();
      // Assert
      expect(result, equals(tMap));
    });
  });

  group("toJson", () {
    test("Should return a [Json] string with the right data", () {
     
      // Act
      final result = tModel.toJson();
      // Asert
       final tJson = jsonEncode({
        "id": "1",
        "name": "Test User",
        "avatar": "avatarexample.jpg",
        "createdAt": "2024-03-21T04:10:07.098Z",
      });
      expect(result, tJson);
    });
  });

  group("copyWith", () { 
    test("Should return [UserModel] with the different data", (){
      // Act
      final result=tModel.copyWith(name: "Kerry");
      // Asert
      expect(result.name, "Kerry");
    });
  });
}
