class PostModel{
  String name;
  String date;
  String postText;
  String postImage;
  String profileImage;
  String uid;

  PostModel({
    this.name,
    this.date,
    this.postText,
    this.postImage,
    this.profileImage,
    this.uid
  });

  PostModel.fromJson(Map<String, dynamic> json){
    name = json['name'];
    date = json['date'];
    postText = json['postText'];
    postImage = json['postImage'];
    profileImage = json['profileImage'];
    uid = json['uid'];
  }

  Map<String, dynamic> toMap(){
    return
      {
        'name': name,
        'date': date,
        'postText': postText,
        'postImage': postImage??'',
        'profileImage': profileImage,
        'uid': uid
      };
  }



}