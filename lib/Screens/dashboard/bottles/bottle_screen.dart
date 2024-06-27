import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:expandable_datatable/expandable_datatable.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../components/button.dart';
import '../../../main.dart';
import '../../../models/bottle_model.dart';
import '../../../models/user_model.dart';
import '../../../services/bottle_service.dart';

List<Bottle>? bottleList = [];
List<Bottle>? bottleList2 = [];

class BottleScreen extends StatefulWidget {
  const BottleScreen({super.key});

  @override
  State<BottleScreen> createState() => _BottleScreenState();
}

class _BottleScreenState extends State<BottleScreen> {
  bool initPage = false;

  var selectedFilter = "";
  var selectedFilter2 = "";
  final List<String> items = ['Tout', 'Oxygene', 'Azote'];
  final List<String> items2 =['Tout', 'Vide', 'Plein',"Production"] ;
  String? selectedValue;
  String? selectedValue2;
  TextEditingController _searchControlloer = TextEditingController();
  List<ExpandableRow>? rows;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (bottleList!.isEmpty) {
      init();
    } else {
      setState(() {
        initPage = true;
      });
    }
  }

  init() async {
    var data = await BouteilleService().getBottles();
    setState(() {
      initPage = true;
      bottleList = data;
      bottleList2 = data;
    });
  }

  filterBottleList(String searchTerm) {
    var filtedData = bottleList?.where((bottle) {
      return bottle.nbBottle.toLowerCase().contains(searchTerm.toLowerCase());
    }).toList();
    setState(() {
      bottleList = filtedData;
    });
    print(bottleList);
    return bottleList;
  }

  filterBottleTypeList(String searchTerm) {
    if(searchTerm == "Tout"){
      setState(() {
        bottleList = bottleList2;
      });
      return bottleList;
    }else{
      setState(() {
        bottleList = bottleList2;
      });
      var filtedData = bottleList?.where((bottle) {
        return bottle.state.toLowerCase().contains(searchTerm.toLowerCase());
      }).toList();
      setState(() {
        bottleList = filtedData;
      });
      return bottleList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return initPage == false
        ? Center(
            child: CircularProgressIndicator(),
          )
        : SafeArea(
            child: Container(
            margin: EdgeInsets.all(10),
            height: context.height() / 1.14,
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
                                      bottleList = bottleList2;
                                    });
                                  }
                                },
                                controller: _searchControlloer,
                                decoration: InputDecoration(
                                  hintText: "Rechercher... ",
                                  suffixIcon: Icon(Icons.close).onTap(() {
                                    setState(() {
                                      _searchControlloer.text = "";
                                      bottleList = bottleList2;
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
                                      bottleList = d;
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
                                    _showAddBottleDialog(context);
                                  },
                                  title: "+  Ajouter une bouteille ",
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
                        Container(
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.white, width: 2)),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2<String>(
                              isExpanded: true,
                              hint: Text(
                                'Statut',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                              items: items2
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
                              value: selectedValue2,
                              onChanged: (String? value) {
                                setState(() {
                                  selectedValue2 = value;
                                  filterBottleTypeList(selectedValue2!);
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
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 85, left: 20, right: 20),
                    child: Column(
                      children: [
                        Container(
                          height: 480,
                          child: bottleList!.isEmpty
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
                                          Container(
                                              width: context.width() / 7,
                                              child: Text(
                                                "Localisation",
                                                style: boldTextStyle(
                                                    color: Colors.white),
                                              ))
                                        ],
                                      ),
                                    ),
                                    ListView.builder(
                                        // itemCount: bottleList!.length,
                                        itemCount: bottleList!.length > 9
                                            ? 9
                                            : bottleList!.length,
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
                                                                bottleList![
                                                                        itemIndex]
                                                                    .nbBottle)),
                                                    Container(
                                                        width:
                                                            context.width() / 7,
                                                        child: Text(bottleList![
                                                                itemIndex]
                                                            .nbBottle)),
                                                    Container(
                                                        width:
                                                            context.width() / 7,
                                                        child: Text(bottleList![
                                                                itemIndex]
                                                            .nbBottle)),
                                                    Container(
                                                        width:
                                                            context.width() / 13,
                                                        child: Text(bottleList![
                                                                itemIndex]
                                                            .state)),
                                                    Container(
                                                        width:
                                                        context.width() / 10,
                                                        child: Text(bottleList![
                                                        itemIndex]
                                                            .localisation))
                                                  ],
                                                ),
                                                leading: Icon(
                                                    Icons.local_gas_station),
                                                trailing: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Icon(Icons.edit).onTap(() =>
                                                        _showEditBottleDialog(
                                                            context,
                                                            bottleList![
                                                                itemIndex])),
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    Icon(
                                                      Icons.delete_forever,
                                                      color: Colors.red,
                                                    ).onTap(() =>
                                                        _showDeleteBottleDialog(
                                                            context,
                                                            bottleList![
                                                                itemIndex]))
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
                                "Page $_currentPage/${(bottleList!.length / _itemsPerPage).ceil()}"),
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
            ),
          ));
  }

  int _currentPage = 1;
  int _totalPages = 100; // Supposons que vous avez 100 pages de données
  int _itemsPerPage = 9;

  void _previousPage() {
    var _page = bottleList!.length / _itemsPerPage;
    var _pageLenght = _page.ceil();
    setState(() {
      if (_currentPage >= 2 &&
          _currentPage <= (bottleList!.length / _itemsPerPage).ceil()) {
        _currentPage--;
      }
      print("echecc de pagination : ${_pageLenght}");
    });
  }

  void _nextPage() {
    setState(() {
      if (_currentPage < (bottleList!.length / _itemsPerPage).ceil()) {
        _currentPage++;
      }
    });
  }

  Future<void> _showDeleteBottleDialog(
      BuildContext context, Bottle bottle) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      // l'utilisateur doit appuyer sur un bouton pour fermer
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmer la suppression'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Êtes-vous sûr de vouloir supprimer la bouteille ${bottle.nbBottle} ?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Supprimer'),
              onPressed: () async {
                // Ici, vous pouvez supprimer l'utilisateur de votre base de données
                try {
                  await BouteilleService().deleteBottleById(bottle.nbBottle);
                  init();
                  Navigator.of(context).pop();
                } catch (e) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.red,
                      content: Text("Une erreur est survenue.")));
                }
              },
            ),
          ],
        );
      },
    );
  }

  // ajouter une bouteille
  Future<void> _showAddBottleDialog(BuildContext context) async {
    final _formKey = GlobalKey<FormState>();
    final _nbBottleController = TextEditingController();
    final _nbSerieController = TextEditingController();
    final _dateController = TextEditingController();
    final _localisationController = TextEditingController();
    final _rackController = TextEditingController();
    final _designationController = TextEditingController();
    String _selectedState = 'Vide'; // Initial state value

    void _submitForm() async{
      if (_formKey.currentState!.validate()) {
        // Process the form data (e.g., save to database)
        var newBottle = {
          "date": DateTime.now().toString(),
          "designation": _designationController.text,
          "localisation": _localisationController.text,
          "nb_bottle": _nbBottleController.text,
          "nb_serie": _nbSerieController.text,
          "rack": "Indisponible",
          "state": _selectedState
        };
        print(newBottle);
        await BouteilleService().createBottle(newBottle);
        init();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Bouteille ajoutée")));

        // Clear the form fields
        _nbBottleController.clear();
        _nbSerieController.clear();
        _dateController.clear();
        _localisationController.clear();
        _rackController.clear();
        _designationController.clear();

        // Close the dialog
        Navigator.of(context).pop();
      }
    }

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ajouter une bouteille'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _nbBottleController,
                    decoration: const InputDecoration(
                        labelText: 'Nombre de bouteilles'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer le nombre de bouteilles';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _nbSerieController,
                    decoration:
                        const InputDecoration(labelText: 'Numéro de série'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer le numéro de série';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _dateController,
                    decoration: const InputDecoration(labelText: 'Date'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer la date';
                      }
                      return null;
                    },
                  ),
                  DropdownButtonFormField<String>(
                    value: _selectedState,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedState = newValue!;
                      });
                    },
                    items: [
                      DropdownMenuItem<String>(
                          value: 'Vide', child: Text('Vide')),
                      DropdownMenuItem<String>(
                          value: 'Plein', child: Text('Plein')),
                      DropdownMenuItem<String>(
                          value: 'En production', child: Text('En production')),
                    ],
                    decoration: const InputDecoration(labelText: 'État'),
                  ),
                  TextFormField(
                    controller: _localisationController,
                    decoration:
                        const InputDecoration(labelText: 'Localisation'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer la localisation';
                      }
                      return null;
                    },
                  ),

                  TextFormField(
                    controller: _designationController,
                    decoration: const InputDecoration(labelText: 'Désignation'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer la désignation';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red, // Définit la couleur de fond en rouge
                        ),
                        child: const Text('Annuler'),
                      ),
                      ElevatedButton(
                        onPressed: _submitForm,
                        child: const Text('Ajouter'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // editer une bouteille
  Future<void> _showEditBottleDialog(
      BuildContext context, Bottle bottle) async {
    final _formKey = GlobalKey<FormState>();

    String _nbBottleController = bottle.nbBottle.toString();
    String _nbSerieController = bottle.nbSerie;
    String _dateController = bottle.date;
    String _localisationController = bottle.localisation;
    String _rackController = bottle.rack;
    String _designationController = bottle.designation;

    String _selectedState = 'Vide'; // Initial state value

    void _submitForm()async {
      if (_formKey.currentState!.validate()) {
        // Process the edited data (e.g., update in database)
        var newBottle = {
          "designation": _designationController,
          "localisation": _localisationController,
          "nb_bottle": _nbBottleController,
          "nb_serie": _nbSerieController,
          "state": _selectedState
        };
        await BouteilleService().updateBottleById(bottle.nbBottle,newBottle);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Bouteille mise à jour")));

        Navigator.of(context).pop();
      }
    }

    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Modifier la bouteille ${bottle.nbBottle}'),
            content: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      initialValue: _nbBottleController,
                      decoration: const InputDecoration(
                          labelText: 'Nombre de bouteilles'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer le nombre de bouteilles';
                        }
                        return null;
                      },
                      onChanged: (newValue) => _nbBottleController = newValue,
                    ),
                    TextFormField(
                      initialValue: _nbSerieController,
                      onChanged: (newValue) => _nbSerieController = newValue,

                      decoration:
                          const InputDecoration(labelText: 'Numéro de série'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer le numéro de série';
                        }
                        return null;
                      },
                    ),

                    DropdownButtonFormField<String>(
                      value: _selectedState,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedState = newValue!;
                        });
                      },
                      items: [
                        DropdownMenuItem<String>(
                            value: 'Vide', child: Text('Vide')),
                        DropdownMenuItem<String>(
                            value: 'Plein', child: Text('Plein')),
                        DropdownMenuItem<String>(
                            value: 'En production',
                            child: Text('En production')),
                      ],
                      decoration: const InputDecoration(labelText: 'État'),
                    ),
                    TextFormField(
                      initialValue: _localisationController,
                      onChanged: (newValue) => _localisationController = newValue,

                      decoration:
                          const InputDecoration(labelText: 'Localisation'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer la localisation';
                        }
                        return null;
                      },
                    ),

                    TextFormField(
                      initialValue: _designationController,
                      onChanged: (newValue) => _designationController = newValue,

                      decoration:
                          const InputDecoration(labelText: 'Désignation'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer la désignation';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Annuler'),
                        ),
                        ElevatedButton(
                          onPressed: _submitForm,
                          child: const Text('Ajouter'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
