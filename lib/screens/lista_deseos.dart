import 'package:biblioteca_virtualbook_app/modelos/token.dart';
import 'package:biblioteca_virtualbook_app/utils/database_helper_token.dart';
import 'package:biblioteca_virtualbook_app/widgets/alert.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';

class ListaDeseos extends StatefulWidget {

  final usuarioId;

  ListaDeseos(this.usuarioId);

  @override
  _ListaDeseosState createState() => _ListaDeseosState(usuarioId);
}

class _ListaDeseosState extends State<ListaDeseos> {

  var usuarioId;
  var data;
  TokenDatabaseHelper tokenDatabaseHelper = TokenDatabaseHelper();

  _ListaDeseosState(this.usuarioId);

  Future<Token> getToken() async {
    var token = await tokenDatabaseHelper.getTokenList();
    return token[0];
  }

  Future<String> getListaDeseos() async {
    await getToken().then((value) async {
      var token = value;
      var res = await http.get(Uri.encodeFull("https://virtualbook-backend-2.herokuapp.com/api/getLista/deseos/"+  usuarioId.toString() + "/"),headers: {"Authorization":"JWT "+token.token} );
      try{
        setState(() {
          var resBody = json.decode(res.body);
          data = resBody;
        });
      }catch(e){
        print("ijole");
      }
      return "Success";
    });
  }

  Future<String> deleteElementDeseos(idLista) async {
    await getToken().then((value) async {
      var token = value;
      var res = await http.delete(Uri.encodeFull("https://virtualbook-backend-2.herokuapp.com/api/deleteLista/one/deseos/"+  idLista.toString() + "/"),headers: {"Authorization":"JWT "+token.token} );
      var resBody = json.decode(res.body);
      if(resBody == "Se ha eliminado"){
        bookFlight(context, "Se ha eliminado", "El elemento se ha eliminado correctamente");
        getListaDeseos();
      }  
      else{
        bookFlight(context, "Algo ha salido mal", "Por un motivo desconocido algo ha salido mal intentalo mas tarde");
      }
      return "Success";
    });
  }

  Future<String> addToRentados(id) async {
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
      appBar: AppBar(title: Text("Lista de Deseos"),),
      body:  ListView.builder(
        itemCount: data == null ? 0 : data.length,
        itemBuilder: (BuildContext context, int index){
          return new Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[ 

                Padding(
                  padding: EdgeInsets.only(top:15.0, left: 20.0),
                  child:Text(
                    data[index]["name"],
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.black54
                    ),
                  )
                ),

                Card(
                  elevation: 5,
                  child: Container(
                    padding: EdgeInsets.all(15),
                    child: Row(children:[
                    
                    Image.network(data[index]["image"],height: 250,width: 150,),

                    Padding(padding: EdgeInsets.only(left: 30.0) ,child: Column(
                      children: <Widget>[

                        Container(
                          decoration: new BoxDecoration(border: new Border.all(color: Colors.black)),
                          child:RaisedButton(
                            elevation: 0.0,
                            padding: EdgeInsets.all(12),
                            color: Colors.white,
                            child: Icon(Icons.delete),
                            onPressed: (){
                              print("preciono eliminar elemento");
                              deleteElementDeseos(data[index]["lista_deseos_id"]);
                            },
                          )
                        ),

                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: null,
                        ),
                        
                        Container(
                          decoration: new BoxDecoration(border: new Border.all(color: Colors.black)),
                          child:RaisedButton(
                            elevation: 0.0,
                            padding: EdgeInsets.all(12),
                            color: Colors.white,
                            child: Icon(Icons.shopping_cart),
                            onPressed: () async {
                              print("preciono añadir a lista de rentados");
                              var resultado = await addToRentados(data[index]["book_id"]);
                              if(resultado != "Funciono"){
                                bookFlight(context,"Ha sucedido un error","Este libro ya esta en tu lista de rentados o a has superado el limite de 5 libros");
                              }
                              else{
                                bookFlight(context,"Nice","Todo ha salido bien, Este libro esta en tu lista de Rentados");
                                getListaDeseos();
                              }                               
                            },
                          )
                        ),
                      
                        Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Column(
                            children:[
                              Text("Added on:"),
                              Text(data[index]["added_on"], style: TextStyle(color: Colors.grey),) 
                            ] 
                          )
                        ),
                        

                      ],
                    )),


                    ]),
                  ),
                ),

              ],
            ),
          );
        },
      ),
    );
  }

    @override
  void initState() {
    super.initState();
    this.getListaDeseos();
  }

}