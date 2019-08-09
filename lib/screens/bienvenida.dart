import 'package:biblioteca_virtualbook_app/screens/iniciar_secion.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class PaginaBienvenida extends StatefulWidget {
  @override
  _PaginaBienvenidaState createState() => _PaginaBienvenidaState();
}

class _PaginaBienvenidaState extends State<PaginaBienvenida> {

  bool _visible = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child:Center(
          child: AnimatedOpacity(
            opacity: _visible ? 1.0 : 0.0,
            duration: Duration(milliseconds: 500),
            child: Container(
              decoration: BoxDecoration(
                color: new Color(0xff622F74),
                gradient: LinearGradient(
                colors: [new Color(0xff29dfb7), new Color(0xff3ec7fd)],
                begin: Alignment.centerRight,
                // end: Alignment.centerLeft
                end: Alignment(-1.0,-1.0)
              )
            ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[

                  Text(
                    "VirtualBook", 
                    textDirection: TextDirection.ltr,
                    style: TextStyle(color: Colors.white,decoration: TextDecoration.none, fontSize: 75.0, fontFamily: 'MountainsOfChristmas', fontWeight: FontWeight.w300 ),
                  ),

                  Text(
                    "Tap me!!", 
                    textDirection: TextDirection.ltr,
                    style: TextStyle(color: Colors.white,decoration: TextDecoration.none, fontSize: 30.0, fontFamily: 'MountainsOfChristmas', fontWeight: FontWeight.w300 ),
                  )

              ]),
            ),
          ),
        ),
        
        onTap: () {
          setState(() {_visible = false;});
          Timer(Duration(seconds: 1), () => navigateToLogin()  );
        },
    );
  }

  void navigateToLogin()async{
    await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
      return PantallaDeInicioSecion();
    } ));
  }

}







class PaginaBienvenida2 extends StatefulWidget {
  @override
  _PaginaBienvenida2State createState() => _PaginaBienvenida2State();
}

class _PaginaBienvenida2State extends State<PaginaBienvenida2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: new Color(0xff622F74),
              gradient: LinearGradient(
                colors: [new Color(0xff29dfb7), new Color(0xff3ec7fd)],
                begin: Alignment.centerRight,
                // end: Alignment.centerLeft
                end: Alignment(-1.0,-1.0)
              )
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 75.0,
                child: Icon(Icons.beach_access, color: Colors.deepOrange,size: 50.0,)
              )
            ],
          )
        ],
      ),
    );
  }
}