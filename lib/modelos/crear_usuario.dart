class CreateUser {
  final String email;
  final String password1;
  final String password2;
  final String firstName;
  final String lastName;
  final String country;
  final image;

  CreateUser({this.email, this.password1, this.password2, this.firstName,this.lastName,this.country,this.image=""});
 
  Map toMap() {
    var map = new Map<String, String>();
    map["email"] = email;
    map["password1"] = password1;
    map["password2"] = password2;
    map["first_name"] = firstName;
    map["last_name"] = lastName;
    map["country"] = country;
    map["image"] = image;
    return map;
  }
}