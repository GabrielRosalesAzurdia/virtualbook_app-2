import 'package:flutter/material.dart';

void bookFlight(BuildContext context,t1,t2){
  var alertDialog = AlertDialog(
    title: Text(t1),
    content: Text(t2),
  );
  showDialog(
    context: context,
    builder: (BuildContext context) => alertDialog
    
  );

}