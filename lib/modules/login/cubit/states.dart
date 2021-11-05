
abstract class LoginCubitStates {}

class LoginInitState extends LoginCubitStates {}

class LoginLoadingState extends LoginCubitStates {}

class LoginSuccessState extends LoginCubitStates {
  final String uid;

  LoginSuccessState(this.uid);

}

class LoginErrorState extends LoginCubitStates {}

class ChangePassVisibility extends LoginCubitStates {}
