import 'package:dartz/dartz.dart';
import 'package:demo/src/authentication/domain/entities/user.dart';
import 'package:demo/src/authentication/domain/repositories/authentication_repository.dart';
import 'package:demo/src/authentication/domain/usecases/get_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'authentication_repository.mock.dart';

void main(){
  late AuthenticationRepository repository;
  late GetUsers usecase;

  setUp(() {
    repository=MockAuthenticationRepository();
    usecase=GetUsers(repository);

  } );


const tResponse=[User.empty()];
  test('Should call [AuthRepo.getUsers] and should return [List<User>]', ()async {
    // arrange
    when(()=>repository.getUsers()).thenAnswer((_)async =>const Right(tResponse));
    // act
    final result=await usecase();
    // assert
    expect(result, equals(const Right<dynamic,List<User>>(tResponse)));
    verify(()=>repository.getUsers()).called(1);
    verifyNoMoreInteractions(repository);
  });
}