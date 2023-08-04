import 'package:flutter/material.dart';
import 'package:ridemate/models/trajet.dart';
import 'package:ridemate/utilities/navigation.dart';
import 'package:ridemate/api/api_service.dart';
import 'package:ridemate/views/passager/acceuil.dart';
import 'package:ridemate/views/passager/card_reservation_envoye.dart';
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
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: SizedBox(
            height: deviceWidth *
                0.1, // you can increase or decrease the height as you need
            child: Image.asset('assets/main_logo.png'),
          ),
        ),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Réservations envoyées', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: FutureBuilder<List<Trajet>>(
              future: _reservationsFuture, // the Future you want to work with
              builder: (BuildContext context, AsyncSnapshot<List<Trajet>> snapshot) {
                if (snapshot.hasData) {
                  // Map the data if it is non-null
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
                } else {
                  // If data is null, return a spinner
                  return Center(child: CircularProgressIndicator());
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
            //A FAIRE APRES
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
