// import 'package:flutter/foundation.dart';
//
// class BottleData with ChangeNotifier {
//   bool _initPage = false;
//   List<dynamic> _bottleList = [];
//   List<dynamic> _bottleList2 = []; // If you need a separate list
//
//   bool get initPage => _initPage;
//   List<dynamic> get bottleList => _bottleList;
//   List<dynamic> get bottleList2 => _bottleList2; // Getter for secondary list
//
//   Future<void> setBottleData(List<dynamic> data) async {
//     _bottleList = data;
//     _bottleList2 = data; // Update secondary list if needed
//     _initPage = true;
//     notifyListeners();
//   }
// }