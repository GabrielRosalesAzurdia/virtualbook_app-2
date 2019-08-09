import 'package:biblioteca_virtualbook_app/modelos/token.dart';
import 'package:biblioteca_virtualbook_app/utils/database_helper_token.dart';
import 'package:biblioteca_virtualbook_app/widgets/alert.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class LibrosDetails extends StatefulWidget {
  final String name;
  final String description;
  final String image;
  final int id;
  final int autorIDd;
  final int categoriaId;
  final usuarioId;

  LibrosDetails(this.name,this.description,this.image,this.id,this.autorIDd,this.categoriaId,this.usuarioId);

  @override
  _LibrosDetailsState createState() => _LibrosDetailsState(name,description,image,id,autorIDd,categoriaId,usuarioId);
}

class _LibrosDetailsState extends State<LibrosDetails> {

  TokenDatabaseHelper tokenDatabaseHelper = TokenDatabaseHelper();
  var dataAutor;
  var dataCategoria;
  String name;
  String description;
  String image;
  int id;
  int autorIDd;
  int categoriaId;
  final usuarioId;

  _LibrosDetailsState(this.name,this.description,this.image,this.id,this.autorIDd,this.categoriaId,this.usuarioId);

  Future<Token> getToken() async {
    var token = await tokenDatabaseHelper.getTokenList();
    return token[0];
  }

  Future<String> getAutor() async {
    await getToken().then((value) async {
      var token = value;
      var res = await http.get(Uri.encodeFull("https://virtualbook-backend-2.herokuapp.com/api/autores/" + autorIDd.toString() + "/"),headers: {"Authorization":"JWT "+token.token} );
      try{
        setState(() {
          var resBody = json.decode(res.body);
          dataAutor = resBody;
        });
      }catch(e){
        print(e);
        print("ijole");
      }
      return "Success";
    });
  }

  Future<String> getCategory() async {
    await getToken().then((value) async {
      var token = value;
      var res = await http.get(Uri.encodeFull("https://virtualbook-backend-2.herokuapp.com/api/categorys/" + categoriaId.toString() + "/"),headers: {"Authorization":"JWT "+token.token} );
      try{
        setState(() {
          var resBody = json.decode(res.body);
          dataCategoria = resBody;
          print(resBody);
        });
      }catch(e){
        print(e);
        print("ijole");
      }
      return "Success";
    });
  }

  Future<String> addToDeseos() async {
    var resBody;
    await getToken().then((value) async {
      var token = value;
      var res = await http.post(
        Uri.encodeFull("https://virtualbook-backend-2.herokuapp.com/api/CrearLista/deseos"),
        headers: {"Authorization":"JWT "+token.token},
        body: {
          "cart_id":usuarioId.toString(),
          "book_id":id.toString(),
        }
      );
      setState(() {
        resBody = json.decode(res.body);
        print(resBody);
      });
      return "Success";
    });
    return resBody;
  }

  Future<String> addToRentados() async {
    var resBody;
    await getToken().then((value) async {
      var token = value;
      var res = await http.post(
        Uri.encodeFull("https://virtualbook-backend-2.herokuapp.com/api/CrearLista/renta"),
        headers: {"Authorization":"JWT "+token.token},
        body: {
          "cart_id":usuarioId.toString(),
          "book_id":id.toString(),
        }
      );
      setState(() {
        resBody = json.decode(res.body);
        print(resBody);
      });
      return "Success";
    });
    return resBody;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detalles del libro"),),
      body: SingleChildScrollView(child: Container(
        child: Center(
          child: Column(
            children:[

              Padding(padding: EdgeInsets.only(top: 10.0),child: null,),

              Image.network(image,height: 300,width: 200,),

              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 20.0), 
                child:Text(name,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15.0),)
              ),

              Padding(
                padding: EdgeInsets.all(10.0),
                child:Text(description,style: TextStyle(fontWeight: FontWeight.bold),)
              ),

              Text("Autor:"),
              dataAutor != null ? Text(dataAutor["name"]?? "") :Text("") ,

              Padding(padding: EdgeInsets.all(10.0),),

              Text("Categoria:"),
              dataCategoria != null ? Text(dataCategoria["name"]??"") :Text(""),

              Padding(padding: EdgeInsets.all(10.0),),

              Container(height: 100,width: 200,  child:Row(
                children: <Widget>[

                  Center (
                    child:Container(
                      decoration: new BoxDecoration(border: new Border.all(color: Colors.black)),
                      child:RaisedButton(
                        elevation: 0.0,
                        color: Colors.white,
                        child: Icon(Icons.shopping_cart,color: Colors.black),
                        onPressed: ()async{
                          print("preciono añadir a lista de rentados");
                          var resultado = await addToRentados();
                          if(resultado != "Funciono"){
                            bookFlight(context,"Ha sucedido un error","Este libro ya esta en tu lista de rentados o a has superado el limite de 5 libros");
                          }
                          else{
                            bookFlight(context,"Nice","Todo ha salido bien, Este libro esta en tu lista de Rentados");
                          }         
                        },
                      )
                    )
                  ),

                  Padding(
                    padding: EdgeInsets.all(10),
                    child: null
                  ),

                  Center(
                    
                    child:Container(
                      decoration: new BoxDecoration(border: new Border.all(color: Colors.black)),
                      child:RaisedButton(
                        elevation: 0.0,
                        color: Colors.white,
                        child: Icon(Icons.bookmark,color: Colors.black,),
                        onPressed: ()async{
                          print("preciono añadir a liste de deseos");
                          var resultado = await addToDeseos();
                          if(resultado == "Fallo"){
                            bookFlight(context,"Ha sucedido un error","Este libro ya esta en tu lista de deseos o a pasado algo");
                          }
                          else{
                            bookFlight(context,"Nice","Todo ha salido bien, Este libro esta en tu lista de deseos");
                          }
                        },
                      )
                    )
                  ),

                ],
              )),
            ]
          ),
        ),
      )),
    );
  }

  @override
  void initState() {
    super.initState();
    this.getAutor();
    this.getCategory();
  }

}