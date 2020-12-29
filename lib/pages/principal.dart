import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:proyecto_ac/pages/Configuraciones.dart';
import 'package:proyecto_ac/pages/PantallaInicio.dart';
import 'package:proyecto_ac/pages/accelerometer.dart';
import 'package:proyecto_ac/pages/luminex.dart';

class Principal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            leading: Retornar(),
            bottom: TabBar(tabs: [
              Tab(
                  icon: Icon(FontAwesomeIcons.lightbulb),
                  child: Text("Luminex")),
              Tab(
                  icon: Icon(FontAwesomeIcons.gamepad),
                  child: Text("Acelerometro")),
            ]),
            title: Text('Aplicaciones'),
            actions: <Widget>[BotonConfiguracion()],
          ),
          body: TabBarView(children: [
            Luminex(),
            JuegoAcelerometro(),
          ]),
        ));
  }
}

class Retornar extends StatelessWidget {
  const Retornar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.keyboard_backspace,
      ),
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PantallaInicio(),
        ));
      },
    );
  }
}

class BotonConfiguracion extends StatelessWidget {
  const BotonConfiguracion({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.settings),
        iconSize: 30.0,
        color: Colors.white,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Configuraciones(),
          ));
        });
  }
}
