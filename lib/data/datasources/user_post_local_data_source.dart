import 'package:my_posts/data/models/user_post_model.dart';

abstract class UserPostLocalDataSource {
  Future<List<UserPostModel>> getUserPost();

  Future<UserPostModel> getUserPostById(int id);

  Future<void> deleteUserPostById(int id);
}

class UserPostLocalDataImpl implements UserPostLocalDataSource {
  @override
  Future<List<UserPostModel>> getUserPost() {
    // TODO: implement getUserPost
    throw UnimplementedError();
  }

  @override
  Future<UserPostModel> getUserPostById(int id) {
    // TODO: implement getUserPostById
    throw UnimplementedError();
  }

  @override
  Future<void> deleteUserPostById(int id) {
    // TODO: implement deleteUserPostById
    throw UnimplementedError();
  }
}
