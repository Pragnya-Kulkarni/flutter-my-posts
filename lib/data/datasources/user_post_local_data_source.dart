import 'package:my_posts/core/error/exception.dart';
import 'package:my_posts/core/error/failures.dart';
import 'package:my_posts/data/models/user_post_model.dart';

abstract class UserPostLocalDataSource {
  Future<List<UserPostModel>> getUserPost();

  Future<UserPostModel> getUserPostById(int id);

  Future<void> deleteUserPostById(int id);

  Future<UserPostModel> addUserPost(UserPostModel userPostModel);

  Future<UserPostModel> updateUserPost(UserPostModel userPostModel);
}

class UserPostLocalDataImpl implements UserPostLocalDataSource {
  @override
  Future<List<UserPostModel>> getUserPost() {
    throw CacheException();
  }

  @override
  Future<UserPostModel> getUserPostById(int id) {
    throw CacheException();
  }

  @override
  Future<void> deleteUserPostById(int id) {
    throw CacheException();
  }

  @override
  Future<UserPostModel> addUserPost(UserPostModel userPostModel) {
    throw CacheException();
  }

  @override
  Future<UserPostModel> updateUserPost(UserPostModel userPostModel) {
    throw CacheException();
  }
}
