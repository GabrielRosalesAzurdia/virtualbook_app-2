import 'package:biblioteca_virtualbook_app/modelos/token.dart';
import 'package:biblioteca_virtualbook_app/screens/lista_deseos.dart';
import 'package:biblioteca_virtualbook_app/screens/lista_rentados.dart';
import 'package:biblioteca_virtualbook_app/screens/usuario.dart';
import 'package:biblioteca_virtualbook_app/utils/database_helper_token.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'detalles_libro.dart';

class ListaLibros extends StatefulWidget {
  @override   
  _ListaLibrosState createState() => _ListaLibrosState();
}

class _ListaLibrosState extends State<ListaLibros> {

  var usuarioActual;
  List data;
  var totalDataRecivida;
  TokenDatabaseHelper tokenDatabaseHelper = TokenDatabaseHelper();
  String urlUsuario = "https://virtualbook-backend-2.herokuapp.com/api/accounts/";
  String urlLibros = "https://virtualbook-backend-2.herokuapp.com/api/books/";

  Future<Token> getToken() async {
    var token = await tokenDatabaseHelper.getTokenList();
    return token[0];
  }

  Future<String> getSWData() async {
    await getToken().then((value) async {
      var token = value;
      var res = await http.get(Uri.encodeFull(urlLibros),headers: {"Authorization":"JWT "+token.token} );
      setState(() {
        var resBody = json.decode(res.body);
        data = resBody["results"];
        totalDataRecivida = resBody;
      });
      return "Success";
    });
  }

  @override
  Widget build(BuildContext context){

    if(usuarioActual == null){
      var token; 
      getToken().then((value){
        token = value; 
        http.get(urlUsuario, headers: { "Authorization":"JWT "+token.token } ).then((http.Response response){
          setState(() {
            usuarioActual = json.decode(response.body);            
            print(usuarioActual);
          });
        });
      }); 
    }


    void navigateToBookDetails({name,description,image,id,autorId,cateId,usuarioId})async{
      await Navigator.push(context, MaterialPageRoute(builder: (context){
        return LibrosDetails(name,description,image,id,autorId,cateId,usuarioId);
      } ));
    }

    void navigateToListaDeseos(usuarioId)async{
      await Navigator.push(context, MaterialPageRoute(builder: (context){
        return ListaDeseos(usuarioId);
      } ));
    }

    void navigateToListaRentados(usuarioId)async{
      await Navigator.push(context, MaterialPageRoute(builder: (context){
        return ListaRentados(usuarioId);
      } ));
    }

    void navigateToUsserScreen(name,email,imagen,usuarioId)async{
      await Navigator.push(context, MaterialPageRoute(builder: (context){
        return UsuarioScreen(name,imagen,email,usuarioId);
      } ));
    }

    return Scaffold(
      appBar: AppBar(title: Text("libros")),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: usuarioActual != null ? Text(usuarioActual["first_name"]) : Text(""),
              accountEmail: usuarioActual != null ? Text(usuarioActual["email"]) : Text(""),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: null,
                child:new Container(
                  width: 190.0,
                  height: 190.0,
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    image: new DecorationImage(
                      fit: BoxFit.cover,
                       image: usuarioActual != null ? new NetworkImage("https://res.cloudinary.com/dhgug6x1k/" + usuarioActual["image"]) : new NetworkImage("https://i.imgur.com/BoN9kdC.png"),
                    )
                  )
                ),
                // Text(
                //   usuarioActual["first_name"][0],
                //   style: TextStyle(fontSize: 40.0),
                // )
              ),
              onDetailsPressed: (){
                print("preciono el details");
                if(usuarioActual != null){
                  navigateToUsserScreen(usuarioActual["first_name"], usuarioActual["email"],usuarioActual["image"],usuarioActual["customer_id"]);
                }
              },
            ),
            ListTile(
              title: Text("Lista de deseos"),
              trailing: Icon(Icons.arrow_forward),
              onTap: (){
                navigateToListaDeseos(usuarioActual["customer_id"]);
              },
            ),
            ListTile(
              title: Text("Lista de rentados"),
              trailing: Icon(Icons.arrow_forward),
              onTap: (){
                navigateToListaRentados(usuarioActual["customer_id"]);
              },
            ),

          ],
        ),
      ),
      body: ListView.builder(
        itemCount: data == null ? 0 : data.length,
        itemBuilder: (BuildContext context, int index){
          return new Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[ 

                // Card(
                //   child: Container(
                //     padding: EdgeInsets.all(15),
                //     child: Row(children:[

                //       Text(
                //         data[index]["name"],
                //         style: TextStyle(
                //           fontSize: 18.0,
                //           color: Colors.black54
                //         ),
                //       ),

                //     ]),
                //   ),
                // ),

                // Card(
                //   child: Container(
                //     padding: EdgeInsets.all(15),
                //     child: Row(children:[
                    
                //     Image.network(data[index]["image"],height: 250,width: 150,),

                //     Padding(padding: EdgeInsets.only(left: 30.0) ,child: Column(
                //       children: <Widget>[
                //         RaisedButton(
                //           child: Icon(Icons.add_box),
                //           onPressed: (){
                //             navigateToBookDetails(
                //               name: data[index]["name"],
                //               description: data[index]["description"],
                //               image: data[index]["image"],
                //               id: data[index]["book_id"],
                //               autorId: data[index]["autor_id"],
                //               cateId: data[index]["category_id"],
                //               usuarioId: usuarioActual["customer_id"],
                //             );
                //           },
                //         ),
                //       ],
                //     )),

                //     ]),
                //   ),
                // ),

                Card(
                  elevation: 5,
                  child: Container(
                    width: 200,
                    height: 350,
                    child:Center(child: Column(children:[
                      Image.network(data[index]["image"],height: 250,width: 150,),
                      Text(
                        data[index]["name"],
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black54
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0) ,
                        child: Column(
                          children: <Widget>[
                            Container(  
                              decoration: new BoxDecoration(border: new Border.all(color: Colors.black)),
                              child:RaisedButton(
                                padding: EdgeInsets.all(12),
                                color: Colors.white,
                                child: Icon(Icons.remove_red_eye,color: Colors.black),
                                onPressed: (){
                                  navigateToBookDetails(
                                    name: data[index]["name"],
                                    description: data[index]["description"],
                                    image: data[index]["image"],
                                    id: data[index]["book_id"],
                                    autorId: data[index]["autor_id"],
                                    cateId: data[index]["category_id"],
                                    usuarioId: usuarioActual["customer_id"],
                                  );
                                },
                              )
                            ),
                          ],
                        )
                      ),
                    ])) ,
                  ),
                ),
                

                Row(children:[

                Container(
                  padding: EdgeInsets.only(left: 50.0, right: 20.0,top: 10.0,bottom: 10.0),
                  child:index == data.length - 1 ? mostrarPaginacionAtras(): Text(""), 
                ),

                Container(
                  padding: EdgeInsets.only(left: 20.0, right: 50.0,top: 10.0,bottom: 10.0),
                  child:index == data.length - 1 ? mostrarPaginacionSiguiente() : Text(""), 
                ),
                
                ])

              ],
            ),
          );
        },
      ),
    );
  }

  Widget mostrarPaginacionSiguiente(){
    if(totalDataRecivida["next"] != null){
      return  RaisedButton(                             
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        padding: EdgeInsets.all(12),
        color: Colors.lightBlueAccent,child:Icon(Icons.arrow_right),onPressed: (){paginarAdelante();},
      );
    }else{
      return RaisedButton(child:Text(""),color: Colors.white,elevation: 0.0,onPressed: (){},);
    }
  }

  Widget mostrarPaginacionAtras(){
    if(totalDataRecivida["previous"] != null){
      return RaisedButton(   
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        padding: EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child:Icon(Icons.arrow_left),
        onPressed: (){paginarAtras();},) ;
    }else{
      return RaisedButton(child:Text(""),color: Colors.white,elevation: 0.0,onPressed: (){},);
    }
  }

  void paginarAdelante(){
    setState(() {
     urlLibros = totalDataRecivida["next"];
     getSWData(); 
    });
  }

  void paginarAtras(){
    setState(() {
     urlLibros = totalDataRecivida["previous"];
     getSWData(); 
    });
  }

  @override
  void initState() {
    super.initState();
    this.getSWData();
  }

}