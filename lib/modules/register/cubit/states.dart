
abstract class RegisterCubitStates {}

class RegisterInitState extends RegisterCubitStates {}

class RegisterLoadingState extends RegisterCubitStates {}

class RegisterSuccessState extends RegisterCubitStates {}

class RegisterErrorState extends RegisterCubitStates {}

class RegisterCreateUserLoadingState extends RegisterCubitStates {}

class RegisterCreateUserSuccessState extends RegisterCubitStates {
  final String uid;

  RegisterCreateUserSuccessState(this.uid);
}

class RegisterCreateUserErrorState extends RegisterCubitStates {}

class RegisterChangePassVisibility extends RegisterCubitStates {}
