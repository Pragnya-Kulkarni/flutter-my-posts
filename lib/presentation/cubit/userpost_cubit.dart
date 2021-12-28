import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_posts/domain/entities/user_post_entity.dart';
import 'package:my_posts/domain/usecases/get_user_post_usecase.dart';
part 'userpost_state.dart';

class UserPostCubit extends Cubit<UserPostState> {
  final GetUserPostUseCase getUserPostUseCase;

  UserPostCubit({required this.getUserPostUseCase})
      : super(const UserPostInitial());

  Future<void> getUserPost() async {
    try {
      emit(const UserPostLoading());
      final userPostEither = await getUserPostUseCase.call();
      userPostEither.fold(
          (failure) => emit(UserPostError(message: failure.toString())),
          (loadedPost) => emit(UserPostLoaded(lstUserPost: loadedPost)));
    } on Exception catch (e) {
      emit(UserPostError(message: e.toString()));
    }
  }
}
