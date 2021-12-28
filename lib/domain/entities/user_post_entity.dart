import 'package:equatable/equatable.dart';

class UserPostEntity extends Equatable {
  final int userId;
  final int id;
  final String title;
  final String body;

  const UserPostEntity(
      {required this.userId,
      required this.id,
      required this.title,
      required this.body});

  @override
  // TODO: implement props
  List<Object> get props => [userId, id, title, body];
}
