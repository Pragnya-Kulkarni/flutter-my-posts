import 'package:flutter/material.dart';
import 'package:my_posts/domain/entities/user_post_entity.dart';

class UserPostList extends StatefulWidget {
  List<UserPostEntity> lstUserPost;
  UserPostList({Key? key, required this.lstUserPost}) : super(key: key);
  @override
  _UserPostListState createState() => _UserPostListState();
}

class _UserPostListState extends State<UserPostList> {
  @override
  Widget build(BuildContext context) {
    var lstUserPost = widget.lstUserPost;
    return SafeArea(
      child: Container(
          padding: EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: lstUserPost.length,
            itemBuilder: (ctx, index) => Dismissible(
              direction: DismissDirection.endToStart,
              confirmDismiss: (direction) {
                return showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                            title: Text("Please confirm"),
                            content: Text("Are you sure you want to delete?"),
                            actions: [
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(ctx).pop(false);
                                  },
                                  child: Text("Cancel")),
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(ctx).pop(true);
                                  },
                                  child: Text("Delete"))
                            ]));
              },
              onDismissed: (DismissDirection direction) {
                if (direction == DismissDirection.endToStart) {
                  lstUserPost.removeAt(index);
                  ScaffoldMessenger.of(context).showSnackBar(
                      new SnackBar(content: new Text("Item dismissed")));
                }
              },
              key: ValueKey(lstUserPost[index].id.toString()),
              background: Container(
                  color: Colors.redAccent,
                  margin: EdgeInsets.all(8.0),
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: 40,
                  )),
              child: Card(
                elevation: 8,
                margin: EdgeInsets.all(8.0),
                color: Colors.lightBlue.shade100,
                child: ListTile(
                  title: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text(lstUserPost[index].id.toString()),
                          margin: EdgeInsets.only(left: 2, right: 8),
                        ),
                        Expanded(
                            flex: 2,
                            child: Container(
                                child: Text(lstUserPost[index].title))),
                      ]),
                  subtitle: Container(
                      margin: EdgeInsets.all(5.0),
                      child: Text(lstUserPost[index].body)),
                  // contentPadding: EdgeInsets.only(bottom: 20.0),
                ),
              ),
            ),
          )),
    );
  }
}
