import 'package:demo/core/usecase/usecase.dart';
import 'package:demo/core/utils/typedef.dart';
import 'package:demo/src/authentication/domain/repositories/authentication_repository.dart';
import 'package:equatable/equatable.dart';

class CreateUser extends UsecaseWithParams<void,CreateUserParams> {
  const CreateUser(this._repository);

  final AuthenticationRepository _repository;
  
  @override
  ResultVoid call(CreateUserParams params)async=>_repository.createUser(createdAt:params.createdAt, name: params.name, avatar: params.avatar);
}

class CreateUserParams extends Equatable{
  const CreateUserParams(
    {
      required this.createdAt,
      required this.name,
      required this.avatar
    }
  );

  final String createdAt;
  final String name;
  final String avatar;


  const CreateUserParams.empty()
  :this(createdAt: "empty.createdAt",name: "empty.name",avatar: "empty.avatar");

  @override
  List<Object?> get props => [createdAt,name, avatar];

}
