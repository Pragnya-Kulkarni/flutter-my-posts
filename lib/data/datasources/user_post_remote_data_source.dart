import 'package:my_posts/core/error/exception.dart';
import 'package:my_posts/data/models/user_post_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class UserPostRemoteDataSource {
  //throws [ServerException] exception on error
  Future<List<UserPostModel>> getUserPost();
  // throws [ServerException] exception on error
  Future<UserPostModel> getUserPostById(int id);
}

const String userPostURL = 'https://jsonplaceholder.typicode.com/posts?';

class UserPostRemoteDataImpl implements UserPostRemoteDataSource {
  http.Client client;

  UserPostRemoteDataImpl({required this.client});
  @override
  Future<List<UserPostModel>> getUserPost() async {
    String link = userPostURL;
    final response = await client
        .get(Uri.parse(link), headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      //Creating a list to store input data;
      List<UserPostModel> userPosts = [];
      final responseData = jsonDecode(response.body);
      for (var singlePost in responseData) {
        UserPostModel userPostModel = UserPostModel.fromJson(singlePost);
        //Adding userPost to the list.
        userPosts.add(userPostModel);
      }
      return userPosts;
    } else {
      throw ServerException("Server error occurred");
    }
  }

  @override
  Future<UserPostModel> getUserPostById(int id) async {
    String link = userPostURL + 'id=$id';
    final response = await client
        .get(Uri.parse(link), headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      return UserPostModel.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException("Server error occurred");
    }
  }
}
