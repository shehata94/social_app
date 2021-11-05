
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/modules/chats/chats_screen.dart';
import 'package:social_app/modules/home/home_screen.dart';
import 'package:social_app/modules/posts/posts_screen.dart';
import 'package:social_app/modules/settings/users_screen.dart';
import 'package:social_app/modules/users/users_screen.dart';

class HomeCubit extends Cubit<HomeStates>{

  HomeCubit() : super(HomeInitState());

  static HomeCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> screens = [
    HomeScreen(),
    ChatsScreen(),
    PostsScreen(),
    UsersScreen(),
    SettingsScreen()
  ];

  void changeBotNavBar(int index){

    currentIndex = index;

    emit(HomeChangeBotNavBar());


  }




}