import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_posts/domain/entities/user_post_entity.dart';
import 'package:my_posts/domain/repositories/user_post_repository.dart';
import 'package:my_posts/domain/usecases/add_user_post_usecase.dart';
import 'package:mockito/annotations.dart';
import 'user_post_usecase_test.mocks.dart';

@GenerateMocks([UserPostRepository])
main() {
  late AddUserPostUseCase useCase;
  late MockUserPostRepository mockUserPostRepository;

  setUp(() {
    mockUserPostRepository = MockUserPostRepository();
    useCase = AddUserPostUseCase(mockUserPostRepository);
  });

  UserPostEntity tUserPost = const UserPostEntity(
      userId: 1, id: 2, title: 'title1', body: 'description');

  test('should add user posts in the repository', () async {
    //arrange
    when(mockUserPostRepository.addUserPost(tUserPost))
        .thenAnswer((_) async => Right(tUserPost));

    //act
    final result = await useCase.call(tUserPost);
    //assert
    expect(result, Right(tUserPost));
    verify(mockUserPostRepository.addUserPost(tUserPost));
    verifyNoMoreInteractions(mockUserPostRepository);
  });
}
