import 'package:my_posts/data/models/user_post_model.dart';

abstract class UserPostLocalDataSource {
  //throws [ServerException] exception on error
  Future<List<UserPostModel>> getUserPost();
  // throws [ServerException] exception on error
  Future<UserPostModel> getUserPostById(int id);
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
}
