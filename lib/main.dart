
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/layout_screen.dart';
import 'package:social_app/shared/bloc/bloc_observer.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';
import 'package:social_app/shared/styles/themes.dart';

import 'layout/cubit/cubit.dart';
import 'modules/login/login_screen.dart';
import 'modules/onboard/onboard_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await CacheHelper.init();
  Bloc.observer = MyBlocObserver();

  Widget widget;
  final onBoarding = CacheHelper.getData(key: 'onBoarding');
  String uid = CacheHelper.getData(key: 'uid');
  print(uid);
  if (onBoarding != null) {
    if (uid != null)
      widget = LayoutScreen(uid: uid,);
    else
      widget = LoginScreen();
  } else {
    widget = OnBoardingScreen();
  }

  runApp(MyApp(
    uid: uid,
    widget: widget,
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final Widget widget;
  final String uid;
  const MyApp({Key key, this.widget, this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(),
      child: MaterialApp(
        title: 'Social App',
        theme: lightTheme,
        debugShowCheckedModeBanner: false,
        home: widget,
      ),
    );
  }
}
