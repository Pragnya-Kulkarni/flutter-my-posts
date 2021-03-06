import 'package:dartz/dartz.dart';
import 'package:my_posts/core/error/exception.dart';
import 'package:my_posts/core/error/failures.dart';
import 'package:my_posts/core/network/network_info.dart';
import 'package:my_posts/data/datasources/user_post_local_data_source.dart';
import 'package:my_posts/data/datasources/user_post_remote_data_source.dart';
import 'package:my_posts/data/models/user_post_model.dart';
import 'package:my_posts/domain/entities/user_post_entity.dart';
import 'package:my_posts/domain/repositories/user_post_repository.dart';

class UserPostRepositoryImpl implements UserPostRepository {
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

  @override
  Future<Either<Failure, void>> deleteUserPostsById(int id) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteUserPostById(id);
        return const Right(null);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        await localDataSource.deleteUserPostById(id);
        return const Right(null);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, UserPostEntity>> addUserPost(
      UserPostEntity userPostEntity) async {
    if (await networkInfo.isConnected) {
      try {
        final addedUserPost = await remoteDataSource
            .addUserPost(UserPostModel.fromEntity(userPostEntity));
        return Right(addedUserPost);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final addedUserPost = await localDataSource
            .addUserPost(UserPostModel.fromEntity(userPostEntity));
        return Right(addedUserPost);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, UserPostEntity>> updateUserPost(
      UserPostEntity userPostEntity) async {
    if (await networkInfo.isConnected) {
      try {
        final updatedUserPost = await remoteDataSource
            .updateUserPost(UserPostModel.fromEntity(userPostEntity));
        return Right(updatedUserPost);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final updatedUserPost = await localDataSource
            .updateUserPost(UserPostModel.fromEntity(userPostEntity));
        return Right(updatedUserPost);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
