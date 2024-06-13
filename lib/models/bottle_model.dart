class Bottle {
  final String nbBottle;
  final String nbSerie;
  final String designation;
  final String localisation;
  final String state;
  final String rack;
  final String date;


  Bottle({
    required this.nbSerie,
    required this.nbBottle,
    required this.designation,
    required this.localisation,
    required this.rack,
    required this.state,
    required this.date
  });

  factory Bottle.fromMap(Map<String, dynamic> data) {
    return Bottle(
      nbBottle: data['nb_bottle'] ?? "",
      nbSerie: data['nb_serie'] ?? "",
      state: data['state'] ?? "",
      rack: data['rack'] ?? "",
      localisation: data['localisation'] ?? "",
      date: data['date'] ?? "",
        designation: data['designation'] ?? ""
    );
  }
}