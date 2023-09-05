import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ridemate/api/api_service.dart';
import 'package:ridemate/utilities/navigation.dart';
import 'package:ridemate/views/conducteur/test_messages.dart';


const storage = FlutterSecureStorage();
final apiService = ApiService();
void storeValue(String value) async {
  // Read data
  String? jsonString = await storage.read(key: 'uid');

  List<String> uidList;

  // Check if the key 'uid' already has a value
  if (jsonString == null) {
    // 'uid' is not already in secure storage, create new list and add the value
    uidList = [value];
  } else {
    // 'uid' is already in secure storage, retrieve it, convert to list and add new value
    uidList = List<String>.from(jsonDecode(jsonString));
    uidList = uidList.toSet().toList(); // using a Set to avoid duplicated.
    uidList.add(value);
  }
  // Convert the updated list back to a JSON string and store it
  await storage.write(key: 'uid', value: jsonEncode(uidList));
}
class ReservationCard extends StatefulWidget {
  final String? date;
  final String? heure;
  final String? lieuDepart;
  final String? lieuArrivee;
  final String? nomPrenom;
  final String? typeVehicule;
  final int? nombrePlaces;

  const ReservationCard({
    super.key,
    required this.date,
    required this.heure,
    required this.lieuDepart,
    required this.lieuArrivee,
    required this.nomPrenom,
    required this.typeVehicule,
    required this.nombrePlaces,
  });

  @override
  State<ReservationCard> createState() => _ReservationCardState();
}

class _ReservationCardState extends State<ReservationCard> {
  bool isTrajetDeleted = false;

  /*void _soumettreReservation() async{

    final date_depart = widget.date;
    final position_depart = widget.lieuDepart;
    final position_arrivee = widget.lieuArrivee;
    final nomPrenom = widget.nomPrenom;
    final place = widget.nombrePlaces.toString();
    Map<String,String?> body = {
      'date_depart': date_depart,
      'point_depart': position_depart,
      'point_arrivee': position_arrivee,
      'nomPrenom':nomPrenom,
      'place':place
    };
    setState(() {
      isTrajetDeleted = true;
    });
    final response = await apiService.delete('traiter_reservation',body: body);

  }*/

  @override
  Widget build(BuildContext context) {
    if (isTrajetDeleted) {
      return const SizedBox
          .shrink(); // Retourne un widget vide si le trajet est supprimé
    }

    return Card(
      elevation: 20.0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: const BorderSide(
          color: Colors.grey,
          width: 1.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  color: Colors.blue,
                ),
                const SizedBox(width: 8),
                Text(widget.date ?? ''),
                const Spacer(),
                const Icon(
                  Icons.access_time,
                  color: Colors.blue,
                ),
                const SizedBox(width: 8),
                Text(widget.heure ?? ''),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              //mainAxisAlignment: MainAxisAlignment.,
              children: [
                const Icon(
                  Icons.location_on,
                  color: Colors.blue,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.lieuDepart ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 12),
                  ),
                )
              ],
            ),
            const Row(
              children: [
                Icon(
                  Icons.arrow_downward,
                  color: Colors.blue,
                  size: 20,
                ),
              ],
            ),
            Row(
              children: <Widget>[
                const Icon(
                  Icons.location_on,
                  color: Colors.blue,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.lieuArrivee ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text(
                  widget.nomPrenom ?? '',
                  style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 12),
                ),
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${widget.typeVehicule} - ${widget.nombrePlaces} places disponibles',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: <Widget>[
                Spacer(),
                SizedBox(
                  width: 100,
                  child: ElevatedButton(
                    //onPressed: _supprimerTrajet,
                    onPressed: () async{

                      final date_depart = widget.date;
                      final position_depart = widget.lieuDepart;
                      final position_arrivee = widget.lieuArrivee;
                      final nomPrenom = widget.nomPrenom;
                      final place = widget.nombrePlaces.toString();
                      Map<String,String?> body = {
                        'traitement':'refuser',
                        'date_depart': date_depart,
                        'point_depart': position_depart,
                        'point_arrivee': position_arrivee,
                        'nomPrenom':nomPrenom,
                        'place':place
                      };
                      setState(() {
                        isTrajetDeleted = true;
                      });
                      await apiService.delete('traiter_reservation',body: body);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text(
                      'Refuser',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Spacer(),
                SizedBox(
                  width: 100,
                  child: ElevatedButton(
                    //onPressed: _supprimerTrajet,
                    onPressed: () async{

                      final date_depart = widget.date;
                      final position_depart = widget.lieuDepart;
                      final position_arrivee = widget.lieuArrivee;
                      final nomPrenom = widget.nomPrenom;
                      final place = widget.nombrePlaces.toString();
                      Map<String,String?> body = {
                        'traitement':'accepter',
                        'date_depart': date_depart,
                        'point_depart': position_depart,
                        'point_arrivee': position_arrivee,
                        'nomPrenom':nomPrenom,
                        'place':place
                      };
                      setState(() {
                        isTrajetDeleted = true;
                      });
                      final response = await apiService.delete('traiter_reservation',body: body);

                      var data = jsonDecode(response.body);
                      var fcm_Token = data[0];
                      var uid = data[1];

                      //print(data);
                      //print(fcm_Token);
                      //print(uid);


                      const String title = 'Réservation acceptée';
                      const String body1 = 'Votre réservation a été acceptée';
                      final String fcmToken = '$fcm_Token';

                      final Map<String, dynamic> data1 = {
                        'notification': {
                          'title': title,
                          'body': body1,
                          //'click_action': 'FLUTTER_NOTIFICATION_CLICK', // Optionnel, spécifie l'action lorsqu'on clique sur la notification
                        },
                        'to': fcmToken,
                      };
                      apiService.notify_reservation(dataToSend: data1);
                      storeValue(uid);
                      final acx = await storage.read(key: 'uid');
                      //print(acx);
                      Navigator.pushReplacement(context, NoAnimationMaterialPageRoute(builder: (context) => const Messages(), settings: null));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text(
                      'Accepter',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                Spacer(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
