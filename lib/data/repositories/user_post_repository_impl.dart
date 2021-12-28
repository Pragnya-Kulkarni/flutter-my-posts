import 'package:dartz/dartz.dart';
import 'package:my_posts/core/error/exception.dart';
import 'package:my_posts/core/error/failures.dart';
import 'package:my_posts/core/network/network_info.dart';
import 'package:my_posts/data/datasources/user_post_local_data_source.dart';
import 'package:my_posts/data/datasources/user_post_remote_data_source.dart';
import 'package:my_posts/domain/entities/user_post_entity.dart';
import 'package:my_posts/domain/repositories/user_post_repository.dart';

class UserPostRepositoryImpl extends UserPostRepository {
  final UserPostRemoteDataSource remoteDataSource;
  final UserPostLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  UserPostRepositoryImpl(
      {required this.remoteDataSource,
      required this.networkInfo,
      required this.localDataSource});
  @override
  Future<Either<Failure, List<UserPostEntity>>> getUserPosts() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteUserPost = await remoteDataSource.getUserPost();
        return Right(remoteUserPost);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localUserPost = await localDataSource.getUserPost();
        return Right(localUserPost);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, UserPostEntity>> getUserPostsById(int id) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteUserPost = await remoteDataSource.getUserPostById(id);
        return Right(remoteUserPost);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localUserPost = await localDataSource.getUserPostById(id);
        return Right(localUserPost);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
