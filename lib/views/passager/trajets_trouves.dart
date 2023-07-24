import 'package:flutter/material.dart';
import 'package:ridemate/models/trajet.dart';
import 'package:ridemate/utilities/error_dialog.dart';
import 'package:ridemate/utilities/navigation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ridemate/api/api_service.dart';
import 'package:ridemate/views/passager/acceuil.dart';
import 'package:ridemate/views/passager/card_recherche_trajet.dart';


class TrajetsTrouvesPassager extends StatefulWidget {
  const TrajetsTrouvesPassager({super.key});

  @override
  State<TrajetsTrouvesPassager> createState() => _TrajetsTrouvesPassagerState();
}

class _TrajetsTrouvesPassagerState extends State<TrajetsTrouvesPassager> {
  final storage = const FlutterSecureStorage();
  final apiService = ApiService();

  late Future<List<Trajet>> _trajetstrouvesFuture;

  @override
  void initState(){
    super.initState();
    _trajetstrouvesFuture = loadTrajetstrouves();
  }

  Future<List<Trajet>> loadTrajetstrouves() async {
    final heure_depart = await storage.read(key: 'heure_depart');
    final date_depart = await storage.read(key: 'date_depart');
    final zone = await storage.read(key: 'zone');
    final eneam_passager = await storage.read(key: 'eneam_passager');

    Map<String,String> body = {
      'heure_depart': heure_depart ?? '',
      'date_depart': date_depart ?? '',
      'zone':zone ?? '',
      'eneam': eneam_passager ?? ''
    };

    return await apiService.rechercher_trajets('rechercher_trajet',body: body);
  }
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
            Navigator.pushReplacement(context, NoAnimationMaterialPageRoute(builder: (context) => const AcceuilPassager(), settings: null));
          },
        ),
      ),
        body: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Trajets trouvés', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: FutureBuilder<List<Trajet>>(
                future: _trajetstrouvesFuture, // the Future you want to work with
                builder: (BuildContext context, AsyncSnapshot<List<Trajet>> snapshot) {
                  if (snapshot.hasData) {
                    // Map the data if it is non-null
                    return ListView(
                      children: snapshot.data!.map((trajet) {
                        return RechercherCard(
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
    );
  }
}
