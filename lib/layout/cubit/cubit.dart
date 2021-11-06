
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/chats/chats_screen.dart';
import 'package:social_app/modules/home/home_screen.dart';
import 'package:social_app/modules/posts/posts_screen.dart';
import 'package:social_app/modules/settings/settings_screen.dart';
import 'package:social_app/modules/users/users_screen.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

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
         userModel = UserModel.fromJson(value.data());
         print(userModel.toMap());
         emit(HomeGetUserSuccessState());

    }).catchError((error){
      emit(HomeGetUserErrorState());

    });
  }

  File coverImage;
  File profileImage;

  final picker = ImagePicker();

  Future<void> getCoverImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        coverImage = File(pickedFile.path);
        emit(HomeGetCoverImageSuccessState());
      } else {
        print('No image selected.');
        emit(HomeGetCoverImageErrorState());
      }
  }

  Future<void> getProfileImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(HomeGetProfileImageSuccessState());

    } else {
      print('No image selected.');
      emit(HomeGetProfileImageErrorState());

    }
  }
  String newCoverImageURL;
  String newProfileImageURL;

  void updateUserData({
    final String name,
    final String phone,
    final String bio,
}){
    emit(HomeUpdateUserDataLoadingState());

    uploadAll().then((value) {
       userModel = UserModel(
        name: name,
        email: userModel.email,
        phone: phone,
        bio:bio,
        uid: userModel.uid,
        coverImage: newCoverImageURL??userModel.coverImage,
        profileImage: newProfileImageURL??userModel.profileImage,
      );

      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update(userModel.toMap())
          .then((value) {
            getUserData();
        emit(HomeUpdateUserDataSuccessState());

      }).catchError((error){
        emit(HomeUpdateUserDataErrorState());
      });
    });

  }





  Future<String> uploadImage (File image){
    return firebase_storage.FirebaseStorage.instance
        .ref('users/${image.uri.pathSegments.last}')
        .putFile(image)
        .then((value) {
       return value.ref.getDownloadURL();
    }).catchError((error){
       emit(HomeUploadImageErrorState());
    });
  }

  Future<void>  uploadAll() async{

    if(coverImage != null)
    {
      uploadImage(coverImage).then((value) {
        newCoverImageURL = value;
        emit(HomeUploadImageSuccessState());
      }).catchError((error){
        emit(HomeUploadThenGetURLImageErrorState());
      });
    }
    if(profileImage != null)
    {
      uploadImage(profileImage).then((value) {
        newProfileImageURL = value;
        emit(HomeUploadImageSuccessState());
      }).catchError((error){
        emit(HomeUploadThenGetURLImageErrorState());
      });;
    }
  }


}