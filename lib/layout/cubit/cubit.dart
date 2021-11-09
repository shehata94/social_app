
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/chats/chats_screen.dart';
import 'package:social_app/modules/home/home_screen.dart';
import 'package:social_app/modules/posts/posts_screen.dart';
import 'package:social_app/modules/settings/settings_screen.dart';
import 'package:social_app/modules/users/users_screen.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:social_app/shared/network/local/cache_helper.dart';

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



    if(index ==2 )
      {
        emit(HomePostsScreenState());
      }else{
      currentIndex = index;
      emit(HomeChangeBotNavBar());
    }


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


  void getUserDataById(String uid){
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

  void updateUserData({
     String name,
     String phone,
     String bio,
     String cover,
     String profile
}){

    userModel = UserModel(
      name: name,
      email: userModel.email,
      phone: phone,
      bio:bio,
      uid: userModel.uid,
      coverImage: cover??userModel.coverImage,
      profileImage: profile??userModel.profileImage
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

  String newCoverURL;
  String newProfileURL;

  void uploadImagesAndData({
    String name,
    String phone,
    String bio,
  }) {
    emit(HomeUpdateUserDataLoadingState());

    if(coverImage != null)
    {
      uploadImage(coverImage).then((value) {
        newCoverURL = value;
        updateUserData(
            name: name,
            phone: phone,
            bio: bio,
            cover: newCoverURL,
            profile: newProfileURL
        );
      }).catchError((error){
        emit(HomeUploadThenGetURLImageErrorState());
      });
    }
    if(profileImage != null)
    {
      uploadImage(profileImage).then((value) {
        newProfileURL =value;
        updateUserData(
            name: name,
            phone: phone,
            bio: bio,
            cover: newCoverURL,
            profile: newProfileURL
        );
      }).catchError((error){
        emit(HomeUploadThenGetURLImageErrorState());
      });
    }
    if(profileImage == null && coverImage == null){
      updateUserData(
          name: name,
          phone: phone,
          bio: bio,
      );
    }
  }

  //CreatePost
  File postImage;


  Future<void> getPostImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(PostGetImageSuccessState());

    } else {
      print('No image selected.');
      emit(PostGetImageErrorState());

    }
  }

  void removePostImage(){
    postImage = null;
    emit(PostRemoveImageState());

  }

  String newPostImageURL;
  Future<String> uploadPostImage() {

     return firebase_storage.FirebaseStorage.instance
        .ref('posts/${postImage.uri.pathSegments.last}')
        .putFile(postImage)
        .then((value) {
       emit(PostUploadImageSuccessState());
        return value.ref.getDownloadURL();
    })
        .catchError((error){
      emit(PostUploadImageErrorState());
    });
  }

  PostModel postModel;

  void createPost({
    String postText,
    UserModel userModel,
    String date
  }){
    emit(PostCreatePostLoadingState());


    if(postImage != null){
      uploadPostImage().then((value) {
        postModel = PostModel(
            name: userModel.name,
            date: date,
            uid: userModel.uid,
            profileImage: userModel.profileImage,
            postText: postText,
            postImage: value??''
        );

        FirebaseFirestore.instance
            .collection('posts')
            .doc()
            .set(postModel.toMap())
            .then((value) {

          emit(PostCreatePostSuccessState());

        }).catchError((error){
          emit(PostCreatePostErrorState());
        });
      });
    }else{
      postModel = PostModel(
          name: userModel.name,
          date: date,
          uid: userModel.uid,
          profileImage: userModel.profileImage,
          postText: postText,
      );

      FirebaseFirestore.instance
          .collection('posts')
          .doc()
          .set(postModel.toMap())
          .then((value) {
        emit(PostCreatePostSuccessState());
      }).catchError((error){
        emit(PostCreatePostErrorState());
      });

    }

  }

  //GetPosts
List<PostModel> posts = [];
void getPosts(){

  emit(HomeGetPostsLoadingState());
    FirebaseFirestore.instance
        .collection('posts')
        .get()
        .then((value) => {
          value.docs.forEach((element) {
            print(PostModel.fromJson(element.data()));
            posts.add(PostModel.fromJson(element.data()));
            emit(HomeGetPostsSuccessState());
          })
    }).catchError((error){
      emit(HomeGetPostsErrorState());
    });
}


}