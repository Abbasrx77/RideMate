import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ConducteurProfilePage extends StatefulWidget {
  const ConducteurProfilePage({super.key});

  @override
  State<ConducteurProfilePage> createState() => _ConducteurProfilePageState();
}

class _ConducteurProfilePageState extends State<ConducteurProfilePage> {
  int _currentIndex = 0;
  double noteValue = 3.5;

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.black),
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
                'assets/img1.jpg',
                fit: BoxFit.cover,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 100,
                ),
                const Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/comment.jpg'),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Laurent Sodji',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
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
                      width: 0,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.amber.withOpacity(
                            0.2), // Couleur d'arrière-plan du bouton
                        padding: const EdgeInsets.all(
                            0), // Espacement intérieur du bouton
                        minimumSize: const Size(30, 15),
                      ),
                      onPressed: () {},
                      child: Text(
                        "$noteValue",
                        style: const TextStyle(
                          color: Colors.amber,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
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
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Résidence : ',
                                  style: TextStyle(
                                    fontSize: 14,
                                    //fontFamily: Schyler,
                                  ),
                                ),
                                Text(
                                  'Vodjè',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Type de vehicule : ',
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  'Voiture',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Nombre de place : ',
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  '4',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'E-mail : ',
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  'beunadorsodji@gmail.com',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ModificationPage()),
                                );
                              },
                              child: const Text(
                                'Modifier vos informations personnelles',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 16,
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
  const ModificationPage({super.key});

  @override
  _ModificationPageState createState() => _ModificationPageState();
}

class _ModificationPageState extends State<ModificationPage> {
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _residenceController = TextEditingController();
  final TextEditingController _typeVehiculeController = TextEditingController();
  final TextEditingController _nombrePlacesController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    controller: _nomController,
                    decoration: const InputDecoration(
                      labelText: 'Nom',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _prenomController,
                    decoration: const InputDecoration(
                      labelText: 'Prénom',
                    ),
                  ),
                  const SizedBox(height: 16),
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
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Adresse e-mail',
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Mettez ici la logique pour enregistrer les modifications
                      String nom = _nomController.text;
                      String prenom = _prenomController.text;
                      String residence = _residenceController.text;
                      String typeVehicule = _typeVehiculeController.text;
                      String nombrePlaces = _nombrePlacesController.text;
                      String email = _emailController.text;
                      // Vous pouvez maintenant utiliser ces valeurs pour enregistrer les modifications
                      // par exemple, vous pouvez les envoyer à une API ou les stocker localement.
                    },
                    child: Text('Enregistrer les modifications'),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
