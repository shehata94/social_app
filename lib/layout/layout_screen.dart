

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/modules/posts/posts_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class LayoutScreen extends StatelessWidget {
  final String uid;

  const LayoutScreen({Key key, this.uid}) : super(key: key);
  @override
  Widget build(BuildContext context) {
        return Builder(
          builder: (context) {
            var cubit =HomeCubit.get(context);
            cubit.getUserData(uid);
            cubit.getAllUsers(uid);
            return BlocConsumer<HomeCubit, HomeStates>(
              listener: (context, state){
                if(state is HomePostsScreenState)
                {
                  navigateTo(context, PostsScreen());
                }
              },
              builder: (context, state){
                return Scaffold(
                    appBar: AppBar(
                      title: Text(
                        'Home',
                        style: Theme.of(context).textTheme.headline6.copyWith(fontWeight: FontWeight.bold),
                      ),
                      actions: [
                        IconButton(onPressed: () {}, icon: Icon(IconBroken.Notification)),
                        IconButton(onPressed: () {}, icon: Icon(IconBroken.Search)),
                      ],
                    ),
                    bottomNavigationBar: BottomNavigationBar(
                      currentIndex: cubit.currentIndex,
                      onTap: (index){
                        cubit.changeBotNavBar(index);
                      },
                      items: [
                        BottomNavigationBarItem(icon: Icon(IconBroken.Home),label: "Home"),
                        BottomNavigationBarItem(icon: Icon(IconBroken.Chat),label: "Chats"),
                        BottomNavigationBarItem(icon: Icon(IconBroken.Arrow___Up_Square),label: "Post"),
                        BottomNavigationBarItem(icon: Icon(IconBroken.User),label: "Users"),
                        BottomNavigationBarItem(icon: Icon(IconBroken.Setting),label: "Settings"),
                      ],
                    ),
                    body: cubit.screens[cubit.currentIndex]
                );
              },

            );
          },
        );
      }

}
