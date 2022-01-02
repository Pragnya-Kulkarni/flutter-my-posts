import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_posts/domain/entities/user_post_entity.dart';
import 'package:my_posts/presentation/cubit/userpost_cubit.dart';
import 'package:my_posts/presentation/pages/user_post_add_edit.dart';
import 'package:page_transition/page_transition.dart';
import '../../injection_container.dart';

class UserPostInitialPage extends StatefulWidget {
  const UserPostInitialPage({Key? key}) : super(key: key);

  @override
  _UserPostInitialPageState createState() => _UserPostInitialPageState();
}

class _UserPostInitialPageState extends State<UserPostInitialPage> {
  late UserPostCubit userPostCubit;
  @override
  void initState() {
    userPostCubit = sl<UserPostCubit>();
    userPostCubit.getUserPost();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("My Posts"),
          actions: [
            IconButton(
              onPressed: () async {
                var result = await Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.bottomToTop,
                        child: addEditPage(null),
                        ctx: context));
                if (result != null) {
                  userPostCubit.getUserPost();
                }
              },
              icon: const Icon(Icons.add),
              iconSize: 30,
            )
          ],
        ),
        body: BlocProvider<UserPostCubit>(
            create: (_) => userPostCubit,
            child: BlocListener<UserPostCubit, UserPostState>(listener:
                (_, state) {
              if (state is UserPostLoadFailed) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                  ),
                );
              } else if (state is UserPostDeleteFailed) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                  ),
                );
              } else if (state is UserPostDeleted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("User Post deleted Successfully"),
                  ),
                );
              }
              // }
            }, child:
                BlocBuilder<UserPostCubit, UserPostState>(builder: (_, state) {
              if (state is UserPostLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is UserPostLoadFailed) {
                return Center(child: Text(state.message));
              } else if (state is UserPostDeleteFailed) {
                return Center(child: Text(state.message));
              } else if (state is UserPostLoaded) {
                var lstUserPost = state.lstUserPost;
                return Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    alignment: Alignment.center,
                    child: SafeArea(
                      child: Container(
                          padding: const EdgeInsets.all(16.0),
                          child: ListView.builder(
                            itemCount: lstUserPost.length,
                            itemBuilder: (ctx, index) => Dismissible(
                              direction: DismissDirection.horizontal,
                              confirmDismiss: (direction) {
                                return showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                            title: const Text("Please confirm"),
                                            content: const Text(
                                                "Are you sure you want to delete?"),
                                            actions: [
                                              ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.of(ctx)
                                                        .pop(false);
                                                  },
                                                  child: const Text("Cancel")),
                                              ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.of(ctx).pop(true);
                                                  },
                                                  child: const Text("Delete"))
                                            ]));
                              },
                              onDismissed: (DismissDirection direction) {
                                userPostCubit
                                    .deleteUserPost(lstUserPost[index].id);
                                lstUserPost.removeAt(index);
                              },
                              key: ValueKey(lstUserPost[index].id.toString()),
                              background: Container(
                                  color: Colors.redAccent,
                                  margin: const EdgeInsets.all(8.0),
                                  padding: const EdgeInsets.all(8.0),
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                    size: 40,
                                  )),
                              child: Card(
                                elevation: 8,
                                margin: const EdgeInsets.all(8.0),
                                color: Colors.lightBlue.shade100,
                                child: ListTile(
                                  title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              child: const Text('Id: ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              margin: const EdgeInsets.only(
                                                  left: 2, right: 2),
                                            ),
                                            Expanded(
                                              child: Container(
                                                child: Text(lstUserPost[index]
                                                    .id
                                                    .toString()),
                                                margin: const EdgeInsets.only(
                                                    left: 15),
                                              ),
                                            ),
                                            Container(
                                              child: const Text('User Id: ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              margin: const EdgeInsets.only(
                                                  left: 2, right: 2),
                                            ),
                                            Expanded(
                                              child: Container(
                                                child: Text(lstUserPost[index]
                                                    .userId
                                                    .toString()),
                                                margin: const EdgeInsets.only(
                                                    left: 15),
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.topRight,
                                              child: IconButton(
                                                icon: const Icon(Icons.edit),
                                                onPressed: () async {
                                                  var result = await Navigator.push(
                                                      context,
                                                      PageTransition(
                                                          type:
                                                              PageTransitionType
                                                                  .leftToRight,
                                                          child: addEditPage(
                                                              lstUserPost[
                                                                  index]),
                                                          ctx: context));
                                                  if (result != null) {
                                                    userPostCubit.getUserPost();
                                                  }
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              child: const Text(
                                                'title: ',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              margin: const EdgeInsets.only(
                                                  left: 2, right: 2),
                                            ),
                                            Expanded(
                                                flex: 2,
                                                child: Container(
                                                  child: Text(
                                                      lstUserPost[index].title),
                                                  margin: const EdgeInsets.only(
                                                      bottom: 10),
                                                )),
                                          ],
                                        ),
                                      ]),
                                  subtitle: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: const Text('Description: ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        margin: const EdgeInsets.only(
                                            left: 2.0, top: 4),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.all(4.0),
                                        child: Text(
                                          lstUserPost[index].body,
                                          style: const TextStyle(
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )),
                    ));
              } else {
                return Container();
              }
            }))));
  }

  Widget addEditPage(UserPostEntity? userPostEntity) {
    bool isEdit = userPostEntity != null;
    return BlocProvider.value(
        value: userPostCubit,
        child: UserPostAddEdit(isEdit: isEdit, userPostEntity: userPostEntity));

    //);
  }
}
