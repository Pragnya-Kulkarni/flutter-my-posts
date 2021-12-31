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

class UserPostDeleted extends UserPostState {
  const UserPostDeleted();

  @override
  List<Object?> get props => [];
}

class UserPostAdding extends UserPostState {
  const UserPostAdding();

  @override
  List<Object?> get props => [];
}

class UserPostAdded extends UserPostState {
  const UserPostAdded({required this.addedUserPost});
  final UserPostEntity addedUserPost;
  @override
  List<Object?> get props => [addedUserPost];
}

class UserPostAddFailed extends UserPostState {
  final String message;
  const UserPostAddFailed({required this.message});

  @override
  List<Object?> get props => [message];
}

class UserPostUpdating extends UserPostState {
  const UserPostUpdating();

  @override
  List<Object?> get props => [];
}

class UserPostUpdated extends UserPostState {
  const UserPostUpdated({required this.updatedUserPost});
  final UserPostEntity updatedUserPost;
  @override
  List<Object?> get props => [updatedUserPost];
}

class UserPostUpdateFailed extends UserPostState {
  final String message;
  const UserPostUpdateFailed({required this.message});

  @override
  List<Object?> get props => [message];
}
