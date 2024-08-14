import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:demo/core/errors/failure.dart';
import 'package:demo/src/authentication/domain/usecases/create_user.dart';
import 'package:demo/src/authentication/domain/usecases/get_user.dart';
import 'package:demo/src/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetUsers extends Mock implements GetUsers {}

class MockCreateUser extends Mock implements CreateUser {}

void main() {
  late GetUsers getUsers;
  late CreateUser createUser;
  late AuthenticationBloc bloc;
  const tCreateUserParams = CreateUserParams.empty();
  setUp(() {
    getUsers = MockGetUsers();
    createUser = MockCreateUser();
    bloc = AuthenticationBloc(createUser: createUser, getUsers: getUsers);
    registerFallbackValue(tCreateUserParams);
  });

  test("should be [AuthenticationInitial]", () async {
    expect(bloc.state, AuthenticationInitial());
  });
  const tAPIFailure =
      APIFailure(message: "Oops! Server failure", statusCode: 400);
  group("createUser", () {
    blocTest<AuthenticationBloc, AuthenticationState>(
      'should emit [CreatingUser, UserCreated] when successful',
      build: () {
        when(() => createUser(any()))
            .thenAnswer((invocation) async => const Right(null));
        return bloc;
      },
      act: (bloc) => bloc.add(CreateUserEvent(
          name: tCreateUserParams.name,
          avatar: tCreateUserParams.avatar,
          createdAt: tCreateUserParams.createdAt)),
      expect: () => const [CreatingUser(), UserCreated()],
      verify: (_) {
        verify(
          () => createUser(tCreateUserParams),
        ).called(1);
        verifyNoMoreInteractions(createUser);
      },
    );
  });

  blocTest<AuthenticationBloc, AuthenticationState>(
    "should emit [CreateUser,AuthenticatioError] when unsuccessful",
    build: () {
      when(
        () => createUser(any()),
      ).thenAnswer((_) async => const Left(tAPIFailure));
      return bloc;
    },
    act: (bloc) => bloc.add(CreateUserEvent(
        name: tCreateUserParams.name,
        avatar: tCreateUserParams.avatar,
        createdAt: tCreateUserParams.createdAt)),
    expect: () =>
        [const CreatingUser(), AuthenticationError(tAPIFailure.errorMessage)],
    verify: (_) {
      verify(
        () => createUser(tCreateUserParams),
      ).called(1);
      verifyNoMoreInteractions(createUser);
    },
  );

  group("getUsers", () {
    blocTest<AuthenticationBloc, AuthenticationState>(
      "should emit [GettingUser, UserLoaded] when successful",
      build: () {
        when(
          () => getUsers(),
        ).thenAnswer((_) async => const Right([]));
        return bloc;
      },
      act: (bloc) => bloc.add(const GetUserEvent()),
      expect: () => const [GettingUsers(), UsersLoaded([])],
      verify: (_) {
        verify(() => getUsers()).called(1);
        verifyNoMoreInteractions(getUsers);
      },
    );

    blocTest<AuthenticationBloc, AuthenticationState>("should emit [GettingUser,AuthenticationError]", 
    build: () {
      when(() => getUsers(),).thenAnswer((_) async=>const Left(tAPIFailure) );
      return bloc;
    },
    act: (bloc) => bloc.add(const GetUserEvent()),
    expect: () => [
      const GettingUsers(),
      AuthenticationError(tAPIFailure.errorMessage)
    ],
    verify: (_){
      verify(() => getUsers(),).called(1);
      verifyNoMoreInteractions(getUsers);
    },
    );
  });
}