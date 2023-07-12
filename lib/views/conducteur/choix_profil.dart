import 'package:flutter/material.dart';
import 'package:ridemate/utilities/navigation.dart';
import 'package:ridemate/views/conducteur/inscription.dart';
import 'package:ridemate/views/passager/inscription.dart';
import 'package:ridemate/views/shared_views/connexion.dart';


class ChoixProfilPage extends StatelessWidget {
  const ChoixProfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: (){
            Navigator.pushReplacement(context, NoAnimationMaterialPageRoute(builder: (context) => const ConnexionPageWidget(), settings: null));
          },
        ),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: deviceHeight * 0.05),
            const Text(
              'Veuillez choisir votre profil',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(height: deviceHeight * 0.07),
            Card(
              color: Colors.white60,
              child: InkWell(
                onTap: () {
                  Navigator.pushReplacement(context, NoAnimationMaterialPageRoute(builder: (context) => const InscriptionConducteurPageWidget(), settings: null));
                },
                child: SizedBox(
                  width: deviceWidth * 0.6,
                  height: deviceHeight * 0.2,
                  child: Column(
                    children: <Widget>[
                      Image.asset('assets/conducteur_icon_image.png',),
                      const Text('Conducteur', style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold,)),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: deviceHeight * 0.1),
            Card(
              color: Colors.white60,
              child: InkWell(
                onTap: () {
                  Navigator.pushReplacement(context, NoAnimationMaterialPageRoute(builder: (context) => const InscriptionPassagerPageWidget(), settings: null));
                },
                child: SizedBox(
                  width: deviceWidth * 0.6,
                  height: deviceHeight * 0.2,
                  child: Column(
                    children: <Widget>[
                      Image.asset('assets/passager_icon_image.png',),
                      const Text('Passager', style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold,)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
