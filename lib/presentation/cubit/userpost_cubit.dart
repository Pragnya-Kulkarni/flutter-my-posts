import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_posts/core/usecases/usecase.dart';
import 'package:my_posts/domain/entities/user_post_entity.dart';
import 'package:my_posts/domain/usecases/delete_user_post_usecase.dart';
import 'package:my_posts/domain/usecases/get_user_post_usecase.dart';
part 'userpost_state.dart';

class UserPostCubit extends Cubit<UserPostState> {
  final GetUserPostUseCase getUserPostUseCase;
  final DeleteUserPostUseCase deleteUserPostUseCase;
  UserPostCubit(
      {required this.deleteUserPostUseCase, required this.getUserPostUseCase})
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
}
