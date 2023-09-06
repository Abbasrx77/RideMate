import 'package:flutter/material.dart';
import 'package:ridemate/api/api_service.dart';
import 'package:ridemate/models/trajet.dart';
import 'package:ridemate/utilities/navigation.dart';
import 'package:ridemate/views/conducteur/acceuil.dart';
import 'package:ridemate/views/conducteur/card_reservation_recu.dart';
import 'package:ridemate/views/conducteur/offre_de_trajet.dart';
import 'package:ridemate/views/conducteur/profile_page_conducteur.dart';
import 'package:ridemate/views/conducteur/test_messages.dart';

class ReservationObtenue extends StatefulWidget {
  const ReservationObtenue({super.key});

  @override
  State<ReservationObtenue> createState() => _ReservationObtenueState();
}

class _ReservationObtenueState extends State<ReservationObtenue> {
  final apiService = ApiService();

  late Future<List<Trajet>> _trajetsFuture;

  @override
  void initState() {
    super.initState();
    _trajetsFuture = loadTrajets();
  }

  Future<List<Trajet>> loadTrajets() async {
    return await apiService.get_trajets('reservations_obtenues');
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Padding(
            padding: EdgeInsets.only(left: deviceWidth * 0.10),
            child: const Text(
              "Mes réservations",
              style: TextStyle(color: Colors.black,),
            ),
          ),
        ),
        body: Column(
          children: [
            /*SizedBox(height: deviceHeight * 0.05,),
            const Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Text('Réservations obtenues',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),*/
            Expanded(
              child: FutureBuilder<List<Trajet>>(
                future: _trajetsFuture, // the Future you want to work with
                builder: (BuildContext context,
                    AsyncSnapshot<List<Trajet>> snapshot) {
                  if (snapshot.hasData) {
                    if(snapshot.data!.isNotEmpty){
                      return Center(
                        child: SizedBox(
                          height: deviceHeight * 0.8,
                          width: deviceWidth * 0.95,
                          child: ListView(
                            children: snapshot.data!.map((trajet) {
                              return ReservationCard(
                                date: trajet.date,
                                heure: trajet.heure,
                                lieuDepart: trajet.lieuDepart,
                                lieuArrivee: trajet.lieuArrivee,
                                nomPrenom: trajet.nomPrenom,
                                typeVehicule: trajet.typeVehicule,
                                nombrePlaces: trajet.nombrePlaces,
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    }else{
                      return const Center(child: Text("Vous n'avez obtenu aucune réservation"));
                    }
                  } else {
                    // If data is null, return a spinner
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          onTap: (int index) {
            switch (index) {
              case 0:
                Navigator.pushReplacement(
                    context,
                    NoAnimationMaterialPageRoute(
                        builder: (context) =>
                            const AcceuilConducteurPageWidget(),
                        settings: null));
                break;
              case 1:
                Navigator.pushReplacement(
                    context,
                    NoAnimationMaterialPageRoute(
                        builder: (context) => const OffreDeTrajet(),
                        settings: null));
                break;
              case 2:
                break;
              case 3:
                //A FAIRE APRES
                Navigator.pushReplacement(
                    context,
                    NoAnimationMaterialPageRoute(
                        builder: (context) => const Messages(),
                        settings: null));
                break;
              case 4:
              //A FAIRE APRES
                //A FAIRE APRES
                Navigator.push(
                    context,
                    NoAnimationMaterialPageRoute(
                        builder: (context) => const ConducteurProfilePage(),
                        settings: null));
                break;
            }
          },
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home, color: Colors.grey),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.send,
                color: Colors.grey,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.send_time_extension,
                color: Colors.black,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.message,
                color: Colors.grey,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color: Colors.grey,
              ),
              label: '',
            ),
          ],
        ));
  }
}
