import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/register/cubit/states.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';

class RegisterCubit extends Cubit<RegisterCubitStates> {
  RegisterCubit() : super(RegisterInitState());

  static RegisterCubit get(BuildContext context) => BlocProvider.of(context);

  void userRegister ({
    String name,
    @required String email,
    String phone,
    @required String password
}) {
    UserModel userModel = UserModel() ;
    emit(RegisterLoadingState());
    FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password
    ).then((value) {
      createUser(
        name: name,
        email: email,
        phone: phone,
        uid: value.user.uid
      );
      //token = value.credential.token;
      //print(token.toString());
      emit(RegisterSuccessState());
    }).catchError((error){
      emit(RegisterErrorState());
    });
  }

  void createUser({
  @required String name,
    @required String email,
    @required String phone,
    @required String uid,
    String profile,
    String cover,
    String bio
}){
    UserModel userModel = UserModel(
      name: name,
      email: email,
      phone: phone,
      uid: uid,
      bio: bio??"Write your Bio ...",
      coverImage: cover??"https://image.freepik.com/free-photo/woman-hand-blue-sweater-breaking-through-paper-wall-pointing-copy-space_273609-46465.jpg" ,
      profileImage: profile??"https://image.freepik.com/free-vector/hacker-realistic-composition_98292-38.jpg?1"
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set(userModel.toMap())
        .then((value) {
          CacheHelper.clearData(key: 'uid').then((value) {
            uid = userModel.uid;
            CacheHelper.setData(key: 'uid', value: uid);
          });
          emit(RegisterCreateUserSuccessState(uid));

    }).catchError((error){
      print(error);
      emit(RegisterCreateUserErrorState());
    });
  }

  IconData suffix = Icons.visibility;
  bool isPass = true;
  void changePassVisibility() {
    isPass = !isPass;

    isPass ? suffix = Icons.visibility : suffix = Icons.visibility_off;
    emit(RegisterChangePassVisibility());
  }
}
