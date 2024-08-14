import 'dart:convert';

import 'package:demo/core/utils/typedef.dart';
import 'package:demo/src/authentication/domain/entities/user.dart';

class UserModel extends User {
  const UserModel(
      {required super.id,
      required super.name,
      required super.avatar,
      required super.createdAt});

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(jsonDecode(source) as DataMap);

  UserModel.fromMap(DataMap map)
      : this(
            id: map['id'] as String,
            name: map['name'] as String,
            avatar: map['avatar'] as String,
            createdAt: map['createdAt'] as String);

  UserModel copyWith(
      {String? id, String? name, String? avatar, String? createdAt}) {
    return UserModel(
        id: id ?? this.id,
        name: name ?? this.name,
        avatar: avatar ?? this.avatar,
        createdAt: createdAt ?? this.createdAt);
  }


  const UserModel.empty()
  :this(id: '1', createdAt: "2024-03-21T04:10:07.098Z",name: "Test User",avatar: "avatarexample.jpg");

  DataMap toMap() =>
      {'id': id, 'name': name, 'avatar': avatar, 'createdAt': createdAt};

  String toJson() => jsonEncode(toMap());
}

