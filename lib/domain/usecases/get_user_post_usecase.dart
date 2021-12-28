import 'package:dartz/dartz.dart';
import 'package:my_posts/core/error/failures.dart';
import 'package:my_posts/domain/entities/user_post_entity.dart';
import 'package:my_posts/domain/repositories/user_post_repository.dart';

class GetUserPostUseCase {
  final UserPostRepository repository;

  GetUserPostUseCase(this.repository);

  Future<Either<Failure, List<UserPostEntity>>> call() async {
    return await repository.getUserPosts();
  }
}
