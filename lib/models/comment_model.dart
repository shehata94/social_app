import 'package:social_app/models/user_model.dart';

class CommentModel{
  String date;
  String commentText;
  UserModel userModel;

  CommentModel({
    this.date,
    this.commentText,
    this.userModel
  });

  CommentModel.fromJson(Map<String, dynamic> json){
    date = json['date'];
    commentText = json['commentText'];
    userModel = UserModel.fromJson(json['userModel']);
  }

  Map<String, dynamic> toMap(UserModel model){
    return
      {
        'date': date,
        'commentText': commentText,
        'userModel': model.toMap()
      };
  }



}