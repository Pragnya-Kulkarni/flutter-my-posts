import 'package:dartz/dartz.dart';
import 'package:my_posts/core/error/failures.dart';
import 'package:my_posts/domain/entities/user_post_entity.dart';

abstract class UserPostRepository {
  Future<Either<Failure, List<UserPostEntity>>> getUserPosts();
  Future<Either<Failure, UserPostEntity>> getUserPostsById(int id);
  Future<Either<Failure, void>> deleteUserPostsById(int id);
}
