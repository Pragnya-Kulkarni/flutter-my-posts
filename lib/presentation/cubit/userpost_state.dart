part of 'userpost_cubit.dart';

@immutable
abstract class UserPostState extends Equatable {
  const UserPostState();
}

class UserPostInitial extends UserPostState {
  const UserPostInitial();

  @override
  List<Object?> get props => [];
}

class UserPostLoading extends UserPostState {
  const UserPostLoading();

  @override
  List<Object?> get props => [];
}

class UserPostLoaded extends UserPostState {
  final List<UserPostEntity> lstUserPost;
  const UserPostLoaded({required this.lstUserPost});

  @override
  List<Object?> get props => [lstUserPost];
}

class UserPostError extends UserPostState {
  final String message;
  const UserPostError({required this.message});

  @override
  List<Object?> get props => [message];
}
