import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/login/cubit/states.dart';

class LoginCubit extends Cubit<LoginCubitStates> {
  LoginCubit() : super(LoginInitState());

  static LoginCubit get(BuildContext context) => BlocProvider.of(context);

  // LoginModel loginModel;
  // void userLogin(String email, String password) {
  //   emit(LoginLoadingState());
  //
  //   DioHelper.postData(path: Login, lang: 'en', data: {
  //     'email': email,
  //     'password': password,
  //   }).then((value) {
  //     loginModel = LoginModel.fromJson(value.data);
  //     emit(LoginSuccessState(loginModel));
  //   }).catchError((error) {
  //     print(error);
  //     emit(LoginErrorState());
  //   });
  // }

  void userLogin(String email, String password){

    emit(LoginLoadingState());
    FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password
    ).then((value)  {
      print(value.user.uid);
      emit(LoginSuccessState(value.user.uid));

    }).catchError((error){
      print(error);
      emit(LoginErrorState());

    });
  }

  IconData suffix = Icons.visibility;
  bool isPass = true;
  void changePassVisibility() {
    isPass = !isPass;

    isPass ? suffix = Icons.visibility : suffix = Icons.visibility_off;
    emit(ChangePassVisibility());
  }
}
