import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/layout_screen.dart';
import 'package:social_app/modules/home/home_screen.dart';
import 'package:social_app/modules/register/cubit/cubit.dart';
import 'package:social_app/modules/register/cubit/states.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';

class RegisterScreen extends StatelessWidget {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    var nameController = TextEditingController();
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    var phoneController = TextEditingController();

    return BlocProvider(
        create: (BuildContext context) => RegisterCubit(),
        child: BlocConsumer<RegisterCubit, RegisterCubitStates>(
          listener: (context, state) {
            if (state is RegisterCreateUserSuccessState) {
                CacheHelper.setData(key: 'uid', value: state.uid).then((value) {
                  navigateAndFinish(context, LayoutScreen(uid: state.uid,));
                });

              }
          },
          builder: (context, state) {
            var cubit = RegisterCubit.get(context);
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
                            "Register",
                            style: Theme.of(context).textTheme.headline3,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            "Register to enter our stores",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          defaultTextForm(
                              controller: nameController,
                              inputType: TextInputType.name,
                              prefix: Icons.person,
                              label: "User Name",
                              validate: (String text) {
                                if (text.isEmpty) {
                                  return ("User name can\'t be empty");
                                }
                              }),
                          SizedBox(
                            height: 10,
                          ),
                          defaultTextForm(
                              controller: emailController,
                              inputType: TextInputType.emailAddress,
                              prefix: Icons.email_outlined,
                              label: "Email Address",
                              validate: (String text) {
                                if (text.isEmpty) {
                                  return ("Email address can\'t be empty");
                                }
                              }),
                          SizedBox(
                            height: 10,
                          ),
                          defaultTextForm(
                              controller: phoneController,
                              inputType: TextInputType.phone,
                              prefix: Icons.phone,
                              label: "Phone Number",
                              validate: (String text) {
                                if (text.isEmpty) {
                                  return ("Phone number can\'t be empty");
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
                                  cubit.userRegister(
                                      name:nameController.text,
                                      email: emailController.text,
                                      phone:phoneController.text,
                                      password: passwordController.text
                                  );
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
                          state is RegisterLoadingState
                              ? Center(child: RefreshProgressIndicator())
                              : defaultButton(
                              label: "Register",
                              onPressed: () {
                                if (formKey.currentState.validate()) {
                                  cubit.userRegister(
                                      name:nameController.text,
                                      email: emailController.text,
                                      phone:phoneController.text,
                                      password: passwordController.text
                                  );
                                }
                              }),

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
