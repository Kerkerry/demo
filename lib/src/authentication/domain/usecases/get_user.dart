import 'package:demo/core/usecase/usecase.dart';
import 'package:demo/core/utils/typedef.dart';
import 'package:demo/src/authentication/domain/entities/user.dart';
import 'package:demo/src/authentication/domain/repositories/authentication_repository.dart';

class GetUsers extends UsecaseWithoutParams<List<User>>{
  const GetUsers(this._repository);
  final AuthenticationRepository _repository;

  @override
  ResultFuture<List<User>> call() async=>_repository.getUsers();
  
}