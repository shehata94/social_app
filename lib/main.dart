import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/home/home_screen.dart';
import 'package:social_app/shared/bloc/bloc_observer.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';
import 'package:social_app/shared/styles/themes.dart';

import 'modules/login/login_screen.dart';
import 'modules/onboard/onboard_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await CacheHelper.init();
  Bloc.observer = MyBlocObserver();


  Widget widget;
  final onBoarding = CacheHelper.getData(key: 'onBoarding');
  uid = CacheHelper.getData(key: 'uid');
  if (onBoarding != null) {
    if (uid != null)
      widget = HomeScreen();
    else
      widget = LoginScreen();
  } else {
    widget = OnBoardingScreen();
  }

  runApp(MyApp(
    widget: widget,
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final Widget widget;
  const MyApp({Key key, this.widget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shop App',
      theme: lightTheme,
      debugShowCheckedModeBanner: false,
      home: widget,
    );
  }
}
