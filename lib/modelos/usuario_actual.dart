class UsuarioActual{
  String email;
  String firstName;
  int id;

  UsuarioActual(this.email, this.firstName);
 
  UsuarioActual.fromMapObject(Map<String,dynamic> map){
    this.id = map["id"];
    this.email = map["email"];
    this.firstName = map["first_name"];
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["email"] = email;
    map["first_name"] = firstName;
    map["id"] = id;
    return map;
  }

}