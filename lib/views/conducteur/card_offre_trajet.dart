import 'package:flutter/material.dart';
import 'package:ridemate/api/api_service.dart';
import 'package:ridemate/utilities/error_dialog.dart';

final apiService = ApiService();

class TrajetCard extends StatefulWidget {
  final String? date;
  final String? heure;
  final String? lieuDepart;
  final String? lieuArrivee;
  final String? description;
  final String? nomPrenom;
  final String? typeVehicule;
  final int? nombrePlaces;

  const TrajetCard({
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
  State<TrajetCard> createState() => _TrajetCardState();
}

class _TrajetCardState extends State<TrajetCard> {
  bool isTrajetDeleted = false;

  void _supprimerTrajet() async{

    final date_depart = widget.date;
    final position_depart = widget.lieuDepart;
    final position_arrivee = widget.lieuArrivee;
    final description = widget.description;
    final place = widget.nombrePlaces.toString();
    Map<String,String?> body = {
      'date_depart': date_depart,
      'point_depart': position_depart,
      'point_arrivee': position_arrivee,
      'description': description,
      'place':place
    };
    setState(() {
      isTrajetDeleted = true;
    });
    final response = await apiService.delete('supprimer_offres',body: body);
    //await showErrorDialog(context, "Données : ${response.body}");
  }

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
                    style: TextStyle(fontWeight: FontWeight.bold),
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
                Text(
                  widget.lieuArrivee ?? '',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
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
              child: Text(widget.description ?? ''),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text(
                  widget.nomPrenom ?? '',
                  style: const TextStyle(fontWeight: FontWeight.bold),
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
                onPressed: _supprimerTrajet,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade700,
                ),
                child: const Text(
                  'Supprimer',
                  //style: TextStyle(color: Colors.red, background: ),
                ),
              ),
            ),
            const SizedBox(height: 20)
          ],
        ),
      ),
    );
  }
}
