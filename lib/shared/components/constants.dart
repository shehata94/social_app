import 'package:flutter/material.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/login/login_screen.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';

import 'components.dart';

var uid;
UserModel userModel;

void signOut(BuildContext context){
  CacheHelper.clearData(key: 'uid').then((value) {
    if (value) navigateAndFinish( context, LoginScreen());
  });
}