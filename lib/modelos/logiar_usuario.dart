class LoginUser {
  final String email;
  final String password;
 
  LoginUser({this.email, this.password});
 
  Map toMap() {
    var map = new Map<String, String>();
    map["email"] = email;
    map["password"] = password;
    return map;
  }
}