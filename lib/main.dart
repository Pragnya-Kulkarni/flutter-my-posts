import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:my_posts/core/network/network_info.dart';
import 'package:my_posts/data/datasources/user_post_local_data_source.dart';
import 'package:my_posts/data/datasources/user_post_remote_data_source.dart';
import 'package:my_posts/data/repositories/user_post_repository_impl.dart';
import 'package:my_posts/domain/usecases/get_user_post_usecase.dart';
import 'package:my_posts/presentation/cubit/userpost_cubit.dart';
import 'package:my_posts/presentation/pages/user_post_initial_page.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Posts',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: BlocProvider(
            create: (context) => UserPostCubit(
                getUserPostUseCase: GetUserPostUseCase(UserPostRepositoryImpl(
                    remoteDataSource:
                        UserPostRemoteDataImpl(client: http.Client()),
                    networkInfo: NetworkInfoImpl(InternetConnectionChecker()),
                    localDataSource: UserPostLocalDataImpl()))),
            child: const UserPostInitialPage()));
  }
}
