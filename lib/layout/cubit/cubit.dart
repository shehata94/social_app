
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/chats/chats_screen.dart';
import 'package:social_app/modules/home/home_screen.dart';
import 'package:social_app/modules/posts/posts_screen.dart';
import 'package:social_app/modules/settings/settings_screen.dart';
import 'package:social_app/modules/users/users_screen.dart';
import 'package:social_app/shared/components/constants.dart';

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

  UserModel userModel;
  void getUserData(){
    emit(HomeGetUserLoadingState());

    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((value){
          emit(HomeGetUserSuccessState());
         userModel = UserModel.fromJson(value.data());
         print(userModel.toMap());

    }).catchError((error){
      emit(HomeGetUserErrorState());

    });
  }




}