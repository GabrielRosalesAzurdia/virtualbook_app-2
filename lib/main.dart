import 'package:biblioteca_virtualbook_app/screens/bienvenida.dart';
// import 'package:biblioteca_virtualbook_app/screens/iniciar_secion.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowMaterialGrid: false,
      debugShowCheckedModeBanner: false,
      title: "VirtualBook",
      theme: ThemeData(primaryColor: Colors.white),
      home:PaginaBienvenida(),
    );
  }
}

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowMaterialGrid: false,
//       debugShowCheckedModeBanner: false,
//       title: "VirtualBook",
//       home:PantallaDeInicioSecion(),
//     );
//   }
// }