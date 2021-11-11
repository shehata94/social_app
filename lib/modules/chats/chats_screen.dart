import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/shared/components/components.dart';

class ChatsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = HomeCubit.get(context);
        return cubit.users.length > 0
            ? Padding(
                padding: const EdgeInsets.all(15.0),
                child: ListView.separated(
                  itemBuilder: (context, index) => userItem(context, cubit.users[index]),
                  separatorBuilder: (context, index) => divider(),
                  itemCount: cubit.users.length,
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }

  Widget userItem(context, UserModel model) => Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(model.profileImage),
          ),
          SizedBox(
            width: 20,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                model.name,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ],
          ),
        ],
      );
}
