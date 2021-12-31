import 'package:my_posts/domain/entities/user_post_entity.dart';

class UserPostModel extends UserPostEntity {
  const UserPostModel({
    required int id,
    required final int userId,
    required String title,
    required String body,
  }) : super(id: id, userId: userId, title: title, body: body);

  factory UserPostModel.fromJson(final json) {
    return UserPostModel(
      id: json["id"],
      userId: json["userId"],
      title: json["title"],
      body: json["body"],
    );
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "userId": userId, "title": title, "body": body};
  }

  factory UserPostModel.fromEntity(UserPostEntity userPostEntity) {
    return UserPostModel(
      id: userPostEntity.id,
      userId: userPostEntity.userId,
      title: userPostEntity.title,
      body: userPostEntity.body,
    );
  }
}
