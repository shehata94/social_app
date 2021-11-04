import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/register/cubit/states.dart';
import 'package:social_app/shared/components/constants.dart';

class RegisterCubit extends Cubit<RegisterCubitStates> {
  RegisterCubit() : super(RegisterInitState());

  static RegisterCubit get(BuildContext context) => BlocProvider.of(context);

  void userRegister ({
    @required String email,
    @required String password
}) {
    emit(RegisterLoadingState());
    FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password
    ).then((value) {
      //token = value.credential.token;
      //print(token.toString());
      emit(RegisterSuccessState());
    }).catchError((error){
      emit(RegisterErrorState());
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
