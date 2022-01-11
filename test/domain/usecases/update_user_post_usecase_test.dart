import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_posts/domain/entities/user_post_entity.dart';
import 'package:my_posts/domain/repositories/user_post_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:my_posts/domain/usecases/update_user_post_usecase.dart';
import 'user_post_usecase_test.mocks.dart';

//class MockUserPostRepository extends Mock implements UserPostRepository {}

@GenerateMocks([UserPostRepository])
main() {
  late UpdateUserPostUseCase useCase;
  late MockUserPostRepository mockUserPostRepository;

  setUp(() {
    mockUserPostRepository = MockUserPostRepository();
    useCase = UpdateUserPostUseCase(mockUserPostRepository);
  });

  UserPostEntity tUserPost = const UserPostEntity(
      userId: 1, id: 2, title: 'title1', body: 'description');

  test('should update user posts in the repository', () async {
    //arrange
    when(mockUserPostRepository.updateUserPost(tUserPost))
        .thenAnswer((_) async => Right(tUserPost));

    //act
    final result = await useCase.call(tUserPost);
    //assert
    expect(result, Right(tUserPost));
    verify(mockUserPostRepository.updateUserPost(tUserPost));
    verifyNoMoreInteractions(mockUserPostRepository);
  });
}
