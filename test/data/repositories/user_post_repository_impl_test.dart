import 'dart:async';
import 'dart:ffi';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_posts/core/error/exception.dart';
import 'package:my_posts/core/error/failures.dart';
import 'package:my_posts/core/network/network_info.dart';
import 'package:my_posts/data/datasources/user_post_local_data_source.dart';
import 'package:my_posts/data/datasources/user_post_remote_data_source.dart';
import 'package:my_posts/data/models/user_post_model.dart';
import 'package:my_posts/data/repositories/user_post_repository_impl.dart';
import 'package:my_posts/domain/entities/user_post_entity.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';
import 'user_post_repository_impl_test.mocks.dart';

@GenerateMocks([UserPostLocalDataSource])
@GenerateMocks([UserPostRemoteDataSource])
@GenerateMocks([NetworkInfo])
void main() {
  late UserPostRepositoryImpl repository;
  late MockUserPostLocalDataSource mockLocalDataSource;
  late MockUserPostRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockUserPostRemoteDataSource();
    mockLocalDataSource = MockUserPostLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = UserPostRepositoryImpl(
        remoteDataSource: mockRemoteDataSource,
        networkInfo: mockNetworkInfo,
        localDataSource: mockLocalDataSource);
  });

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      body();
    });
  }

  group('device is offline', () {
    setUp(() {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
    });

    test(
      'should return cache failure when device is offline ',
      () async {
        //arrange
        when(mockLocalDataSource.getUserPost()).thenThrow(CacheException());

        //act
        final result = await repository.getUserPosts();

        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getUserPost());
        expect(result, equals(Left(CacheFailure())));
      },
    );
  });

  group('get user posts', () {
    final List<UserPostModel> tUserPost = [
      const UserPostModel(
          userId: 1, id: 2, title: 'title1', body: 'description')
    ];
    final List<UserPostEntity> tUserPostEntity = tUserPost;
    test(
      'should check if device is online',
      () async {
        //arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(mockRemoteDataSource.getUserPost())
            .thenAnswer((_) => Future<List<UserPostModel>>.value(tUserPost));
        //act
        repository.getUserPosts();

        //assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    runTestsOnline(() {
      test(
        'should return remote data when the call to remote data source is success',
        () async {
          //arrange
          when(mockRemoteDataSource.getUserPost())
              .thenAnswer((_) async => tUserPost);

          //act
          final result = await repository.getUserPosts();

          verify(mockRemoteDataSource.getUserPost());
          expect(result, equals(Right(tUserPostEntity)));
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          //arrange
          when(mockRemoteDataSource.getUserPost())
              .thenThrow(ServerException("Server error occurred"));

          //act
          final result = await repository.getUserPosts();

          verify(mockRemoteDataSource.getUserPost());
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });
  });

  group('add user posts', () {
    final List<UserPostModel> tUserPost = [
      const UserPostModel(
          userId: 1, id: 2, title: 'title1', body: 'description')
    ];
    final List<UserPostEntity> tUserPostEntity = tUserPost;
    runTestsOnline(() {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      test(
        'should add remote data when remote add is successful',
        () async {
          //arrange
          when(mockRemoteDataSource.addUserPost(tUserPost[0]))
              .thenAnswer((_) async {
            return tUserPost[0];
          });

          //act
          final result = await repository.addUserPost(tUserPostEntity[0]);

          verify(mockRemoteDataSource.addUserPost(tUserPost[0]));
          expect(result, equals(Right(tUserPostEntity[0])));
        },
      );

      test(
        'should throw server exception when remote add is unsuccessful',
        () async {
          //arrange
          when(mockRemoteDataSource.addUserPost(tUserPost[0]))
              .thenThrow(ServerException("Server error occurred"));

          //act
          final result = await repository.addUserPost(tUserPostEntity[0]);

          verify(mockRemoteDataSource.addUserPost(tUserPost[0]));
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });
  });

  group('update user posts', () {
    final List<UserPostModel> tUserPost = [
      const UserPostModel(
          userId: 1, id: 2, title: 'title1', body: 'description')
    ];
    final List<UserPostEntity> tUserPostEntity = tUserPost;
    int deleteId = 1;
    runTestsOnline(() {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      test(
        'should update remote data when remote update is successful',
        () async {
          //arrange
          when(mockRemoteDataSource.updateUserPost(tUserPost[0]))
              .thenAnswer((_) async {
            return tUserPost[0];
          });

          //act
          final result = await repository.updateUserPost(tUserPostEntity[0]);

          verify(mockRemoteDataSource.updateUserPost(tUserPost[0]));
          expect(result, equals(Right(tUserPostEntity[0])));
        },
      );

      test(
        'should throw server exception when remote update is unsuccessful',
        () async {
          //arrange
          when(mockRemoteDataSource.updateUserPost(tUserPost[0]))
              .thenThrow(ServerException("Server error occurred"));

          //act
          final result = await repository.updateUserPost(tUserPostEntity[0]);

          verify(mockRemoteDataSource.updateUserPost(tUserPost[0]));
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });
  });

  group('delete user posts', () {
    int deleteId = 1;
    runTestsOnline(() {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      test(
        'should delete remote data when delete is successful',
        () async {
          //arrange
          when(mockRemoteDataSource.deleteUserPostById(deleteId))
              .thenAnswer((_) async {
            return;
          });

          //act
          final result = await repository.deleteUserPostsById(deleteId);

          verify(mockRemoteDataSource.deleteUserPostById(deleteId));
          expect(result, equals(const Right(null)));
        },
      );

      test(
        'should throw server exception when delete is unsuccessful',
        () async {
          //arrange
          when(mockRemoteDataSource.deleteUserPostById(deleteId))
              .thenThrow(ServerException("Server error occurred"));

          //act
          final result = await repository.deleteUserPostsById(deleteId);

          verify(mockRemoteDataSource.deleteUserPostById(deleteId));
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });
  });
}
