import 'package:dartz/dartz.dart';
import 'package:demo/core/errors/exceptions.dart';
import 'package:demo/core/errors/failure.dart';
import 'package:demo/core/utils/typedef.dart';
import 'package:demo/src/authentication/data/datasource/authentication_remote_data_source.dart';
import 'package:demo/src/authentication/domain/entities/user.dart';
import 'package:demo/src/authentication/domain/repositories/authentication_repository.dart';

class AuthenticationRepositoryImplementation implements AuthenticationRepository{
  const AuthenticationRepositoryImplementation(this._remoteDataSource);
  final AuthenticationRemoteDataSource _remoteDataSource;

  @override
  ResultVoid createUser({required String createdAt, required String name, required String avatar})async {
     try {
      await _remoteDataSource.createUser(createdAt: createdAt, name: name, avatar: avatar);
      return const Right(null);
     }on APIException catch (e) {
       return Left(APIFailure.fromException(e));
     }
  }

  @override
  ResultFuture<List<User>> getUsers()async {
    try {
      final result=await _remoteDataSource.getUsers();
      return Right(result);
    }on APIException catch (e) {
      return Left(APIFailure.fromException(e));
    }
  }
  
}