import 'package:biblioteca_virtualbook_app/modelos/token.dart';
import 'package:biblioteca_virtualbook_app/utils/database_helper_token.dart';
import 'package:biblioteca_virtualbook_app/widgets/alert.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ListaRentados extends StatefulWidget {

  final usuarioId;

  ListaRentados(this.usuarioId);

  @override
  _ListaRentadosState createState() => _ListaRentadosState(usuarioId);
}

class _ListaRentadosState extends State<ListaRentados> {

  TokenDatabaseHelper tokenDatabaseHelper = TokenDatabaseHelper();
  var usuarioId;
  var data;

  _ListaRentadosState(this.usuarioId); 

  Future<Token> getToken() async {
    var token = await tokenDatabaseHelper.getTokenList();
    return token[0];
  }

  Future<String> getListaRentados() async {
    await getToken().then((value) async {
      var token = value;
      var res = await http.get(Uri.encodeFull("https://virtualbook-backend-2.herokuapp.com/api/getLista/renta/"+  usuarioId.toString() + "/"),headers: {"Authorization":"JWT "+token.token} );
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

  Future<String> revicionFechas() async {
    await getToken().then((value) async {
      var token = value;
      var res = await http.get(Uri.encodeFull("https://virtualbook-backend-2.herokuapp.com/api/rentas/checkDates/"+  usuarioId.toString() + "/"),headers: {"Authorization":"JWT "+token.token} );
      var resBody = json.decode(res.body);

      if(resBody == "Se ha eliminado"){
        bookFlight(context, "Se ha eliminado", "Algun elemento se elimino por el tiempo de renta");
        getListaRentados();
      }else{
        getListaRentados();
      }

    });
  }

  Future<String> deleteElementRentados(idLista) async {
    await getToken().then((value) async {
      var token = value;
      var res = await http.delete(Uri.encodeFull("https://virtualbook-backend-2.herokuapp.com/api/deleteLista/one/renta/"+  idLista.toString() + "/"),headers: {"Authorization":"JWT "+token.token} );
      var resBody = json.decode(res.body);
      if(resBody == "Se ha eliminado"){
        bookFlight(context, "Se ha eliminado", "El elemento se ha eliminado correctamente");
        getListaRentados();
      }  
      else{
        bookFlight(context, "Algo ha salido mal", "Por un motivo desconocido algo ha salido mal intentalo mas tarde");
      }
      return "Success";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lista de Rentados"),),
      body: ListView.builder(
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
                              deleteElementRentados(data[index]["lista_rentados_id"]);
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

                        Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Column(
                            children:[
                              Text("Will delete on:"),
                              Text(data[index]["deleted_on"], style: TextStyle(color: Colors.grey),) 
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
    this.getListaRentados();
    this.revicionFechas();
  }

}