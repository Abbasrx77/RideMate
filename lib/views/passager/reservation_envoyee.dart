import 'package:flutter/material.dart';
import 'package:ridemate/models/trajet.dart';
import 'package:ridemate/utilities/navigation.dart';
import 'package:ridemate/api/api_service.dart';
import 'package:ridemate/views/passager/acceuil.dart';
import 'package:ridemate/views/passager/card_reservation_envoye.dart';
import 'package:ridemate/views/passager/profile_page_passager.dart';
import 'package:ridemate/views/passager/test_messages_passager.dart';

class ReservationEnvoye extends StatefulWidget {
  const ReservationEnvoye({super.key});

  @override
  State<ReservationEnvoye> createState() => _ReservationEnvoyeState();
}

class _ReservationEnvoyeState extends State<ReservationEnvoye> {
  final apiService = ApiService();
  int _currentIndex = 0;
  late Future<List<Trajet>> _reservationsFuture;

  @override
  void initState(){
    super.initState();
    _reservationsFuture = loadTrajets();
  }

  Future<List<Trajet>> loadTrajets() async {
    return await apiService.get_trajets('reservations_envoyees');
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Padding(
          padding: EdgeInsets.only(left: deviceWidth * 0.11),
          child: const Text(
            "Mes réservations",
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
      body: Column(
        children: [
          /*const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Réservations envoyées', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),*/
          Expanded(
            child: FutureBuilder<List<Trajet>>(
              future: _reservationsFuture, // the Future you want to work with
              builder: (BuildContext context, AsyncSnapshot<List<Trajet>> snapshot) {
                if (snapshot.hasData) {
                  if(snapshot.data!.isNotEmpty){
                    return ListView(
                      children: snapshot.data!.map((trajet) {
                        return ReservationCard(
                          date: trajet.date,
                          heure: trajet.heure,
                          lieuDepart: trajet.lieuDepart,
                          lieuArrivee: trajet.lieuArrivee,
                          description: trajet.description,
                          nomPrenom: trajet.nomPrenom,
                          typeVehicule: trajet.typeVehicule,
                          nombrePlaces: trajet.nombrePlaces,
                        );
                      }).toList(),
                    );
                  }else{
                    return const Center(child: Text("Vous n'avez envoyé aucune réservation"));
                  }
                } else {
                  // If data is null, return a spinner
                  return const Center(child: CircularProgressIndicator());
                }
              } ,
            ),
          ),

        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          switch (index) {
            case 0:
              Navigator.push(context, NoAnimationMaterialPageRoute(builder: (context) => const AcceuilPassager(), settings: null));
              break;
            case 1:
              break;
            case 2:
              Navigator.push(context, NoAnimationMaterialPageRoute(builder: (context) => const MessagesPassager(), settings: null));
              break;
            case 3:
              Navigator.push(context, NoAnimationMaterialPageRoute(builder: (context) => const PassagerProfilPage(), settings: null));
              break;
          }
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.grey),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.send,color: Colors.black,),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message,color: Colors.grey,),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person,color: Colors.grey,),
            label: '',
          ),
        ],
      ),
    );
  }
}
