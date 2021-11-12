import 'dart:io';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/models/comment_model.dart';
import 'package:social_app/models/message_model.dart';
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

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitState());

  static HomeCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> screens = [HomeScreen(), ChatsScreen(), PostsScreen(), UsersScreen(), SettingsScreen()];

  void changeBotNavBar(int index) {
    if (index == 2) {
      emit(HomePostsScreenState());
    } else {

      currentIndex = index;
      emit(HomeChangeBotNavBar());
    }
  }

  UserModel userModel;

  void getUserData(String uid) {
    emit(HomeGetUserLoadingState());

    FirebaseFirestore.instance.collection('users').doc(uid).get().then((value) {
      userModel = UserModel.fromJson(value.data());
      emit(HomeGetUserSuccessState());
    }).catchError((error) {
      print(error);
      emit(HomeGetUserErrorState());
    });
  }

  Future<UserModel> getUserDataById(String uid) async {
    UserModel model;
    emit(HomeGetUserLoadingState());

    await FirebaseFirestore.instance.collection('users').doc(uid).get().then((value) {
      model = UserModel.fromJson(value.data());
      emit(HomeGetUserSuccessState());
    }).catchError((error) {
      emit(HomeGetUserErrorState());
    });
    return model;
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

  Future<void> updateUserData({String name, String phone, String bio, String cover, String profile}) async {
    userModel = UserModel(
        name: name,
        email: userModel.email,
        phone: phone,
        bio: bio,
        uid: userModel.uid,
        coverImage: cover ?? userModel.coverImage,
        profileImage: profile ?? userModel.profileImage);

    await FirebaseFirestore.instance.collection('users').doc(userModel.uid).update(userModel.toMap()).then((value) {
      emit(HomeUpdateUserDataSuccessState());
    }).catchError((error) {
      emit(HomeUpdateUserDataErrorState());
    });
  }

  Future<String> uploadImage(File image) {
    return firebase_storage.FirebaseStorage.instance.ref('users/${image.uri.pathSegments.last}').putFile(image).then((value) {
      return value.ref.getDownloadURL();
    }).catchError((error) {
      emit(HomeUploadImageErrorState());
    });
  }

  String newCoverURL;
  String newProfileURL;

  Future<void> uploadImagesAndData({
    String name,
    String phone,
    String bio,
  }) async {
    emit(HomeUpdateUserDataLoadingState());

    if (coverImage != null) {
      await uploadImage(coverImage).then((value) {
        newCoverURL = value;
        updateUserData(name: name, phone: phone, bio: bio, cover: newCoverURL, profile: newProfileURL)
            .then((value) => updateUserModelInPosts().then((value) {
                  getUserData(userModel.uid);
                  getPosts();
                }));
      }).catchError((error) {
        emit(HomeUploadThenGetURLImageErrorState());
      });
    }
    if (profileImage != null) {
      await uploadImage(profileImage).then((value) {
        newProfileURL = value;
        updateUserData(name: name, phone: phone, bio: bio, cover: newCoverURL, profile: newProfileURL)
            .then((value) => updateUserModelInPosts().then((value) {
                  getUserData(userModel.uid);
                  getPosts();
                }));
      }).catchError((error) {
        emit(HomeUploadThenGetURLImageErrorState());
      });
    }
    if (profileImage == null && coverImage == null) {
      await updateUserData(
        name: name,
        phone: phone,
        bio: bio,
      ).then((value) => updateUserModelInPosts().then((value) {
            getUserData(userModel.uid);
            getPosts();
          }));
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

  void removePostImage() {
    postImage = null;
    emit(PostRemoveImageState());
  }

  String newPostImageURL;

  Future<String> uploadPostImage() {
    return firebase_storage.FirebaseStorage.instance.ref('posts/${postImage.uri.pathSegments.last}').putFile(postImage).then((value) {
      emit(PostUploadImageSuccessState());
      return value.ref.getDownloadURL();
    }).catchError((error) {
      emit(PostUploadImageErrorState());
    });
  }

  PostModel postModel;

  Future<void> createPost({String postText, UserModel userModel, String date}) async {
    emit(PostCreatePostLoadingState());

    if (postImage != null) {
      await uploadPostImage().then((value) {
        postModel = PostModel(date: date, userModel: userModel, postText: postText, postImage: value ?? '');

        FirebaseFirestore.instance.collection('posts').doc().set(postModel.toMap(userModel)).then((value) {
          emit(PostCreatePostSuccessState());
        }).catchError((error) {
          emit(PostCreatePostErrorState());
        });
      });
    } else {
      postModel = PostModel(
        date: date,
        userModel: userModel,
        postText: postText,
      );

      await FirebaseFirestore.instance.collection('posts').doc().set(postModel.toMap(userModel)).then((value) {
        emit(PostCreatePostSuccessState());
      }).catchError((error) {
        emit(PostCreatePostErrorState());
      });
    }
  }

  //GetPosts
  List<PostModel> posts = [];
  List<String> postId = [];
  List<int> likes = [];
  List<int> comments = [];
  List<bool> isCommentsShown = [];
  List<bool> isLikePressed = [];

  void changeLikeState(int index) {
    isLikePressed[index] = !isLikePressed[index];
    emit(ChangeLikeState());
  }

  void changeCommentsView(bool isShown, int index) {
    isCommentsShown[index] = !isCommentsShown[index];
    emit(ChangeCommentsView());
    print(isCommentsShown);
  }

  void getPosts() {
    posts = [];
    emit(HomeGetPostsLoadingState());

    FirebaseFirestore.instance.collection('posts').get().then((value) {
      value.docs.forEach((element) {
        getLikesAndCommentsCount(element.id).then((value) {
          likes.add(value["numLikes"]);
          comments.add(value["numComments"]);
          isLikePressed.add(value['isLikePressed']);
          isCommentsShown.add(false);

          postId.add(element.id);
          posts.add(PostModel.fromJson(element.data()));
          emit(HomeGetPostsSuccessState());
        }).catchError((error) {});
      });
    }).catchError((error) {
      emit(HomeGetPostsErrorState());
    });
  }

  Future<Map<String, dynamic>> getLikesAndCommentsCount(String postId) async {
    bool likePressed;
    QuerySnapshot likes = await FirebaseFirestore.instance.collection('posts').doc(postId).collection('likes').get();
    QuerySnapshot comments = await FirebaseFirestore.instance.collection('posts').doc(postId).collection('comment').get();
    emit(GetCommentsSuccessState());
    await FirebaseFirestore.instance.collection('posts').doc(postId).collection('likes').get().then((value) {
      value.docs.forEach((element) {
        if (element.id == userModel.uid)
          return likePressed = true;
        else
          return likePressed = false;
      });
    });
    return {"numLikes": likes.docs.length, "numComments": comments.docs.length, "isLikePressed": likePressed};
  }

  List<List<CommentModel>> commentsModel = [[], [], [], []];

  void getComments(String postId, int index) {
    commentsModel = [[], [], []];
    emit(GetCommentsLoadingState());
    FirebaseFirestore.instance.collection('posts').doc(postId).collection('comment').get().then((value) {
      value.docs.forEach((element) {
        commentsModel[index].add(CommentModel.fromJson(element.data()));
        emit(GetCommentsSuccessState());
      });
    }).catchError((error) {
      emit(GetCommentsErrorState());
    });
  }

  Future<void> updateUserModelInPosts() async {
    await FirebaseFirestore.instance.collection('posts').get().then((value) {
      value.docs.forEach((element) {
        if (PostModel.fromJson(element.data()).uid == userModel.uid) {
          element.reference.update({'userModel': userModel.toMap()});
          emit(UpdateUserModelInPostsSuccessState());
        }
      });
    });
  }

//add likes
  void addLike(String postId) {
    FirebaseFirestore.instance.collection('posts').doc(postId).collection('likes').doc(userModel.uid).set({"like": true}).then((value) {
      emit(PostSetLikeSuccessState());
      getLikesAndCommentsCount(postId);
    }).catchError((error) {
      emit(PostSetLikeErrorState());
    });
  }

//add comment
  Future<void> addComment(String postId, String commentText, String date, int index) {
    CommentModel commentModel = CommentModel(userModel: userModel, commentText: commentText, date: date);
    return FirebaseFirestore.instance.collection('posts').doc(postId).collection('comment').doc().set(commentModel.toMap(userModel)).then((value) {
      getLikesAndCommentsCount(postId).then((value) {
        likes[index] = value['numLikes'];
        comments[index] = value['numComments'];
        emit(PostSetLikeSuccessState());
      });
      getComments(postId, index);
      return value;
    }).catchError((error) {
      emit(PostSetLikeErrorState());
    });
  }

  //GetUsers for chats

  List<UserModel> users= [];
  void getAllUsers(String uid) {
    emit(GetAllUsersLoadingState());
    users = [];
    FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((value) {
          value.docs.forEach((element) {
            if(element.id != uid)
            users.add(UserModel.fromJson(element.data()));
            emit(GetAllUsersSuccessState());
          });
    })
        .catchError((error) {
            print(error);
          emit(GetAllUsersErrorState());
    });
  }

  // Create message
void createMessage({String senderUid, String receiverUid,String date, String messageText})  {
    MessageModel model = MessageModel(
      senderUid: senderUid,
      receiverUid: receiverUid,
      date: date,
      messageText: messageText
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(senderUid)
        .collection('messages')
        .doc(receiverUid)
        .collection('content')
        .add(model.toMap())
    .then((value) {
      emit(CreateMessageSuccessState());
    })
    .catchError((error){
      emit(CreateMessageErrorState());
    });

    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverUid)
        .collection('messages')
        .doc(senderUid)
        .collection('content')
        .add(model.toMap())
        .then((value) {
      emit(CreateMessageSuccessState());
    })
        .catchError((error){
      emit(CreateMessageErrorState());
    });
}

// Get messages
List<MessageModel> messages = [];
void getMessages({String receiverUid}){

    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.uid)
        .collection('messages')
        .doc(receiverUid)
        .collection('content')
        .orderBy('date',descending: true)
        .snapshots()
        .listen((event) {
          messages = [];
          event.docs.forEach((element) {
            messages.add(MessageModel.fromJson(element.data()));
          });
          emit(GetMessagesSuccessState());
    });
}
}
