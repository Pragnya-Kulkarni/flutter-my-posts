import 'package:dartz/dartz.dart';
import 'package:my_posts/core/error/failures.dart';
import 'package:my_posts/core/usecases/usecase.dart';
import 'package:my_posts/domain/entities/user_post_entity.dart';
import 'package:my_posts/domain/repositories/user_post_repository.dart';

class UpdateUserPostUseCase implements UseCase<UserPostEntity, UserPostEntity> {
  final UserPostRepository repository;

  UpdateUserPostUseCase(this.repository);

  @override
  Future<Either<Failure, UserPostEntity>> call(
      UserPostEntity userPostEntity) async {
    return await repository.updateUserPost(userPostEntity);
  }
}
