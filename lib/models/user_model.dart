class UserModel{
   String name;
   String email;
   String phone;
   String password;
   String uid;

  UserModel({
    this.name,
    this.email,
    this.phone,
    this.password,
    this.uid
  });

  UserModel.fromJson(Map<String, dynamic> json){
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    password = json['password'];
    uid = json['uid'];
  }

  Map<String, dynamic> toMap(){
    return
        {
          'name': name,
          'email': email,
          'phone': phone,
          'password': password,
          'uid': uid
        };
  }



}