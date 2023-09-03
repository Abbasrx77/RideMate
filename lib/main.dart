import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ridemate/api/firebase_api.dart';
import 'package:ridemate/routes/routes_constants.dart';
import 'package:ridemate/views/conducteur/ReportConducteur.dart';
import 'package:ridemate/views/conducteur/acceuil.dart';
import 'package:ridemate/views/conducteur/inscription.dart';
import 'package:ridemate/views/conducteur/offre_de_trajet.dart';
import 'package:ridemate/views/passager/choix_position_depart.dart';
import 'package:ridemate/views/passager/inscription.dart';
import 'package:ridemate/views/shared_views/connexion.dart';
import 'package:google_fonts/google_fonts.dart';
import '/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseApi().initNotifications();

  //FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    localizationsDelegates: const [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [
      Locale('fr'),
    ],
    locale: const Locale('fr'),
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
      textTheme: GoogleFonts.robotoTextTheme(),
    ),
    navigatorObservers: [DismissKeyboardOnBack()],
    routes: {
      inscription_conducteur_route: (context) {
        return const InscriptionConducteurPageWidget();
      },
      //home: const ConnexionPageWidget(),
      //home: const OffreDeTrajet()) );
      //home: const ReservationRecu() ,
      //home: const RechercheConsulter(),
      //home: const ReservationEnvoye(),
      //home: const AcceuilPassager(),
      //home: const ConducteurProfilePage()));
      inscription_passager_route: (context) {
        return const InscriptionPassagerPageWidget();
      },
      connexion_route: (context) {
        return const ConnexionPageWidget();
      },
      choix_position_depart_route: (context) {
        return const AcceuilConducteurPageWidget();
      },
      offre_trajet_conducteur_route: (context) {
        return const OffreDeTrajet();
      },
      choix_position_depart_passager_route: (context) {
        return const ChoixPositionDepartPassager();
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const ConnexionPageWidget();
  }
}
class DismissKeyboardOnBack extends NavigatorObserver {
  @override
  void didStartUserGesture(Route<dynamic> route, Route<dynamic>? previousRoute) {
    final BuildContext? context = route.navigator?.context;
    if (context != null) {
      FocusScope.of(context).unfocus();
    }
    super.didStartUserGesture(route, previousRoute);
  }
}
