import 'package:flutter/material.dart';
import 'package:biblioteca_virtualbook_app/screens/lista_deseos.dart';
import 'package:biblioteca_virtualbook_app/screens/lista_rentados.dart';

class UsuarioScreen extends StatefulWidget{

  final String name;
  final String imagen;
  final String email;
  final usuarioId;
  
  UsuarioScreen(this.name,this.imagen,this.email,this.usuarioId);

  @override
  _UsuarioScreenState createState() => _UsuarioScreenState(name,imagen,email,usuarioId);
}

class _UsuarioScreenState extends State<UsuarioScreen> {

  String name;
  String imagen;
  String email;
  var usuarioId;

  _UsuarioScreenState(this.name,this.imagen,this.email,this.usuarioId);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Perfil"),),
      body: Center(
        child: Column(
          children: <Widget>[
            
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: null,
            ),

            Center(
              child: new Container(
                width: 190.0,
                height: 190.0,
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  image: new DecorationImage(
                    fit: BoxFit.cover,
                    image: new NetworkImage("https://res.cloudinary.com/dhgug6x1k/" + imagen),
                  )
                )
              ),
            ),

            Padding(
              padding: EdgeInsets.all(10),
              child: Center(
                child: Text(name),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(10),
              child: Center(
                child: Text(email),
              ),
            ),     

            Padding(
              padding: EdgeInsets.all(10),
              child:Column(
                children: <Widget>[

                ListTile(
                  title: Text("Lista de deseos"),
                  trailing: Icon(Icons.arrow_forward),
                  onTap: (){
                    navigateToListaDeseos(usuarioId);
                  },
                ),
                ListTile(
                  title: Text("Lista de rentados"),
                  trailing: Icon(Icons.arrow_forward),
                  onTap: (){
                    navigateToListaRentados(usuarioId);
                  },
                ),

                ],
              )
            )

          ],
        ),
      ),
    );
  }
}