import 'bottle_model.dart';

class Sale {
  final String id;
  final String date;
  final String ndoc;
  final String clientId;
  final List<Bottle> bottles;

  Sale({
    required this.id,
    required this.date,
    required this.ndoc,
    required this.clientId,
    required this.bottles,
  });

  factory Sale.fromMap(Map<String, dynamic> data) {
    return Sale(
      id: data['id'],
      date: data['date'],
      ndoc: data['ndoc'],
      clientId: data['clientId'],
      bottles: (data['bottles'] as List<dynamic>)
          .map((bottleData) => Bottle.fromMap(bottleData as Map<String, dynamic>))
          .toList(),
    );
  }
}

