import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_posts/core/usecases/usecase.dart';
import 'package:my_posts/domain/entities/user_post_entity.dart';
import 'package:my_posts/domain/usecases/add_user_post_usecase.dart';
import 'package:my_posts/domain/usecases/delete_user_post_usecase.dart';
import 'package:my_posts/domain/usecases/get_user_post_usecase.dart';
import 'package:my_posts/domain/usecases/update_user_post_usecase.dart';
part 'userpost_state.dart';

class UserPostCubit extends Cubit<UserPostState> {
  final GetUserPostUseCase getUserPostUseCase;
  final DeleteUserPostUseCase deleteUserPostUseCase;
  final AddUserPostUseCase addUserPostUseCase;
  final UpdateUserPostUseCase updateUserPostUseCase;
  UserPostCubit(
      {required this.updateUserPostUseCase,
      required this.addUserPostUseCase,
      required this.deleteUserPostUseCase,
      required this.getUserPostUseCase})
      : super(const UserPostInitial());

  Future<void> getUserPost() async {
    try {
      emit(const UserPostLoading());
      final userPostEither = await getUserPostUseCase.call(NoParams());
      userPostEither.fold(
          (failure) => emit(UserPostError(message: failure.toString())),
          (loadedPost) => emit(UserPostLoaded(lstUserPost: loadedPost)));
    } on Exception catch (e) {
      emit(UserPostError(message: e.toString()));
    }
  }

  Future<void> deleteUserPost(int id) async {
    try {
      emit(const UserPostLoading());
      final deleteUserPostEither = await deleteUserPostUseCase.call(id);
      deleteUserPostEither.fold(
          (failure) => emit(UserPostError(message: failure.toString())),
          (isSuccess) => emit(UserPostDeleted()));

      final userPostEither = await getUserPostUseCase.call(NoParams());
      userPostEither.fold(
          (failure) => emit(UserPostError(message: failure.toString())),
          (loadedPost) => emit(UserPostLoaded(lstUserPost: loadedPost)));
    } on Exception catch (e) {
      emit(UserPostError(message: e.toString()));
    }
  }

  Future<void> addUserPost(UserPostEntity userPostEntity) async {
    try {
      emit(const UserPostAdding());
      final addedUserPostEither = await addUserPostUseCase.call(userPostEntity);
      addedUserPostEither.fold(
          (failure) => emit(UserPostAddFailed(message: failure.toString())),
          (addedPost) => emit(UserPostAdded(addedUserPost: addedPost)));
    } on Exception catch (e) {
      emit(UserPostAddFailed(message: e.toString()));
    }
  }

  Future<void> updateUserPost(UserPostEntity userPostEntity) async {
    try {
      emit(const UserPostUpdating());
      final updatedUserPostEither =
          await updateUserPostUseCase.call(userPostEntity);
      updatedUserPostEither.fold(
          (failure) => emit(UserPostUpdateFailed(message: failure.toString())),
          (updatedPost) => emit(UserPostUpdated(updatedUserPost: updatedPost)));
    } on Exception catch (e) {
      emit(UserPostUpdateFailed(message: e.toString()));
    }
  }
}
