import 'package:demo/src/authentication/data/datasource/authentication_remote_data_source.dart';
import 'package:demo/src/authentication/data/repositories/authentication_repository_implementation.dart';
import 'package:demo/src/authentication/domain/repositories/authentication_repository.dart';
import 'package:demo/src/authentication/domain/usecases/create_user.dart';
import 'package:demo/src/authentication/domain/usecases/get_user.dart';
import 'package:demo/src/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {
  // Application logic
  sl
    ..registerFactory(
        () => AuthenticationCubit(createUser: sl(), getUsers: sl()))
  // Usescases
    ..registerLazySingleton(() => CreateUser(sl()))
    ..registerLazySingleton(() => GetUsers(sl()))
  // Repositories
    ..registerLazySingleton<AuthenticationRepository>(
        () => AuthenticationRepositoryImplementation(sl()))
  // Data sources
    ..registerLazySingleton<AuthenticationRemoteDataSource>(
        () => AuthenticationRemoteDataSourceImplementation(sl()))
  // External dependecies
    ..registerLazySingleton(http.Client.new);
}
