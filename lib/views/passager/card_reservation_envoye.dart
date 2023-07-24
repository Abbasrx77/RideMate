import 'package:flutter/material.dart';

class ReservationCard extends StatefulWidget {
  final String date;
  final String heure;
  final String lieuDepart;
  final String lieuArrivee;
  final String description;
  final String nomPrenom;
  final String typeVehicule;
  final int nombrePlaces;

  const ReservationCard({
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
  State<ReservationCard> createState() => _ReservationCardState();
}

class _ReservationCardState extends State<ReservationCard> {
  bool isTrajetDeleted = false;

  void _supprimerTrajet() {
    // Mettez ici la logique pour supprimer le trajet
    setState(() {
      isTrajetDeleted = true;
    });
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
                Text(widget.date),
                const Spacer(),
                const Icon(
                  Icons.access_time,
                  color: Colors.blue,
                ),
                const SizedBox(width: 8),
                Text(widget.heure),
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
                    widget.lieuDepart,
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
                  widget.lieuArrivee,
                  style: TextStyle(fontWeight: FontWeight.bold),
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
              child: Text(widget.description),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text(
                  widget.nomPrenom,
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
                //onPressed: _supprimerTrajet,
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text(
                  'Annuler',
                  //style: TextStyle(color: Colors.red, background: ),
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
