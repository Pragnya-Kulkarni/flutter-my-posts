import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_posts/domain/repositories/user_post_repository.dart';
import 'package:my_posts/domain/usecases/delete_user_post_usecase.dart';
import 'package:mockito/annotations.dart';
import 'user_post_usecase_test.mocks.dart';

@GenerateMocks([UserPostRepository])
main() {
  late DeleteUserPostUseCase useCase;
  late MockUserPostRepository mockUserPostRepository;

  setUp(() {
    mockUserPostRepository = MockUserPostRepository();
    useCase = DeleteUserPostUseCase(mockUserPostRepository);
  });

  /*List<UserPostEntity> tUserPost = [];
  tUserPost.add(const UserPostEntity(
      userId: 1, id: 2, title: 'title1', body: 'description'));*/
  final tId = 1;

  test('should delete user posts from the repository', () async {
    //arrange
    when(mockUserPostRepository.deleteUserPostsById(tId))
        .thenAnswer((_) async => const Right(null));

    //act
    await useCase.call(tId);

    //assert
    verify(mockUserPostRepository.deleteUserPostsById(tId));
    verifyNoMoreInteractions(mockUserPostRepository);
  });
}
