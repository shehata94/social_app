import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/register/cubit/states.dart';

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
}){
    UserModel userModel = UserModel(
      name: name,
      email: email,
      phone: phone,
      uid: uid
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set(userModel.toMap())
        .then((value) {
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
