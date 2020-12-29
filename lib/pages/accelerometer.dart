import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';

class JuegoAcelerometro extends StatefulWidget {
  @override
  _JuegoAcelerometroState createState() => _JuegoAcelerometroState();
}

class _JuegoAcelerometroState extends State<JuegoAcelerometro> {
  // color del circulo
  Color color = Colors.greenAccent;

  //evento devuelto por la secuencia del acelerómetro
  AccelerometerEvent event;

  // Mantener una referencia a estos, para que puedan eliminarse
  Timer timer;
  StreamSubscription accel;

  // posiciones y contador
  double top = 125;
  double left;
  int count = 0;

  // variables para el tamaño de la pantalla
  double width;
  double height;

  setColor(AccelerometerEvent event) {
    // Calcular izquierda
    double x = ((event.x * 12) + ((width - 100) / 2));
    // Calcular parte superior
    double y = event.y * 12 + 125;

    // encontrar la diferencia con la posición de destino
    var xDiff = x.abs() - ((width - 100) / 2);
    var yDiff = y.abs() - 125;

    // compruebe si el círculo está centrado, permitiendo actualmente 
    // un búfer de 3 para facilitar el centrado
    if (xDiff.abs() < 3 && yDiff.abs() < 3) {
      // establecer el color y el recuento de incrementos
      setState(() {
        color = Colors.greenAccent;
        count += 1;
      });
    } else {
      // establecer el color y reiniciar el recuento.
      setState(() {
        color = Colors.red;
        count = 0;
      });
    }
  }

  setPosition(AccelerometerEvent event) {
    if (event == null) {
      return;
    }

    // Cuando x = 0 debe centrarse horizontalmente
    // La posición izquierda debe ser igual a (ancho - 100) / 2
    // El mayor valor absoluto de x es 10, multiplicarlo por 12 permite que
    // la posición izquierda se mueva un total de 120 en cualquier dirección.
    setState(() {
      left = ((event.x * 12) + ((width - 100) / 2));
    });

    //Cuando y = 0 debería tener una posición superior que coincida con el objetivo, que establecemos en 125
    setState(() {
      top = event.y * 12 + 125;
    });
  }

  startTimer() {
    // Si no se ha creado la suscripción del acelerómetro, continúe y créela
    if (accel == null) {
      accel = accelerometerEvents.listen((AccelerometerEvent eve) {
        setState(() {
          event = eve;
        });
      });
    } else {
      // ya se ha creado, así que reanúdelo
      accel.resume();
    }

    // Los eventos del acelerómetro llegan más rápido de lo que los necesitamos, 
    //por lo que se usa un temporizador para procesarlos solo cada 200 milisegundos
    if (timer == null || !timer.isActive) {
      timer = Timer.periodic(Duration(milliseconds: 200), (_) {
        // si el recuento ha aumentado más de 3, pausa el temporizador para manejar el éxito
        if (count > 3) {
          pauseTimer();
        } else {
          // procesar el evento actual
          setColor(event);
          setPosition(event);
        }
      });
    }
  }

  pauseTimer() {
    //muestra la alerta en pantalla
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Center(child: Text("Ganaste")),
              contentPadding:const EdgeInsets.fromLTRB(0,0, 0, 0) ,
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("OK"),
                )
              ],
            ));
   
    // detiene el temporizador y pausa la transmisión del acelerómetro
    timer.cancel();
    accel.pause();
    // establece el color de éxito y restablece el conteo
    setState(() {
      count = 0;
      color = Colors.green;
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    accel?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // obtener el ancho y alto de la pantalla
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        children: [
          Container(
       
            height: 50,
            child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
              'MANTENGA EL CÍRCULO EN EL CENTRO DURANTE 1 SEGUNDO',
              style: TextStyle(
                  fontSize: 15,
              
              ),
              textAlign: TextAlign.center,
            ),
                )),
          ),
          Stack(
            children: [
              //A este contenedor vacío se le asigna un ancho y una altura para establecer el tamaño de la pila.
              Container(
                height: height / 2,
                width: width,
              ),

              // Crea el círculo objetivo exterior envuelto en una Posición
              Positioned(
                // colocado (posicionado) a 50 de la parte superior de la pila
                // y centrado horizontalmente, izquierda = (ScreenWidth - Container width) / 2
                top: 50,
                left: (width - 250) / 2,
                child: Container(
                  height: 250,
                  width: 250,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red, width: 2.0),
                    borderRadius: BorderRadius.circular(125),
                  ),
                ),
              ),
              // Este es el círculo de color que moverá el acelerómetro.
              // la parte superior e izquierda son variables que se establecerán
              Positioned(
                top: top,
                left: left ?? (width - 100) / 2,
                // el recipiente tiene un color y está envuelto en un Clip ovalado para hacerlo redondo
                child: ClipOval(
                  child: Container(
                    width: 100,
                    height: 100,
                    color: color,
                  ),
                ),
              ),
              // círculo objetivo interno envuelto en una posición
              Positioned(
                top: 125,
                left: (width - 100) / 2,
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green, width: 2.0),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
            ],
          ),
          Text('x: ${(event?.x ?? 0).toStringAsFixed(3)}'),
          Text('y: ${(event?.y ?? 0).toStringAsFixed(3)}'),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: RaisedButton(
              onPressed: startTimer,
              child: Text('Empezar'),
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              
            ),
          ),
          
        ],
      ),
    );
  }
}