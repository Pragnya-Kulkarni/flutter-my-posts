import 'dart:collection';
import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:my_posts/core/error/exception.dart';
import 'package:http/http.dart' as http;
import 'package:my_posts/data/datasources/user_post_remote_data_source.dart';
import 'package:my_posts/data/models/user_post_model.dart';

import '../../fixtures/fixture_reader.dart';
import 'user_post_remote_data_source_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late UserPostRemoteDataImpl dataSource;
  late MockClient mockHttpClient;
  const String userPostURL = 'https://jsonplaceholder.typicode.com/posts/';
  setUp(() {
    mockHttpClient = MockClient();
    dataSource = UserPostRemoteDataImpl(client: mockHttpClient);
  });

  void setUpMockHttpClientSuccess200() {
    //arrange
    when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (_) async => http.Response(fixture('list_user_post.json'), 200));
  }

  void setUpMockHttpClientFailure404() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  group('getUserPost', () {
    List<UserPostModel> userPosts = [];
    final responseData = jsonDecode(fixture('list_user_post.json'));
    for (var singlePost in responseData) {
      UserPostModel userPostModel = UserPostModel.fromJson(singlePost);
      //Adding userPost to the list.
      userPosts.add(userPostModel);
    }

    test(
      'should perform a GET request on a URL with application/json header',
      () async {
        //arrange
        setUpMockHttpClientSuccess200();
        //act
        dataSource.getUserPost();
        //assert
        verify(mockHttpClient.get(Uri.parse(userPostURL),
            headers: {'Content-Type': 'application/json'}));
      },
    );

    test('should return user post when response code is 200 (success)',
        () async {
      //arrange
      setUpMockHttpClientSuccess200();
      //act
      final result = await dataSource.getUserPost();
      //assert
      expect(result, equals(userPosts));
    });

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        setUpMockHttpClientFailure404();
        // act
        final call = dataSource.getUserPost;
        // assert
        expect(() => call(), throwsA(TypeMatcher<ServerException>()));
      },
    );
  });

  group('addUserPost', () {
    List<UserPostModel> userPosts = [];
    final responseData = jsonDecode(fixture('list_user_post.json'));
    for (var singlePost in responseData) {
      UserPostModel userPostModel = UserPostModel.fromJson(singlePost);
      //Adding userPost to the list.
      userPosts.add(userPostModel);
    }

    test(
      'should perform a POST request on a URL with application/json header',
      () async {
        //arrange
        //arrange
        when(mockHttpClient.post(any,
                headers: anyNamed('headers'), body: anyNamed('body')))
            .thenAnswer(
                (_) async => http.Response(fixture('user_post.json'), 201));
        //act
        dataSource.addUserPost(userPosts[0]);

        //assert
        verify(mockHttpClient.post(Uri.parse(userPostURL),
            headers: {'Content-type': 'application/json; charset=UTF-8'},
            body: jsonEncode(userPosts[0].toJson())));
      },
    );
    test('should add user post when response code is 201', () async {
      //arrange
      when(mockHttpClient.post(any,
              headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer(
              (_) async => http.Response(fixture('user_post.json'), 201));
      //act
      final result = await dataSource.addUserPost(userPosts[0]);
      //assert
      expect(result, equals(userPosts[0]));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.post(any,
              headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response('Something went wrong', 404));
      // act
      final call = dataSource.addUserPost;
      // assert
      expect(() => call(userPosts[0]), throwsA(TypeMatcher<ServerException>()));
    });
  });

  group('updateUserPost', () {
    final responseData = jsonDecode(fixture('user_post.json'));
    UserPostModel userPostModel = UserPostModel.fromJson(responseData);
    test(
      'should perform a PUT request on a URL with application/json header',
      () async {
        //arrange
        when(mockHttpClient.put(any,
                headers: anyNamed('headers'), body: anyNamed('body')))
            .thenAnswer(
                (_) async => http.Response(fixture('user_post.json'), 200));
        //act
        dataSource.updateUserPost(userPostModel);

        //assert
        verify(mockHttpClient.put(
            Uri.parse(userPostURL + "/${userPostModel.id}"),
            headers: {'Content-type': 'application/json; charset=UTF-8'},
            body: jsonEncode(userPostModel.toJson())));
      },
    );
    test('should update user post when response code is 200', () async {
      //arrange
      when(mockHttpClient.put(any,
              headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer(
              (_) async => http.Response(fixture('user_post.json'), 200));
      //act
      final result = await dataSource.updateUserPost(userPostModel);
      //assert
      expect(result, equals(userPostModel));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.put(any,
              headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response('Something went wrong', 404));
      // act
      final call = dataSource.updateUserPost;
      // assert
      expect(
          () => call(userPostModel), throwsA(TypeMatcher<ServerException>()));
    });
  });

  group('deleteUserPost', () {
    final responseData = jsonDecode(fixture('user_post.json'));
    UserPostModel userPostModel = UserPostModel.fromJson(responseData);
    test(
      'should perform a DELETE request on a URL with application/json header',
      () async {
        //arrange
        when(mockHttpClient.delete(any, headers: anyNamed('headers')))
            .thenAnswer(
                (_) async => http.Response('Deleted Successfully', 200));
        //act
        final result = await dataSource.deleteUserPostById(userPostModel.id);
        int id = userPostModel.id;
        String link = userPostURL + 'id=$id';
        //assert
        verify(mockHttpClient.delete(
          Uri.parse(link),
          headers: {'Content-Type': 'application/json'},
        )).called(1);
      },
    );
    test('should delete user post when response code is 200', () async {
      //arrange
      when(mockHttpClient.delete(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('Deleted Successfully', 200));
      // act
      final call = await dataSource.deleteUserPostById(userPostModel.id);
      //TODO:  below line is throwing error
      //verify(dataSource.deleteUserPostById(userPostModel.id));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.delete(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('Something went wrong', 404));
      // act
      final call = dataSource.deleteUserPostById;
      // assert
      expect(() => call(userPostModel.id),
          throwsA(TypeMatcher<ServerException>()));
    });
  });
}
