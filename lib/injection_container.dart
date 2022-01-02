import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:my_posts/core/network/network_info.dart';
import 'package:my_posts/data/datasources/user_post_local_data_source.dart';
import 'package:my_posts/data/datasources/user_post_remote_data_source.dart';
import 'package:my_posts/data/repositories/user_post_repository_impl.dart';
import 'package:my_posts/domain/repositories/user_post_repository.dart';
import 'package:my_posts/domain/usecases/add_user_post_usecase.dart';
import 'package:my_posts/domain/usecases/delete_user_post_usecase.dart';
import 'package:my_posts/domain/usecases/get_user_post_usecase.dart';
import 'package:my_posts/domain/usecases/update_user_post_usecase.dart';
import 'package:my_posts/presentation/cubit/userpost_cubit.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

void init() {
  //cubit
  sl.registerFactory(
    () => UserPostCubit(
        updateUserPostUseCase: sl(),
        addUserPostUseCase: sl(),
        deleteUserPostUseCase: sl(),
        getUserPostUseCase: sl()),
  );
  //use cases
  sl.registerLazySingleton(() => GetUserPostUseCase(sl()));
  sl.registerLazySingleton(() => DeleteUserPostUseCase(sl()));
  sl.registerLazySingleton(() => AddUserPostUseCase(sl()));
  sl.registerLazySingleton(() => UpdateUserPostUseCase(sl()));
  //Repository
  sl.registerLazySingleton<UserPostRepository>(() => UserPostRepositoryImpl(
      remoteDataSource: sl(), networkInfo: sl(), localDataSource: sl()));

  //Data Source
  sl.registerLazySingleton<UserPostRemoteDataSource>(
      () => UserPostRemoteDataImpl(client: sl()));

  sl.registerLazySingleton<UserPostLocalDataSource>(
      () => UserPostLocalDataImpl());

  //core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //External
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
