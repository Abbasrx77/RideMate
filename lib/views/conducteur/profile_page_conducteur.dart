import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ridemate/utilities/error_dialog.dart';
import 'package:ridemate/utilities/navigation.dart';
import 'package:ridemate/utilities/succes_dialog.dart';
import 'package:ridemate/views/conducteur/ReportConducteur.dart';
import 'package:ridemate/views/conducteur/acceuil.dart';
import 'package:ridemate/views/conducteur/offre_de_trajet.dart';
import 'package:ridemate/views/conducteur/reservation_en_attente.dart';
import 'package:intl/intl.dart';

import 'package:ridemate/api/api_service.dart';
import 'package:ridemate/views/conducteur/test_messages.dart';

class ConducteurProfilePage extends StatefulWidget {
  const ConducteurProfilePage({super.key});

  @override
  State<ConducteurProfilePage> createState() => _ConducteurProfilePageState();
}

class _ConducteurProfilePageState extends State<ConducteurProfilePage> {
  final storage = const FlutterSecureStorage();
  final apiService = ApiService();
  int _currentIndex = 0;
  double noteValue = 3.5;

  String nom = '';
  String prenom = '';
  String residence = '';
  String typeVehicule = '';
  int nombrePlaces = 0;
  String email = '';
  //String image = ''; // Nouvelle variable pour l'image
  //double nombreEtoiles = 0.0; // Nouvelle variable pour le nombre d'étoiles

  @override
  void initState() {
    super.initState();
    loadConducteurInfo();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(const AssetImage('assets/img1.jpg'), context);
  }
  Future<void> loadConducteurInfo() async {
    try {
      Map<String, dynamic> conducteurInfo = await apiService.infos();
      setState(() {
        nom = conducteurInfo['nom'] ?? '';
        prenom = conducteurInfo['prenom'] ?? '';
        residence = conducteurInfo['zone'] ?? '';
        typeVehicule = conducteurInfo['vehicule'] ?? '';
        nombrePlaces = conducteurInfo['place'] ?? '';
        email = conducteurInfo['email'] ?? '';
        // image = conducteurInfo['image'] ??
        //''; // Récupérer l'URL de l'image depuis la réponse JSON
        //nombreEtoiles = conducteurInfo['nombreEtoiles'] ??
        //0.0; // Récupérer le nombre d'étoiles depuis la réponse JSON
      });
    } catch (e) {
      // Gérer les erreurs ici
      print('Erreur lors du chargement des informations du conducteur : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    precacheImage(const AssetImage("assets/img1-min.jpg"), context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Padding(
          padding: EdgeInsets.only(left: deviceWidth * 0.24),
          child: const Text(
            "Profil",
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
      body: Container(
        color: Colors.grey.shade50,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: deviceHeight * 0.2,
              // Limite la hauteur de l'image au milieu de l'écran
              child: Image.asset(
                'assets/img1-min.jpg',
                fit: BoxFit.cover,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 100,
                ),
                Column(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/comment.jpg'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      '$nom $prenom',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RatingBarIndicator(
                      rating: noteValue,
                      itemBuilder: (context, index) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      itemCount: 5,
                      itemSize: 20.0,
                      unratedColor: Colors.grey,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      "$noteValue",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Card(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            const Text(
                              "Informations :",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Résidence : ',
                                  style: TextStyle(
                                    fontSize: 14,
                                    //fontFamily: Schyler,
                                  ),
                                ),
                                Text(
                                  "$residence",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                             Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Type de vehicule : ',
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  toBeginningOfSentenceCase("$typeVehicule") ?? "",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Nombre de places : ',
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  "$nombrePlaces",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'E-mail : ',
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  "$email",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const Spacer(),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ModificationPage(residence: residence,vehicule: typeVehicule,place: nombrePlaces,email: email,)),
                                    );
                                  },
                                  child: const Text(
                                    'Modifier vos informations personnelles',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                              ],
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const ReportConducteur()),
                                );
                              },
                              child: const Text(
                                'Signaler un problème',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                  context,
                  NoAnimationMaterialPageRoute(
                      builder: (context) => const AcceuilConducteurPageWidget(),
                      settings: null));
              break;
            case 1:
              Navigator.push(
                  context,
                  NoAnimationMaterialPageRoute(
                      builder: (context) => const OffreDeTrajet(),
                      settings: null));
              break;
            case 2:
              Navigator.push(
                  context,
                  NoAnimationMaterialPageRoute(
                      builder: (context) => const ReservationObtenue(),
                      settings: null));
              break;
            case 3:
              Navigator.push(
                  context,
                  NoAnimationMaterialPageRoute(
                      builder: (context) => const Messages(),
                      settings: null));
              break;
            case 4:
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
              color: Colors.black,
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}

// Pages Modifications

class ModificationPage extends StatefulWidget {
  final String residence;
  final String vehicule;
  final int place;
  final String email;
  const ModificationPage(
      {
        super.key,
        required this.residence,
        required this.vehicule,
        required this.place,
        required this.email,
      }
      );

  @override
  _ModificationPageState createState() => _ModificationPageState();
}

class _ModificationPageState extends State<ModificationPage> {
  final apiService = ApiService();
  final TextEditingController _residenceController = TextEditingController();
  final TextEditingController _typeVehiculeController = TextEditingController();
  final TextEditingController _nombrePlacesController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool isEmailValid(String email) {
    final RegExp regex =
    RegExp(r'^[a-zA-Z/d.a-zA-Z\d_%-]+@[a-zA-Z\d.-]+\.[a-zA-Z]{2,4}$');
    return regex.hasMatch(email);
  }

  @override
  void initState() {
    super.initState();
    _residenceController.text = widget.residence;
    _typeVehiculeController.text = widget.vehicule;
    _nombrePlacesController.text = widget.place.toString();
    _emailController.text = widget.email;
  }

  @override
  void dispose() {
    _residenceController.dispose();
    _typeVehiculeController.dispose();
    _nombrePlacesController.dispose();
    _emailController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        FocusScope.of(context).unfocus();
        await Future.delayed(const Duration(milliseconds: 100));
        return Future.value(true);
      },
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Modifier vos informations personnelles'),
          ),
          body: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _residenceController,
                      decoration: const InputDecoration(
                        labelText: 'Résidence',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _typeVehiculeController,
                      decoration: const InputDecoration(
                        labelText: 'Type de véhicule',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _nombrePlacesController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre de places',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Adresse e-mail',
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async{
                        String residence = _residenceController.text;
                        String typeVehicule = _typeVehiculeController.text.toLowerCase();
                        String nombrePlaces = _nombrePlacesController.text;
                        String email = _emailController.text.toLowerCase();

                        if(residence != widget.residence || typeVehicule != widget.vehicule || int.parse(nombrePlaces) != widget.place || email != widget.email){
                          if(!isEmailValid(email)){
                            await showErrorDialog(context, "Email invalide");
                          }else{
                            if( int.parse(nombrePlaces) < 1 || int.parse(nombrePlaces) > 4){
                              await showErrorDialog(context, "Entrez un nombre compris entre 1 et 4");
                            }else{
                              Map<String, dynamic> body = {
                                'zone':residence,
                                'vehicule':typeVehicule,
                                'place':nombrePlaces,
                                'email':email
                              };
                              final response = await apiService.update(body: body);
                              if(response.statusCode == 200){
                                await showSuccesDialog(context, "Données mises à jour avec succès");
                                residence = '';
                                typeVehicule = '';
                                nombrePlaces = '';
                                email = '';
                              }else{
                                await showErrorDialog(context, "Oups, une erreur s'est produite à notre niveau");
                              }
                            }
                          }
                        }
                      },
                      child: const Text('Enregistrer les modifications'),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
