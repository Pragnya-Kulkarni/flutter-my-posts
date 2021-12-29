import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_posts/presentation/cubit/userpost_cubit.dart';
import 'package:my_posts/presentation/pages/user_post_list.dart';

class UserPostInitialPage extends StatefulWidget {
  const UserPostInitialPage({Key? key}) : super(key: key);

  @override
  _UserPostInitialPageState createState() => _UserPostInitialPageState();
}

class _UserPostInitialPageState extends State<UserPostInitialPage> {
  @override
  void initState() {
    super.initState();
    loadUserPost();
  }

  void loadUserPost() {
    setState(() {
      BlocProvider.of<UserPostCubit>(context).getUserPost();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Posts"),
      ),
      body: Center(
        child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            alignment: Alignment.center,
            child: BlocConsumer<UserPostCubit, UserPostState>(
                listener: (ctx, state) {
              if (state is UserPostError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                  ),
                );
              }
            }, builder: (ctx, state) {
              if (state is UserPostLoaded) {
                return UserPostList(lstUserPost: state.lstUserPost);
              } else if (state is UserPostError) {
                return Center(child: Text(state.message));
              } else {
                return CircularProgressIndicator();
              }
            })),
      ),
    ); // Thi
  }
}
