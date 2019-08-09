import 'package:flutter/material.dart';

class CampoDeTexto extends StatelessWidget{
  
  final TextEditingController controlador;
  final TextInputType teclado;
  final String titulo;

  CampoDeTexto(this.titulo, this.controlador, this.teclado);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle= Theme.of(context).textTheme.title;
    return Center(
      child: TextField(
        keyboardType: teclado,
        controller: controlador,
        decoration: InputDecoration(
        labelText: titulo,
        labelStyle: textStyle,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))
        ),
      ),
    );
  }

}


