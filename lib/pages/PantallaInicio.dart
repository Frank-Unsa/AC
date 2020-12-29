import 'package:flutter/material.dart';
import 'package:proyecto_ac/pages/principal.dart';

class PantallaInicio extends StatefulWidget {
  @override
  _PantallaInicioState createState() => _PantallaInicioState();
}

class _PantallaInicioState extends State<PantallaInicio> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amberAccent,
      body: Container(
        child: Stack(
          children: <Widget>[BarraLateral(), Logo()],
        ),
      ),
    );
  }
}

class Logo extends StatelessWidget {
  const Logo({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: Image.asset(
            'assets/img/logo.png',
            width: MediaQuery.of(context).size.width / 2,
            height: 200,
          ),
        ),
        SizedBox(
          height: 100,
        ),
        BotonDeContinuar()
      ],
    );
  }
}

class BotonDeContinuar extends StatelessWidget {
  const BotonDeContinuar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        shape: CircleBorder(),
        padding: EdgeInsets.all(13.0),
        color: Colors.red,
        child: Icon(
          Icons.chevron_right,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Principal(),
          ));
        });
  }
}

class BarraLateral extends StatelessWidget {
  const BarraLateral({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
        child: Align(
      alignment: FractionalOffset.bottomRight,
      child: Container(
        
        padding: EdgeInsets.only(right: 10, left: 5, top: 50, bottom: 50),
        decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(200))),
        child: RotatedBox(
          quarterTurns: 3,
          child: Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Text(
              "Medidor de Intencidad de la Luz",
              style: TextStyle(
                  color: Colors.amberAccent,
                  fontStyle: FontStyle.italic,
                  fontSize: 18,
                  letterSpacing: 5),
            ),
          ),
        ),
      ),
    ));
  }
}
