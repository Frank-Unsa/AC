import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_ac/utils/theme.dart';

class Configuraciones extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Icon(Icons.settings),
          ),
          Text("Configuraciones"),
        ],
      )),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Consumer<ThemeNotifier>(
                builder: (context, notifier, child) => SwitchListTile(
                  title: Text("Modo Oscuro", style: TextStyle(
                    fontWeight: FontWeight.bold
                  ),),
                  onChanged: (val) {
                    notifier.toogleTheme();
                  },
                  value: notifier.darkTheme,
                ),
              ),
            ),
          ]),
    );
  }
}
