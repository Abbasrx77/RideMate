import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:ridemate/api/api_service.dart';
import 'package:ridemate/utilities/error_dialog.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final apiService = ApiService();
final storage = const FlutterSecureStorage();

class RechercherCard extends StatefulWidget {
  final String? date;
  final String? heure;
  final String? lieuDepart;
  final String? lieuArrivee;
  final String? description;
  final String? nomPrenom;
  final String? typeVehicule;
  final int? nombrePlaces;

  const RechercherCard({
    super.key,
    required this.date,
    required this.heure,
    required this.lieuDepart,
    required this.lieuArrivee,
    required this.description,
    required this.nomPrenom,
    required this.typeVehicule,
    required this.nombrePlaces,
  });

  @override
  State<RechercherCard> createState() => _RechercherCardState();
}

class _RechercherCardState extends State<RechercherCard> {
  bool isReserved = false;

  void _reserverTrajet() async{

    final date_depart = widget.date;
    final heure_depart = widget.heure;
    final position_depart = widget.lieuDepart;
    final position_arrivee = widget.lieuArrivee;
    final description = widget.description;
    final place = widget.nombrePlaces.toString();
    final identite = widget.nomPrenom;
    Map<String,String?> body = {
      'date_depart': date_depart,
      'heure_depart': "$date_depart $heure_depart",
      'point_depart': position_depart?.toLowerCase(),
      'point_arrivee': position_arrivee?.toLowerCase(),
      'description': description,
      'place':place,
      'identite':identite
    };
    setState(() {
      isReserved = true;
    });
    final response = await apiService.post_authentification('reserver',body: body);

    var data = jsonDecode(response.body);
    var fcm_Token = data;


    final String title = 'Réservation obtenue';
    final String body1 = 'Vous venez de recevoir une réservation';
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

    //await showErrorDialog(context, "Données : ${fcmToken}");

  }

  @override
  Widget build(BuildContext context) {

    return Card(
      elevation: 20.0,
      color: isReserved ? Colors.grey.shade300 : Colors.white,
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
            const Row(
              children: [
                Padding(
                  padding: EdgeInsets.zero,
                    child: Text(
                      'Description',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Text(widget.description ?? '',style: TextStyle(fontSize: 12),),
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
            SizedBox(
              width: 300,
              child: ElevatedButton(
                onPressed: isReserved ? null : _reserverTrajet,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isReserved ? Colors.grey : Colors.blue,
                ),
                child: const Text(
                  'Réserver',
                  style: TextStyle(fontSize: 13),
                ),
              ),
            ),
            const SizedBox(height: 16)
          ],
        ),
      ),
    );
  }
}
