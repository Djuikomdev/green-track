import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:expandable_datatable/expandable_datatable.dart';
import 'package:flutter/material.dart';
import 'package:greentrack/Screens/dashboard/bottles/bottle_screen.dart';
import 'package:greentrack/Screens/dashboard/clients/client_screen.dart';
import 'package:greentrack/Screens/dashboard/users/user_screen.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../components/button.dart';
import '../../../models/bottle_model.dart';
import '../../../models/user_model.dart';
import '../../../models/venter_model.dart';
import '../../../services/vente_service.dart';

List<Sale>? saleList = [];
List<Sale>? saleList2 = [];
List<Bottle>? bottleForSell = [];
List<Bottle>? bottleForSell2 = [];

class VentesScreen extends StatefulWidget {
  const VentesScreen({super.key});

  @override
  State<VentesScreen> createState() => _VentesScreenState();
}

class _VentesScreenState extends State<VentesScreen> {
  bool initPage = false;
  bool isEditingPage = false;

  var selectedFilter = "";
  final List<String> items = [
    'Tous',
  ];
  String? selectedValue;
  TextEditingController _searchControlloer = TextEditingController();
  TextEditingController _searchControlloer2 = TextEditingController();

  filterUserList(String searchTerm) {
    var filtedData = saleList?.where((sale) {
      return sale.ndoc.toLowerCase().contains(searchTerm.toLowerCase());
    }).toList();
    setState(() {
      saleList = filtedData;
    });
    print(saleList);
    return saleList;
  }

  filterBottleList(String searchTerm) {
    var filtedData = bottleForSell?.where((bottle) {
      return bottle.nbBottle.toLowerCase().contains(searchTerm.toLowerCase());
    }).toList();
    setState(() {
      bottleForSell = filtedData;
    });
    return bottleForSell;
  }

  bool filter = false;
  DateTime? _selectedDate = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      bottleForSell = bottleList
              ?.where((bottle) =>
                  bottle.state == 'plein' && bottle.localisation == "magasin")
              .toList() ??
          [];
      bottleForSell2 = bottleList
              ?.where((bottle) =>
                  bottle.state == 'plein' && bottle.localisation == "magasin")
              .toList() ??
          [];

      // saleList = [];
      // initPage = true;
    });
    if (saleList!.isEmpty) {
      init();
    } else {
      setState(() {
        initPage = true;
      });
    }
  }

  init() async {
    var data = await VentesService().getVentes();
    setState(() {
      initPage = true;
      saleList = data;
      saleList2 = data;
    });
  }

  List<Bottle> selectedBottles = [];

  @override
  Widget build(BuildContext context) {
    int _currentPage2 = 1;
    int _itemsPerPage2 = 20;
    int _totalPages2 = (bottleList!.length / _itemsPerPage2).ceil();

    return initPage == false
        ? Center(
            child: CircularProgressIndicator(),
          )
        : isEditingPage
            ? SafeArea(
                child: SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.all(10),
                    height: context.height() / 1.14,
                    width: context.width() * 0.9,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Menu déroulant des employés
                              DropdownButtonFormField(
                                hint: Text("Sélectionnez le client"),
                                items: clientList!.map((client) {
                                  return DropdownMenuItem(
                                    value: client,
                                    child: Text(client.username),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  // Logique de sélection de l'employé
                                },
                              ),
                              SizedBox(height: 16.0),

                              GestureDetector(
                                onTap: () async {
                                  final DateTime? pickedDate =
                                      await showDatePicker(
                                    context: context,
                                    initialDate:
                                        _selectedDate ?? DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100),
                                  );
                                  if (pickedDate != null) {
                                    setState(() {
                                      _selectedDate = pickedDate;
                                    });
                                  }
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.calendar_today),
                                    SizedBox(width: 8.0),
                                    Text(_selectedDate != null
                                        ? DateFormat('dd/MM/yyyy')
                                            .format(_selectedDate!)
                                        : "Sélectionnez une date"),
                                  ],
                                ),
                              ),

                              // Composant d'affichage des bouteilles sélectionnées
                              Container(
                                height: 400,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: selectedBottles.isNotEmpty
                                      ? selectedBottles.map((bottle) {
                                          return Text(bottle.nbBottle);
                                        }).toList()
                                      : [
                                          Center(
                                              child: Text(
                                                  'Aucune bouteille selectionnee.')),
                                        ],
                                ),
                              ),
                              SizedBox(
                                height: 7,
                              ),
                              Text(
                                  "Total : ${selectedBottles.length} bouteille(s)"),
                              SizedBox(
                                height: 10,
                              ),
                              CustomButon(
                                  onPress: () {},
                                  title: "Creer une vente",
                                  color: Colors.green),
                            ],
                          ),
                        ),
                        SizedBox(width: 20.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Barre de recherche de bouteilles
                              Container(
                                color: Colors.white,
                                child: TextField(
                                  controller: _searchControlloer2,
                                  decoration: InputDecoration(
                                    hintText: "Rechercher une bouteille",
                                    prefixIcon: Icon(Icons.search),
                                  ),
                                  onChanged: (value) {
                                    // Logique de recherche de bouteilles
                                    try {
                                      if (value.isEmpty) {
                                        setState(() {
                                          bottleForSell = bottleForSell2;
                                        });
                                      }

                                      var d = filterBottleList(
                                          _searchControlloer2.text);
                                      setState(() {
                                        bottleForSell = d;
                                      });
                                    } catch (e) {
                                      print("erreur de recherche : $e");
                                    }
                                  },
                                ),
                              ),
                              SizedBox(height: 16.0),

                              // Liste déroulante cochable des bouteilles
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 400,
                                      child: bottleForSell!.isEmpty
                                          ? Center(
                                              child:
                                                  Text("Aucun élément trouvé"),
                                            )
                                          : ListView.builder(
                                              itemCount:
                                                  bottleForSell!.length > 100
                                                      ? 100
                                                      : bottleForSell!.length,
                                              shrinkWrap: true,
                                              itemBuilder: (context, index) {
                                                int actualIndex =
                                                    (_currentPage2 - 1) *
                                                            _itemsPerPage2 +
                                                        index;
                                                return CheckboxListTile(
                                                  title: Text(bottleForSell![
                                                          actualIndex]
                                                      .nbBottle),
                                                  value: selectedBottles
                                                      .contains(bottleList![
                                                          actualIndex]),
                                                  onChanged: (value) {
                                                    if (value!) {
                                                      // Ajout de la bouteille à la liste des bouteilles sélectionnées
                                                      setState(() {
                                                        selectedBottles.add(
                                                            bottleForSell![
                                                                actualIndex]);
                                                      });
                                                    } else {
                                                      // Suppression de la bouteille de la liste des bouteilles sélectionnées
                                                      setState(() {
                                                        selectedBottles.remove(
                                                            bottleForSell![
                                                                actualIndex]);
                                                      });
                                                    }
                                                  },
                                                );
                                              },
                                            ),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: 16.0),

                              // Bouton de création de la vente
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                      width: 230,
                                      child: CustomButon(
                                          onPress: () {
                                            setState(() {
                                              isEditingPage = false;
                                            });
                                          },
                                          title: "Annuler",
                                          color: Colors.red)),
                                  Container(
                                      width: 230,
                                      child: CustomButon(
                                          onPress: () {},
                                          title: "Créer un rack",
                                          color: Colors.blue))
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : SafeArea(
                child: Container(
                margin: EdgeInsets.all(10),
                height: context.height() / 1.14,
                width: context.width() * 0.9, // Ajout d'une largeur fixe
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
                                  color:Colors.white,
                                  child: TextField(
                                    onChanged: (value) {
                                      if (value.isEmpty) {
                                        setState(() {
                                          saleList = saleList2;
                                        });
                                      }
                                    },
                                    controller: _searchControlloer,
                                    decoration: InputDecoration(
                                      hintText: "Rechercher... ",
                                      suffixIcon: Icon(Icons.close).onTap(() {
                                        setState(() {
                                          _searchControlloer.text = "";
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
                                        var d = filterUserList(
                                            _searchControlloer.text);
                                        setState(() {
                                          saleList = d;
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
                                        // _showAddUserDialog(context);
                                        setState(() {
                                          isEditingPage = !isEditingPage;
                                        });
                                      },
                                      title: "+  Ajouter une vente ",
                                      color: Colors.red),
                                ),
                              ],
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.white, width: 2)),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton2<String>(
                                  isExpanded: true,
                                  hint: Text(
                                    'Filtrer',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(context).hintColor,
                                    ),
                                  ),
                                  items: items
                                      .map((String item) =>
                                          DropdownMenuItem<String>(
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
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16),
                                    height: 40,
                                    width: 140,
                                  ),
                                  menuItemStyleData: const MenuItemStyleData(
                                    height: 40,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 95, left: 20, right: 20),
                        child: Column(
                          children: [
                            Container(
                              height: 480,
                              child: saleList!.isEmpty
                                  ? Center(
                                      child: Text("Aucun élément"),
                                    )
                                  : Column(
                                      children: [
                                        Container(
                                          color: Colors.green,
                                          padding: EdgeInsets.only(
                                              top: 5, bottom: 5),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: 12,
                                              ),
                                              Container(
                                                  width: context.width() / 4.5,
                                                  child: Text(" No document ",
                                                      style: boldTextStyle(
                                                          color:
                                                              Colors.white))),
                                              Container(
                                                  width: context.width() / 6,
                                                  child: Text("Client",
                                                      style: boldTextStyle(
                                                          color:
                                                              Colors.white))),
                                              Container(
                                                  width: context.width() / 6,
                                                  child: Text("Téléphone",
                                                      style: boldTextStyle(
                                                          color:
                                                              Colors.white))),
                                              Container(
                                                  width: context.width() / 7,
                                                  child: Text(
                                                    "   Date",
                                                    style: boldTextStyle(
                                                        color: Colors.white),
                                                  )),
                                            ],
                                          ),
                                        ),
                                        ListView.builder(
                                            itemCount: saleList!.length,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemBuilder: (_, index) {
                                              int itemIndex =
                                                  ((_currentPage - 1) *
                                                          _itemsPerPage) +
                                                      index;
                                              return Column(
                                                children: [
                                                  ListTile(
                                                    title: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                            width: context
                                                                    .width() /
                                                                5,
                                                            child: Text(
                                                                " ${itemIndex + 1} - " +
                                                                    saleList![
                                                                            itemIndex]
                                                                        .ndoc,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis)),
                                                        Container(
                                                            width: context
                                                                    .width() /
                                                                6,
                                                            child: Text(
                                                                saleList![
                                                                        itemIndex]
                                                                    .clientId,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis)),
                                                        Container(
                                                            width: context
                                                                    .width() /
                                                                6,
                                                            child: Text(
                                                                saleList![
                                                                        itemIndex]
                                                                    .clientId,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis)),
                                                        Container(
                                                            width: context
                                                                    .width() /
                                                                7,
                                                            child: Text(
                                                                saleList![
                                                                        itemIndex]
                                                                    .date,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis)),
                                                      ],
                                                    ),
                                                    leading: Icon(Icons.person),

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
                                    backgroundColor:
                                        Colors.red, // Couleur du texte
                                    shape: RoundedRectangleBorder(
                                      // Bordures arrondies
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 16.0),
                                Text(
                                    "Page $_currentPage/${(saleList!.length / _itemsPerPage).ceil()}"),
                                SizedBox(width: 16.0),
                                ElevatedButton(
                                  onPressed: _currentPage < _totalPages
                                      ? _nextPage
                                      : null,
                                  child: Text("Suivant"),
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor:
                                        Colors.red, // Couleur du texte
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
                ),
              ));
    ;
  }

  int _currentPage = 1;
  int _totalPages = 100; // Supposons que vous avez 100 pages de données
  int _itemsPerPage = 10;

  void _previousPage() {
    setState(() {
      if (_currentPage > 2 &&
          _currentPage <= (saleList!.length / _itemsPerPage).ceil()) {
        _currentPage--;
      }
    });
  }

  void _nextPage() {
    setState(() {
      if (_currentPage < (saleList!.length / _itemsPerPage).ceil()) {
        _currentPage++;
      }
    });
  }
}
