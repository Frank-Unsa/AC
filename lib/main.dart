import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_ac/pages/PantallaInicio.dart';
import 'package:proyecto_ac/utils/theme.dart';

void main() => runApp(Myapp());

class Myapp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: Consumer<ThemeNotifier>(
        builder: (context, ThemeNotifier notifier, child) {
          return MaterialApp(
            title: 'Aplicacion AC',
            theme: notifier.darkTheme ? dark : light,
            home: PantallaInicio(),
          );
        },
      ),
    );
  }
}