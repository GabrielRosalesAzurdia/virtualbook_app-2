import 'package:biblioteca_virtualbook_app/modelos/logiar_usuario.dart';
import 'package:biblioteca_virtualbook_app/modelos/token.dart';
import 'package:biblioteca_virtualbook_app/utils/database_helper_token.dart';
import 'package:biblioteca_virtualbook_app/widgets/alert.dart';
import 'package:biblioteca_virtualbook_app/widgets/text_field.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'crear_cuenta.dart';
import 'dart:convert';
import 'dart:async';

import 'lista_de_libros.dart';

class PantallaDeInicioSecion extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PantallaDeInicioSecionState();
  }


}

class _PantallaDeInicioSecionState extends State<PantallaDeInicioSecion>{

  void navigateListaLibros()async{  
    await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
      return ListaLibros();
    } ));
  }

  var token;
  final TextEditingController emailController = TextEditingController();
  final TokenDatabaseHelper tokendatabaseHelper = TokenDatabaseHelper(); 
  final TextEditingController passwordController = TextEditingController();
  final String url = "https://virtualbook-backend-2.herokuapp.com/api-token-obtain/";

  @override
  Widget build(BuildContext context) {
    
    TextStyle textStyle= Theme.of(context).textTheme.title;

    void navigateCrearCuenta()async{
      await Navigator.push(context, MaterialPageRoute(builder: (context){
        return CrearCuenta();
      } ));
    }
    
    void llenarToken() async {
      token = await tokendatabaseHelper.getTokenList();
      try{
      print(token[0].token);
      }catch(e){
        print("no hay token");
      }
      print(token.length);
    }

    llenarToken();

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Virtualbook"),), 
        
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(child:Column(
          children: <Widget>[

            Text("Iniciar secion", style: textStyle,),

            Padding(
              padding: EdgeInsets.all(20),
              child: null,
            ),

            CampoDeTexto("Email", emailController,TextInputType.emailAddress),

            Padding(
              padding: EdgeInsets.all(20),
              child: null,
            ),

            CampoDeTexto("Password", passwordController,TextInputType.text),

          // Container(
          //   margin: EdgeInsets.only(top: 20,bottom: 10, left: 20.0, right: 20.0),
          //   height: 50.0,
          //   width: 180.0,
          //   decoration: BoxDecoration(
          //     border: new Border.all(color: Colors.black12),
          //     borderRadius: BorderRadius.circular(30.0),
          //     color: Colors.white
          //   ),
          //   child:  GestureDetector(
          //     child: Center(child:Text("Crear cuenta", style:TextStyle(fontSize: 20,color: Colors.black)) ),
          //     onTap: (){
          //       navigateCrearCuenta();
          //     },
          //   )
          // ),

            Container(
              padding:EdgeInsets.only(top:20.0,bottom: 20.0), 
              width: 320.0,
              child:Container(
                decoration: new BoxDecoration(border: new Border.all(color: Colors.black)),
                child:RaisedButton(
                  elevation: 0.0,
                  child: Text("Crear Cuenta"),
                  padding: EdgeInsets.all(12),
                  color: Colors.white,
                  onPressed: (){
                    navigateCrearCuenta();
                  },
                )
              )
            ),

            Container( 
              width: 320.0,
              child:Container(
                decoration: new BoxDecoration(border: new Border.all(color: Colors.black)),
                child:RaisedButton(
                  elevation: 0.0,
                  child: Text("Entrar"),
                  padding: EdgeInsets.all(12),
                  color: Colors.white,
                  onPressed: (){
                    if(emailController.text == "" && passwordController.text == ""){
                      bookFlight(context,"La informacion es incorrecta","Porfavor revisa los datos");
                    }else{
                      LoginUser usuarioActual = new LoginUser(email: emailController.text, password: passwordController.text);
                      logindataUser(url,body:usuarioActual.toMap());
                    }
                  },
                )
              )
            ),

          ],
        )),
      ),
    );
  }
  
  Future<String> logindataUser(String url, {Map body}) async {
    return await http.post(url, body: body).then((http.Response response){
      final int statusCode = response.statusCode;
  
      if (statusCode < 200 || statusCode > 400 || json == null) {
        bookFlight(context,"La informacion es incorrecta","Porfavor revisa los datos");
        throw new Exception("Error while fetching data");
      }

      var valor = json.decode(response.body);

      if(valor.containsKey("non_field_errors"))
        bookFlight(context,"La informacion es incorrecta","Porfavor revisa los datos");
      else{
        var actualToken = Token(valor["token"]);
        if(token.length > 0){
          tokendatabaseHelper.deleteNote(token[0].id).then((v){
            tokendatabaseHelper.insertToken(actualToken).then((v){
              navigateListaLibros();
            });
          });
        }else{
          tokendatabaseHelper.insertToken(actualToken).then((v){
            navigateListaLibros();
          });
        }
      }

      return "completado";

    });
  }

}