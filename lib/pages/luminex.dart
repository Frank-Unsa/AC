import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:light/light.dart';
import 'dart:async';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'dart:convert';
import 'package:json_table/json_table.dart';
import 'package:proyecto_ac/utils/json.dart';

class Luminex extends StatefulWidget {
  @override
  _LuminexState createState() => _LuminexState();
}

class _LuminexState extends State<Luminex> {
  Light _light;
  //el String mostrara la medida
  // le pasamos el string  subscription estara leyendo continuamente el sensor
  String _luxString = "unknown";
  //los puntos de datos entrantes se transmiten con un StreamSubscription
  StreamSubscription _subscription;
  //json para datos de tabla
  //json con algunos sitios y sus respectivos niveles de luz recomendados
  final String jsonSample =
      '[{"Sitio":"habitación", "Nivel":"150","Sitio":"oficina del doctor","Nivel":"300"},'
      '{"Sitio":"trabajo del desarrollador de software", "Nivel":"300"},'
      '{"Sitio":"Sala de maestros", "Nivel":"450"},{"Sitio":"trabajo de la máquina de coser","Nivel":"2000"}]';
  bool toggle = true;
  //aqui se ara uso de cada una de las propiedades del paquete light
  void onData(int luxValue) async {
    //imprime en cosola el valor que capturo de nuestro sensor del dispositivo
    //print("lux value: $luxValue");

    // como esta continuamente cambiando vamos a incluirlo en setState
    setState(() {
      //y el valor que estamos imprimiendo lo pase a la variable _luxString
      _luxString = "$luxValue";
    });
  }

//detener
  void stopListening() {
    //  La transmisión  se puede cancelar nuevamente llamando al método cancel ():
    _subscription.cancel();
  }

//Empezar
  void startListening() {
    _light = new Light();
    //en caso de que haya un error o falla nos imprima para ver que paso
    try {
      //Todos los puntos de datos entrantes se transmiten con un StreamSubscription
      //que se configura llamando al método listen () en el objeto de flujo light.lightSensorStream.
      _subscription = _light.lightSensorStream.listen(onData);
    } on LightException catch (exception) {
      //nos permite ientificar un LightExeption
      print(exception); // nos muestr por consola que error fue
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPlatFormState();
  }

// Los mensajes de la plataforma son asíncronos, por lo que los inicializamos en un método asíncrono.
//funcion asincrona  le decimos cuando inicie la aplicacion lo primero que haga
//es ejecutar starListening
  Future<void> initPlatFormState() async {
    startListening();
  }

  @override
  Widget build(BuildContext context) {
    //parseamos el nivel (_luxString) a double
    double nivel = double.tryParse('$_luxString') ?? 0.0;
    //declaramos el json y le pasamo jsondecode con el contenido de nuestro jsonSample
    var json = jsonDecode(jsonSample);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  //Agregando un Icono
                  Stack(
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        padding: EdgeInsets.only(right: 100.0),
                        child: Icon(
                          FontAwesomeIcons.lightbulb,
                          size: 45.0,
                          color: Colors.green[500],
                        ),
                      ),
                    ],
                  ),
                  // Porcentaje circular
                  // dentro de este te decimos pintar la información de la medida obtenida
                  Container(
                    alignment: Alignment.center,
                    color: Colors.transparent,
                    child: new CircularPercentIndicator(
                      radius: 240.0,
                      lineWidth: 25.0,
                      //usamos el nivel que es la intesidad de la luz y la dividimos entre mil
                      percent: (nivel <= 999) ? nivel / 1000 : 0.0,
                      center: Container(
                        margin: EdgeInsets.only(top: 40.0),
                        padding: EdgeInsets.only(top: 10.0),
                        //dentro del circulo se pontra un text con el valor de _luxString
                        //pintara el resultado de la intensidad de luz del lugar donde se encuentre
                        child: new Text(
                          "$_luxString\n",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 40.0),
                        ),
                      ),

                      ///en su pie de pagina se le coloca un text
                      footer: new Text(
                        "Niveles de lumenes por M²(LUX)",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17.0),
                      ),
                      circularStrokeCap: CircularStrokeCap.round,
                      // se le define el color del progreso
                      progressColor: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            Container(
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: Container(
                  margin: EdgeInsets.only(left: 5.0),
                  padding: EdgeInsets.all(5.0),
                  child: toggle
                      ? Column(
                          children: <Widget>[
                            //
                            JsonTable(
                              json,
                              //activr filtros?
                              showColumnToggle: true,
                              //le pedimos que nos traiga los heaer sitio / nivel
                              tableHeaderBuilder: (String header) {
                                return Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 4.0),
                                  decoration: BoxDecoration(
                                      border: Border.all(width: 0.5),
                                      color: Colors.blue[300]),
                                  child: Text(
                                    header,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .display1
                                        .copyWith(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14.0,
                                            color: Colors.black87),
                                  ),
                                );
                              },
                              //Le pedimos que nos traiga los demas valores (value)
                              tableCellBuilder: (value) {
                                return Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 4.0, vertical: 2.0),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                    width: 0.5,
                                    color: Colors.grey.withOpacity(0.5),
                                  )),
                                  child: Text(
                                    value,
                                    textAlign: TextAlign.left,
                                    style: Theme.of(context)
                                        .textTheme
                                        .display1
                                        .copyWith(fontSize: 14.0),
                                  ),
                                );
                              },
                              allowRowHighlight: true,
                              rowHighlightColor:
                                  Colors.yellow[500].withOpacity(0.7),
                            ),
                            SizedBox(
                              height: 40.0,
                            ),
                          ],
                          //Se le incluye el json
                        )
                      : Center(
                          child: Text(getPrettyJSONString(jsonSample)),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
