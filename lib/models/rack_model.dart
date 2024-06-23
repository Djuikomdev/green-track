import 'bottle_model.dart';

class Rack {
  final String id;
  final List<Bottle> bottles;
  final String date;
  final String name;

  Rack({
    required this.id,
    required this.bottles,
    required this.date,
    required this.name,
  });

  factory Rack.fromMap(Map<String, dynamic> data) {
    List<Map<String, dynamic>> bottlesData = List<Map<String, dynamic>>.from(data['bottles']);
    List<Bottle> bottles = bottlesData.map((bottleData) => Bottle.fromMap(bottleData)).toList();

    return Rack(
      id: data['id'],
      bottles: bottles,
      date: data['date'],
      name: data['name'],
    );
  }
}
