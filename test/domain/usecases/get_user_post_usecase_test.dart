import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_posts/core/usecases/usecase.dart';
import 'package:my_posts/domain/entities/user_post_entity.dart';
import 'package:my_posts/domain/repositories/user_post_repository.dart';
import 'package:my_posts/domain/usecases/get_user_post_usecase.dart';
import 'package:mockito/annotations.dart';
import 'user_post_usecase_test.mocks.dart';

//class MockUserPostRepository extends Mock implements UserPostRepository {}

@GenerateMocks([UserPostRepository])
main() {
  late GetUserPostUseCase useCase;
  late MockUserPostRepository mockUserPostRepository;

  setUp(() {
    mockUserPostRepository = MockUserPostRepository();
    useCase = GetUserPostUseCase(mockUserPostRepository);
  });

  List<UserPostEntity> tUserPost = [];
  tUserPost.add(const UserPostEntity(
      userId: 1, id: 2, title: 'title1', body: 'description'));

  test('should get user posts from the repository', () async {
    //arrange
    when(mockUserPostRepository.getUserPosts())
        .thenAnswer((_) async => Right(tUserPost));

    //act
    final result = await useCase.call(NoParams());
    //assert
    expect(result, Right(tUserPost));
    verify(mockUserPostRepository.getUserPosts());
    verifyNoMoreInteractions(mockUserPostRepository);
  });
}
