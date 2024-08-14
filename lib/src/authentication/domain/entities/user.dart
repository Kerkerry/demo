import 'package:equatable/equatable.dart';

class User extends Equatable{
  final String id;
  final String createdAt;
  final String name;
  final String avatar;

 const User({required this.id, required this.createdAt, required this.name, required this.avatar});


  const User.empty()
  :this(id: '1', createdAt: "2024-03-21T04:10:07.098Z",name: "Test User",avatar: "avatarexample.jpg");

  @override
  List<Object?> get props=>[id,name,avatar,createdAt];
}