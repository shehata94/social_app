import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:social_app/layout/layout_screen.dart';
import 'package:social_app/modules/home/home_screen.dart';
import 'package:social_app/modules/login/cubit/cubit.dart';
import 'package:social_app/modules/login/cubit/states.dart';
import 'package:social_app/modules/register/register_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';

class LoginScreen extends StatelessWidget {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();

    return BlocProvider(
        create: (BuildContext context) => LoginCubit(),
        child: BlocConsumer<LoginCubit, LoginCubitStates>(
          listener: (context, state) {
            if (state is LoginSuccessState) {
                toastMessage("Login successfully", 'Success');

                CacheHelper.setData(key: 'uid', value: state.uid).then((value) {
                  // // Important when you logout so you should have the token saved when login again as token saved only in main initialization
                  // token = state.loginModel.data.token;
                  navigateAndFinish(context, LayoutScreen(uid: state.uid,));
                });
              } else if (state is LoginErrorState) {
                toastMessage("Login Failed", 'Error');
              }
          },
          builder: (context, state) {
            var cubit = LoginCubit.get(context);
            return Scaffold(
              appBar: AppBar(),
              body: Form(
                key: formKey,
                child: Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "LOGIN",
                            style: Theme.of(context).textTheme.headline3,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            "Login to enter our stores",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          defaultTextForm(
                              controller: emailController,
                              inputType: TextInputType.emailAddress,
                              prefix: Icons.email_outlined,
                              label: "Email Address",
                              onSubmit: (value){
                                if (formKey.currentState.validate()) {
                                  cubit.userLogin(emailController.text, passwordController.text);
                                }
                              },
                              validate: (String text) {
                                if (text.isEmpty) {
                                  return ("Email address can\'t be empty");
                                }
                              }),
                          SizedBox(
                            height: 10,
                          ),
                          defaultTextForm(
                              controller: passwordController,
                              inputType: TextInputType.visiblePassword,
                              prefix: Icons.lock,
                              label: "Password",
                              suffix: cubit.suffix,
                              isPassword: cubit.isPass,
                              onSubmit: (value){
                                if (formKey.currentState.validate()) {
                                  cubit.userLogin(emailController.text, passwordController.text);
                                }
                              },
                              suffixPressed: () {
                                cubit.changePassVisibility();
                              },
                              validate: (value) {
                                if (value.isEmpty) {
                                  return ("Password can\'t be empty");
                                }
                              }),
                          SizedBox(
                            height: 25,
                          ),
                          state is LoginLoadingState
                              ? Center(child: RefreshProgressIndicator())
                              : defaultButton(
                                  label: "LOGIN",
                                  onPressed: () {
                                    if (formKey.currentState.validate()) {
                                      cubit.userLogin(emailController.text, passwordController.text);
                                    }
                                  }),
                          SizedBox(
                            height: 25,
                          ),
                          Row(
                            children: [
                              Text("Don\'t have an account?"),
                              TextButton(
                                  onPressed: () {
                                    navigateTo(context, RegisterScreen());
                                  },
                                  child: Text("Register Now"))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ));
  }
}
