import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:expandable_datatable/expandable_datatable.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../components/button.dart';
import '../../../models/bottle_model.dart';
import '../../../models/user_model.dart';
import '../bottles/bottle_screen.dart';

List<Bottle> bottleProduction = [];
List<Bottle> bottleProduction2 = [];

class ProductionScreen extends StatefulWidget {
  const ProductionScreen({super.key});

  @override
  State<ProductionScreen> createState() => _ProductionScreenState();
}

class _ProductionScreenState extends State<ProductionScreen> {
TextEditingController _searchControlloer = TextEditingController();
var selectedFilter2 = "";
final List<String> items = ['Tout', 'Oxygene', 'Azote'];
final List<String> items2 =['Tout', 'Vide', 'Pleine',"En production"] ;
String? selectedValue;
String? selectedValue2;

filterBottleList(String searchTerm) {
  var filtedData = bottleProduction.where((bottle) {
    return bottle.nbBottle.toLowerCase().contains(searchTerm.toLowerCase());
  }).toList();
  setState(() {
    bottleProduction = filtedData;
  });
  return bottleProduction;
}
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      bottleProduction = bottleList2
          ?.where((bottle) =>
      bottle.state == 'plein' && bottle.localisation == "magasin")
          .toList() ??
          [];
      bottleProduction2 = bottleList2
          ?.where((bottle) =>
      bottle.state == 'plein' && bottle.localisation == "magasin")
          .toList() ??
          [];
    });
  }
  @override
  Widget build(BuildContext context) {

    return SafeArea(
        child: Container(
          margin: EdgeInsets.all(10),
          height: context.height()/1.14,
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  height: 100,
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 250,
                            height: 45,
                            color: Colors.white,
                            child: TextField(
                              onChanged: (value) {
                                if (value.isEmpty) {
                                  setState(() {
                                    bottleProduction = bottleProduction2;
                                  });
                                }
                              },
                              controller: _searchControlloer,
                              decoration: InputDecoration(
                                hintText: "Rechercher... ",
                                suffixIcon: Icon(Icons.close).onTap(() {
                                  setState(() {
                                    _searchControlloer.text = "";
                                    bottleProduction = bottleProduction2;
                                  });
                                }),
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.search),
                              ),
                            ),
                          ),
                          SizedBox(width: 16.0),
                          Container(
                            width: 150,
                            child: CustomButon(
                                onPress: () {
                                  var d = filterBottleList(
                                      _searchControlloer.text);
                                  setState(() {
                                    bottleProduction = d;
                                  });
                                },
                                title: "Rechercher ",
                                color: Colors.green),
                          ),
                          SizedBox(width: 16.0),
                          Container(
                            width: 210,
                            child: CustomButon(
                                onPress: () {
                                  //_showAddBottleDialog(context);
                                },
                                title: "+  Ajouter une production ",
                                color: Colors.red),
                          ),
                        ],
                      ),
                      // filtres des bouteilles par type
                      Container(
                        decoration: BoxDecoration(
                            border:
                            Border.all(color: Colors.white, width: 2)),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2<String>(
                            isExpanded: true,
                            hint: Text(
                              'Type',
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                            items: items
                                .map(
                                    (String item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ))
                                .toList(),
                            value: selectedValue,
                            onChanged: (String? value) {
                              setState(() {
                                selectedValue = value;
                              });
                            },
                            buttonStyleData: const ButtonStyleData(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              height: 40,
                              width: 140,
                            ),
                            menuItemStyleData: const MenuItemStyleData(
                              height: 40,
                            ),
                          ),
                        ),
                      ),
                      //filtres des bouteilles par statut
            
                    ],
                  ),
                ),
                // tableau
                Container(
                  margin: EdgeInsets.only(top: 85, left: 20, right: 20),
                  child: Column(
                    children: [
                      Container(
                        height: 480,
                        child: bottleProduction!.isEmpty
                            ? Center(
                          child: Text("Aucun element"),
                        )
                            : Column(
                          children: [
                            Container(
                              color: Colors.green,
                              padding:
                              EdgeInsets.only(top: 5, bottom: 5),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Container(
                                      width: context.width() / 4.5,
                                      child: Text(" No Bouteille ",
                                          style: boldTextStyle(
                                              color: Colors.white))),
                                  Container(
                                      width: context.width() / 7,
                                      child: Text("No serie",
                                          style: boldTextStyle(
                                              color: Colors.white))),
                                  Container(
                                      width: context.width() / 7,
                                      child: Text("Designation",
                                          style: boldTextStyle(
                                              color: Colors.white))),
                                  Container(
                                      width: context.width() / 7,
                                      child: Text(
                                        "Statut",
                                        style: boldTextStyle(
                                            color: Colors.white),
                                      )),
                                ],
                              ),
                            ),
                            ListView.builder(
                              // itemCount: bottleList!.length,
                                itemCount: bottleProduction!.length > 9
                                    ? 9
                                    : bottleProduction!.length,
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (_, index) {
                                  int itemIndex = ((_currentPage - 1) *
                                      _itemsPerPage) +
                                      index;
                                  return Column(
                                    children: [
                                      ListTile(
                                        title: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          children: [
                                            Container(
                                                width:
                                                context.width() / 5,
                                                child: Text(
                                                    " ${itemIndex + 1} - " +
                                                        bottleProduction![
                                                        itemIndex]
                                                            .nbBottle)),
                                            Container(
                                                width:
                                                context.width() / 7,
                                                child: Text(bottleProduction![
                                                itemIndex]
                                                    .nbBottle)),
                                            Container(
                                                width:
                                                context.width() / 7,
                                                child: Text(bottleProduction![
                                                itemIndex]
                                                    .nbBottle)),
                                            Container(
                                                width:
                                                context.width() / 7,
                                                child: Text(bottleProduction![
                                                itemIndex]
                                                    .state)),
                                          ],
                                        ),
                                        leading: Icon(
                                            Icons.local_gas_station),
                                        trailing: Row(
                                          mainAxisSize:
                                          MainAxisSize.min,
                                          children: [
                                            SizedBox(
                                              width: 20,
                                            ),
            
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed:
                            _currentPage > 1 ? _previousPage : null,
                            child: Text("Précédent"),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.red, // Couleur du texte
                              shape: RoundedRectangleBorder(
                                // Bordures arrondies
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                          ),
                          SizedBox(width: 16.0),
                          Text(
                              "Page $_currentPage/${(bottleProduction!.length / _itemsPerPage).ceil()}"),
                          SizedBox(width: 16.0),
                          ElevatedButton(
                            onPressed:
                            _currentPage < _totalPages ? _nextPage : null,
                            child: Text("Suivant"),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.red, // Couleur du texte
                              shape: RoundedRectangleBorder(
                                // Bordures arrondies
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ));
  }
int _currentPage = 1;
int _totalPages = 100; // Supposons que vous avez 100 pages de données
int _itemsPerPage = 9;

void _previousPage() {
  var _page = bottleProduction!.length / _itemsPerPage;
  var _pageLenght = _page.ceil();
  setState(() {
    if (_currentPage >= 2 &&
        _currentPage <= (bottleProduction!.length / _itemsPerPage).ceil()) {
      _currentPage--;
    }
    print("echecc de pagination : ${_pageLenght}");
  });
}

void _nextPage() {
  setState(() {
    if (_currentPage < (bottleProduction!.length / _itemsPerPage).ceil()) {
      _currentPage++;
    }
  });
}
}
