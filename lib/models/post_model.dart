import 'package:social_app/models/user_model.dart';

class PostModel{
  String date;
  String postText;
  String postImage;
  String uid;
  UserModel userModel;

  PostModel({
    this.date,
    this.postText,
    this.postImage,
    this.uid,
    this.userModel
  });

  PostModel.fromJson(Map<String, dynamic> json){
    date = json['date'];
    postText = json['postText'];
    postImage = json['postImage'];
    uid = UserModel.fromJson(json['userModel']).uid;
    userModel = UserModel.fromJson(json['userModel']);
  }

  Map<String, dynamic> toMap(UserModel userModel){
    return
      {
        'date': date,
        'postText': postText,
        'postImage': postImage??'',
        'uid': userModel.toMap()['uid'],
        'userModel': userModel.toMap()
      };
  }



}