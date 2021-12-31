import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_posts/domain/entities/user_post_entity.dart';
import 'package:my_posts/presentation/cubit/userpost_cubit.dart';

class UserPostAddEdit extends StatefulWidget {
  final UserPostEntity? userPostEntity;
  final bool isEdit;
  const UserPostAddEdit({this.userPostEntity, required this.isEdit, Key? key})
      : super(key: key);

  @override
  _UserPostAddEditState createState() => _UserPostAddEditState();
}

class _UserPostAddEditState extends State<UserPostAddEdit> {
  var controllerTitle = TextEditingController();
  var controllerDescription = TextEditingController();
  var controllerUserId = TextEditingController();

  late UserPostCubit userPostCubit;
  var isSuccess = false;
  final formState = GlobalKey<FormState>();
  @override
  void initState() {
    if (widget.isEdit) {
      controllerUserId.text = widget.userPostEntity!.userId.toString();
      controllerTitle.text = widget.userPostEntity!.title;
      controllerDescription.text = widget.userPostEntity!.body;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    userPostCubit = BlocProvider.of<UserPostCubit>(context);
    return WillPopScope(
        onWillPop: () async {
          if (isSuccess) {
            Navigator.pop(context, true);
          } else {
            Navigator.pop(context, false);
          }
          return true;
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text(
                  widget.userPostEntity == null ? 'New Post' : 'Edit Post'),
            ),
            body: BlocConsumer<UserPostCubit, UserPostState>(
              bloc: userPostCubit,
              listener: (_, state) {
                if (state is UserPostAdded) {
                  isSuccess = true;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'UserPost \'${state.addedUserPost.title}\' added successfully'),
                    ),
                  );
                  Navigator.pop(context, true);
                } else if (state is UserPostUpdated) {
                  isSuccess = true;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'UserPost \'${state.updatedUserPost.title}\' updated successfully'),
                    ),
                  );
                  Navigator.pop(context, true);
                } else if (state is UserPostAddFailed) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                    ),
                  );
                } else if (state is UserPostUpdateFailed) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                    ),
                  );
                }
              },
              builder: (context, state) {
                return _buildWidgetForm();
              },
            )));
  }

  Widget _buildWidgetForm() {
    return Form(
      key: formState,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            //mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: controllerUserId,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'User id'),
                validator: (value) {
                  return value == null || value.isEmpty
                      ? 'Enter user id'
                      : null;
                },
              ),
              TextFormField(
                autocorrect: false,
                maxLength: 20,
                controller: controllerTitle,
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
                validator: (value) {
                  return value == null || value.isEmpty ? 'Enter title' : null;
                },
              ),
              TextFormField(
                autocorrect: false,
                maxLength: 100,
                controller: controllerDescription,
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
                validator: (value) {
                  return value == null || value.isEmpty
                      ? 'Enter description'
                      : null;
                },
              ),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    child: Text(widget.isEdit ? 'UPDATE' : 'SUBMIT'),
                    onPressed: () {
                      if (formState.currentState!.validate()) {
                        {
                          var userId = controllerUserId.text.trim();
                          var title = controllerTitle.text.trim();
                          var description = controllerDescription.text.trim();
                          if (widget.isEdit) {
                            var userPostEntity = UserPostEntity(
                              id: widget.userPostEntity!.id,
                              userId: int.parse(userId),
                              title: title,
                              body: description,
                            );
                            userPostCubit.updateUserPost(userPostEntity);
                          } else {
                            var userPostEntity = UserPostEntity(
                                id: 0,
                                userId: int.parse(userId),
                                title: title,
                                body: description);
                            userPostCubit.addUserPost(userPostEntity);
                          }
                        }
                      }
                    }),
              ),
            ]),
      ),
    );
  }
}
