import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:my_posts/core/error/failures.dart';
import 'package:my_posts/core/usecases/usecase.dart';
import 'package:my_posts/data/models/user_post_model.dart';
import 'package:my_posts/domain/entities/user_post_entity.dart';
import 'package:my_posts/domain/usecases/add_user_post_usecase.dart';
import 'package:my_posts/domain/usecases/delete_user_post_usecase.dart';
import 'package:my_posts/domain/usecases/get_user_post_usecase.dart';
import 'package:my_posts/domain/usecases/update_user_post_usecase.dart';
import 'package:my_posts/presentation/cubit/userpost_cubit.dart';
import 'userpost_cubit_test.mocks.dart';
import 'package:bloc_test/bloc_test.dart';

@GenerateMocks([GetUserPostUseCase])
@GenerateMocks([DeleteUserPostUseCase])
@GenerateMocks([AddUserPostUseCase])
@GenerateMocks([UpdateUserPostUseCase])
main() {
  late MockGetUserPostUseCase mockGetUserPostUseCase;
  late MockDeleteUserPostUseCase mockDeleteUserPostUseCase;
  late MockAddUserPostUseCase mockAddUserPostUseCase;
  late MockUpdateUserPostUseCase mockUpdateUserPostUseCase;

  late UserPostCubit userPostCubit;
  late UserPostEntity tUserPostEntity;
  setUp(() {
    mockGetUserPostUseCase = MockGetUserPostUseCase();
    mockDeleteUserPostUseCase = MockDeleteUserPostUseCase();
    mockAddUserPostUseCase = MockAddUserPostUseCase();
    mockUpdateUserPostUseCase = MockUpdateUserPostUseCase();
    userPostCubit = UserPostCubit(
        updateUserPostUseCase: mockUpdateUserPostUseCase,
        addUserPostUseCase: mockAddUserPostUseCase,
        deleteUserPostUseCase: mockDeleteUserPostUseCase,
        getUserPostUseCase: mockGetUserPostUseCase);

    tUserPostEntity = const UserPostModel(
        id: 1, userId: 2, title: 'title1', body: 'description');
  });

  tearDown(() {
    userPostCubit.close();
  });

  test('cubit should have initial state as UserPostInitial', () {
    expect(userPostCubit.state.runtimeType, UserPostInitial);
  });

  blocTest(
      'should emit loading state and loaded state when getuserpost is success',
      build: () => userPostCubit,
      act: (UserPostCubit bloc) {
        when(mockGetUserPostUseCase.call(NoParams()))
            .thenAnswer((_) async => const Right([]));
        bloc.getUserPost();
      },
      expect: () => [isA<UserPostLoading>(), isA<UserPostLoaded>()],
      verify: (UserPostCubit cubit) {
        verify(mockGetUserPostUseCase.call(any)).called(1);
      });

  blocTest('should emit LoadFailed state when getuserpost is failed',
      build: () => userPostCubit,
      act: (UserPostCubit bloc) {
        when(mockGetUserPostUseCase.call(NoParams()))
            .thenAnswer((_) async => Left(ServerFailure()));
        bloc.getUserPost();
      },
      expect: () => [isA<UserPostLoading>(), isA<UserPostLoadFailed>()],
      verify: (UserPostCubit cubit) {
        verify(mockGetUserPostUseCase.call(any)).called(1);
      });

  blocTest(
      'should emit loading state and deleted state when deleteuserpost is success',
      build: () => userPostCubit,
      act: (UserPostCubit bloc) {
        int? id = 1;
        when(mockDeleteUserPostUseCase.call(id))
            .thenAnswer((_) async => const Right([]));
        when(mockGetUserPostUseCase.call(NoParams()))
            .thenAnswer((_) async => const Right([]));
        bloc.deleteUserPost(id);
      },
      expect: () => [
            isA<UserPostLoading>(),
            isA<UserPostDeleted>(),
            isA<UserPostLoaded>()
          ],
      verify: (UserPostCubit cubit) {
        int? id = 1;
        verify(mockDeleteUserPostUseCase.call(id)).called(1);
        verify(mockGetUserPostUseCase.call(any)).called(1);
      });

  blocTest(
      'should emit UserPostLoading state and UserPostDeleteFailed state when deleteuserpost is failed',
      build: () => userPostCubit,
      act: (UserPostCubit bloc) {
        int? id = 1;
        when(mockDeleteUserPostUseCase.call(id))
            .thenAnswer((_) async => Left(ServerFailure()));
        when(mockGetUserPostUseCase.call(NoParams()))
            .thenAnswer((_) async => const Right([]));
        bloc.deleteUserPost(id);
      },
      expect: () => [
            isA<UserPostLoading>(),
            isA<UserPostDeleteFailed>(),
            isA<UserPostLoaded>()
          ],
      verify: (UserPostCubit cubit) {
        int? id = 1;
        verify(mockDeleteUserPostUseCase.call(id)).called(1);
        verify(mockGetUserPostUseCase.call(any)).called(1);
      });

  blocTest(
      'should emit adding state and added state when adduserpost is success',
      build: () => userPostCubit,
      act: (UserPostCubit bloc) {
        when(mockAddUserPostUseCase.call(any))
            .thenAnswer((_) async => Right(tUserPostEntity));
        bloc.addUserPost(tUserPostEntity);
      },
      expect: () => [isA<UserPostAdding>(), isA<UserPostAdded>()],
      verify: (UserPostCubit cubit) {
        verify(mockAddUserPostUseCase.call(any)).called(1);
      });

  blocTest(
      'should emit UserPostAdding state and UserPostAddFailed state when adduserpost is failed',
      build: () => userPostCubit,
      act: (UserPostCubit bloc) {
        when(mockAddUserPostUseCase.call(any))
            .thenAnswer((_) async => Left(ServerFailure()));
        bloc.addUserPost(tUserPostEntity);
      },
      expect: () => [isA<UserPostAdding>(), isA<UserPostAddFailed>()],
      verify: (UserPostCubit cubit) {
        verify(mockAddUserPostUseCase.call(any)).called(1);
      });

  blocTest(
      'should emit updating state and updated state when updateuserpost is success',
      build: () => userPostCubit,
      act: (UserPostCubit bloc) {
        when(mockUpdateUserPostUseCase.call(any))
            .thenAnswer((_) async => Right(tUserPostEntity));
        bloc.updateUserPost(tUserPostEntity);
      },
      expect: () => [isA<UserPostUpdating>(), isA<UserPostUpdated>()],
      verify: (UserPostCubit cubit) {
        verify(mockUpdateUserPostUseCase.call(any)).called(1);
      });

  blocTest(
      'should emit UserPostUpdating and UserPostUpdateFailed state when updateuserpost is failed',
      build: () => userPostCubit,
      act: (UserPostCubit bloc) {
        when(mockUpdateUserPostUseCase.call(any))
            .thenAnswer((_) async => Left(ServerFailure()));
        bloc.updateUserPost(tUserPostEntity);
      },
      expect: () => [isA<UserPostUpdating>(), isA<UserPostUpdateFailed>()],
      verify: (UserPostCubit cubit) {
        verify(mockUpdateUserPostUseCase.call(any)).called(1);
      });
}
