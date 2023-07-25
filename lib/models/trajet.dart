class Trajet {
  final String? date;
  final String? heure;
  final String? lieuDepart;
  final String? lieuArrivee;
  final String? description;
  final String? nomPrenom;
  final String? typeVehicule;
  final int? nombrePlaces;

  Trajet({this.date, this.heure, this.lieuDepart, this.lieuArrivee, this.description, this.nomPrenom, this.typeVehicule, this.nombrePlaces});

  // Creating a method to deserialize json
  factory Trajet.fromJson(Map<String, dynamic> json) {
    return Trajet(
      date: json['date'],
      heure: json['heure'],
      lieuDepart: json['lieuDepart'],
      lieuArrivee: json['lieuArrivee'],
      description: json['description'],
      nomPrenom: json['nomPrenom'],
      typeVehicule: json['typeVehicule'],
      nombrePlaces: json['nombrePlaces'],
    );
  }
}
