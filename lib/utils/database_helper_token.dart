import 'package:biblioteca_virtualbook_app/modelos/token.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class TokenDatabaseHelper{
  static TokenDatabaseHelper _databaseHelper; //singleton database helper
  static Database _database; // singleton database 

  String colId = "id";
  String colToken = "token";
  String tokenTable = "token_table";

  TokenDatabaseHelper.createInstance(); // named contructor

  factory TokenDatabaseHelper(){
    if(_databaseHelper == null){
      _databaseHelper = TokenDatabaseHelper.createInstance(); // this execute only once
    }

    return _databaseHelper;
  }

  Future<Database>get database async{
    if(_database == null){
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory(); 
    String path = directory.path + "token";
    var notesDatabase = await openDatabase(path, version: 1, onCreate: _crateDataBase );
    return notesDatabase;
  }

  void _crateDataBase(Database db,newVersion) async {
    await db.execute("CREATE TABLE $tokenTable ($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colToken TEXT)");
  }

  //Fech function 
  Future <List<Map<String, dynamic>>> getToken() async {
      Database db = await this.database;
      //var result = await db.rawQuery("SELECT * FROM $noteTable order by $colPriority ASC");
      var result = await db.query(tokenTable,orderBy:"$colId ASC");
      return result;
  }   

  //insert operation
  Future<int>insertToken(Token t) async {
    Database db = await this.database;
    var result = await db.insert(tokenTable, t.getMap());
    return result;
  }

  //Update information
  Future<int>updateNote(Token t)async{
    Database db = await this.database;
    var result = await db.update(tokenTable, t.getMap(), where: "$colId = ?", whereArgs:[t.id]);
    return result;
  }

  //Delete operation
  Future<int> deleteNote(int id)async{
    Database db = await this.database;
    int result = await db.rawDelete('DELETE FROM $tokenTable WHERE $colId == $id');   
    return result;
  }

  //Number of records in the database
  Future<int>getCount()async{
    Database db = await this.database;
    List<Map<String,dynamic>> x = await db.rawQuery("SELECT COUNT (*) from $tokenTable");
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  //Get the maplist and convert it to note list
  Future<List<Token>> getTokenList()async{
    var noteMapList = await getToken();
    int count = noteMapList.length;
    List<Token> noteList = List<Token>();

    for(int i = 0; i < count; i++){
      noteList.add(Token.fromMapObject(noteMapList[i]));
    }

    return noteList;

  }

}