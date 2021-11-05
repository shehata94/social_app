import 'package:flutter/material.dart';
import 'package:social_app/shared/components/constants.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(onPressed: (){
            signOut(context);
          }, icon: Icon(Icons.keyboard_return))
        ],
      ),
    );
  }
}
