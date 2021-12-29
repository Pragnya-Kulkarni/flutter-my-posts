import 'package:dartz/dartz.dart';
import 'package:my_posts/core/error/failures.dart';
import 'package:my_posts/core/usecases/usecase.dart';
import 'package:my_posts/domain/repositories/user_post_repository.dart';

class DeleteUserPostUseCase implements UseCase<void, int> {
  final UserPostRepository repository;

  DeleteUserPostUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(int id) async {
    return await repository.deleteUserPostsById(id);
  }
}
