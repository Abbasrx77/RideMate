import 'package:flutter/material.dart';

import '../passager/card_reservation_envoye.dart';

class ReservationEnvoye extends StatefulWidget {
  const ReservationEnvoye({super.key});

  @override
  State<ReservationEnvoye> createState() => _ReservationEnvoyeState();
}

class _ReservationEnvoyeState extends State<ReservationEnvoye> {
  int _currentIndex = 0;

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
      body: ListView(
        children: const [
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'Réservation envoyée ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          //Card de Réservation reçue
          ReservationCard(
            date: '25 Juillet 2023',
            heure: '15h30',
            lieuDepart: 'Cotonou,Vodje',
            lieuArrivee: 'Cotonou,Eneam',
            description: 'Lorem ipsum dolor sit amet. Eos magni sunt non'
                ' officia eveniet aut rerum fugiat sed officiis '
                'voluptate cum beatae quam et amet quia sed Quis tempora.',
            nomPrenom: 'Laurent Sodji',
            typeVehicule: 'Voiture',
            nombrePlaces: 3,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.black),
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
      ),
    );
  }
}
