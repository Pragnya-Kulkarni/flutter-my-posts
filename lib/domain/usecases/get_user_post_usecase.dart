import 'package:dartz/dartz.dart';
import 'package:my_posts/core/error/failures.dart';
import 'package:my_posts/core/usecases/usecase.dart';
import 'package:my_posts/domain/entities/user_post_entity.dart';
import 'package:my_posts/domain/repositories/user_post_repository.dart';

class GetUserPostUseCase implements UseCase<List<UserPostEntity>, NoParams> {
  final UserPostRepository repository;

  GetUserPostUseCase(this.repository);

  @override
  Future<Either<Failure, List<UserPostEntity>>> call(NoParams params) async {
    return await repository.getUserPosts();
  }
}
