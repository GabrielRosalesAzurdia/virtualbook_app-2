class Token {
  String token;
  int id;
  
  Token(this.token);

  Token.fromMapObject(Map<String,dynamic> map){
    this.id = map["id"];
    this.token = map["token"];
  }

  Map<String,dynamic> getMap(){
    var map = Map<String,dynamic>();
    if(id != null){
      map["id"] = id;
    }
    map["token"] = token;
    map["id"] = id;
    return map;
  }

}