import 'package:flutter/material.dart';
import 'package:ridemate/routes/routes_constants.dart';
import 'package:ridemate/views/conducteur/inscription.dart';
import 'package:ridemate/views/passager/inscription.dart';
import 'package:ridemate/views/shared_views/connexion.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    routes: {
      inscription_conducteur_route: (context){
        return const InscriptionConducteurPageWidget();
      },
      inscription_passager_route: (context){
        return const InscriptionPassagerPageWidget();
      },
      connexion_route: (context){
        return const ConnexionPageWidget();
      },
    },
    home: const ConnexionPageWidget(),
  ));
}

class Acceuil extends StatefulWidget {
  const Acceuil({super.key});

  @override
  State<Acceuil> createState() => _AcceuilState();
}

class _AcceuilState extends State<Acceuil> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
