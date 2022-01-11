import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:my_posts/data/models/user_post_model.dart';
import 'package:my_posts/domain/entities/user_post_entity.dart';

import '../../fixtures/fixture_reader.dart';

void main() {
  final tUserPostModel = UserPostModel(
      id: 1,
      userId: 1,
      title: 'testTitle',
      body: "test description\nreprehenderit molestiae ut ut quas totam\n");

  test('should be subclass of UserPost entity', () async {
//assert
    expect(tUserPostModel, isA<UserPostEntity>());
  });

  group('fromJson', () {
    test(
      'should return a valid model',
      () async {
        //arrange
        final Map<String, dynamic> jsonMap =
            jsonDecode(fixture('user_post.json'));
        //act
        final result = UserPostModel.fromJson(jsonMap);
        //assert
        expect(result, tUserPostModel);
      },
    );
  });

  group('toJson', () {
    test(
      'should return a json map containing proper data',
      () async {
        final result = tUserPostModel.toJson();

        expect(result, {
          "userId": 1,
          "id": 1,
          "title": "testTitle",
          "body": "test description\nreprehenderit molestiae ut ut quas totam\n"
        });
      },
    );
  });
}
