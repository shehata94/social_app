class UserModel{
   String name;
   String bio;
   String email;
   String phone;
   String coverImage;
   String profileImage;
   String uid;

  UserModel({
    this.name,
    this.bio,
    this.email,
    this.phone,
    this.coverImage,
    this.profileImage,
    this.uid
  });

  UserModel.fromJson(Map<String, dynamic> json){
    name = json['name'];
    bio = json['bio'];
    email = json['email'];
    phone = json['phone'];
    coverImage = json['coverImage'];
    profileImage = json['profileImage'];
    uid = json['uid'];
  }

  Map<String, dynamic> toMap(){
    return
        {
          'name': name,
          'bio': bio,
          'email': email,
          'phone': phone,
          'coverImage': coverImage,
          'profileImage': profileImage,
          'uid': uid
        };
  }



}