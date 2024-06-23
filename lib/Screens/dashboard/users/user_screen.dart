import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:expandable_datatable/expandable_datatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:greentrack/components/button.dart';
import 'package:greentrack/services/user_service.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../main.dart';
import '../../../models/user_model.dart';


List<User>? userList = [];
List<User>? userList2 = [];

class userScreen extends StatefulWidget {
  const userScreen({super.key});

  @override
  State<userScreen> createState() => _userScreenState();
}

class _userScreenState extends State<userScreen> {


  bool initPage = false;

  var selectedFilter = "";
  final List<String> items = [
    'Tous',

  ];
  String? selectedValue;
  TextEditingController _searchControlloer = TextEditingController();
  List<ExpandableRow>? rows;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(userList!.isEmpty){
      init();
    }else{
      setState(() {
        initPage = true;
      });
    }
  }

  init() async {
    print("start code ...");

    var data = await UserService().getAllUsers();
    setState(() {
      initPage = true;
      userList = data;
      userList2 = data;

    });
  }

  filterUserList(String searchTerm) {
    var filtedData = userList?.where((user) {
      return user.username.toLowerCase().contains(searchTerm.toLowerCase());
    }).toList();
    setState(() {
      userList = filtedData;

    });
    print(userList);
    return userList;
  }

  bool filter = false;

  @override
  Widget build(BuildContext context) {
    return initPage == false
        ? Center(
            child: CircularProgressIndicator(),
          )
        :
    SafeArea(
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
                              color: Colors.white,
                              child: TextField(

                                onChanged: (value){
                                if (value.isEmpty) {
                                  setState(() {
                                    userList = userList2;
                                  });
                                }
                                },
                                controller: _searchControlloer,
                                decoration: InputDecoration(
                                  hintText: "Rechercher... ",
                                  suffixIcon: Icon(Icons.close).onTap((){setState(() {
                                    _searchControlloer.text = "";
                                  });}),
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
                                    var d =
                                    filterUserList(_searchControlloer.text);
                                    setState(() {
                                      userList = d;
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
                                    _showAddUserDialog(context);
                                  },
                                  title: "+  Ajouter un utilisateur ",
                                  color: Colors.red),
                            ),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 2)),
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
                                  .map((String item) => DropdownMenuItem<String>(
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
                          child: userList!.isEmpty?
                              Center(
                                child:Text("Aucun element"),
                              ):
                          Column(
                            children: [
                              Container(
                                color: Colors.green,
                                padding: EdgeInsets.only(top: 5,bottom: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(width: 12,),
                                    Container(
                                        width: context.width()/4.5,
                                        child: Text(" Nom " ,style: boldTextStyle(color: Colors.white))),
                                    Container(
                                        width: context.width()/7,
                                        child: Text("Adresse email",style: boldTextStyle(color: Colors.white))),
                                    Container(
                                        width: context.width()/7,
                                        child: Text("Téléphone",style: boldTextStyle(color: Colors.white))),
                                    Container(
                                        width: context.width()/7,
                                        child: Text("Role",style: boldTextStyle(color: Colors.white),)),

                                  ],
                                ),
                              ),
                              ListView.builder(
                                  itemCount: userList!.length,
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (_, index) {
                                    int itemIndex = ((_currentPage - 1) * _itemsPerPage) + index;
                                    return Column(
                                      children: [

                                        ListTile(

                                          title: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: context.width()/5,
                                                  child: Text(" ${itemIndex+1} - "+userList![itemIndex].username,overflow: TextOverflow.ellipsis)),
                                              Container(
                                                  width: context.width()/7,
                                                  child: Text(userList![itemIndex].email,overflow: TextOverflow.ellipsis)),
                                              Container(
                                                  width: context.width()/7,
                                                  child: Text(userList![itemIndex].phone,overflow: TextOverflow.ellipsis)),
                                              Container(
                                                  width: context.width()/7,
                                                  child: Text(userList![itemIndex].role,overflow: TextOverflow.ellipsis)),

                                            ],
                                          ),
                                          leading: Icon(Icons.person),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.edit).onTap(()=>_showEditUserDialog(context,userList![itemIndex])),
                                              SizedBox(width: 20,),
                                              Icon(Icons.delete_forever,color: Colors.red,).onTap(()=>_showDeleteUserDialog(context,userList![itemIndex])),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: _currentPage > 1 ? _previousPage : null,
                              child: Text("Précédent"),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.red, // Couleur du texte
                                shape: RoundedRectangleBorder( // Bordures arrondies
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                            ),

                            SizedBox(width: 16.0),
                            Text("Page $_currentPage/${(userList!.length/_itemsPerPage).ceil()}"),
                            SizedBox(width: 16.0),
                            ElevatedButton(
                              onPressed: _currentPage < _totalPages ? _nextPage : null,
                              child: Text("Suivant"),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.red, // Couleur du texte
                                shape: RoundedRectangleBorder( // Bordures arrondies
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

  Future<void> _showDeleteUserDialog(BuildContext context, User user) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // l'utilisateur doit appuyer sur un bouton pour fermer
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmer la suppression'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Êtes-vous sûr de vouloir supprimer l\'utilisateur ${user.username} ?'),
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
              onPressed: () async{
                // Ici, vous pouvez supprimer l'utilisateur de votre base de données
                try{
                  await UserService().deleteUserById(user.id);
                  init();
                  Navigator.of(context).pop();

                }catch(e){
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(backgroundColor: Colors.red,content: Text("Une erreur est survenue.")));
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showAddUserDialog(BuildContext context) async {
    final _formKey = GlobalKey<FormState>();
    String _username = '';
    String _email = '';
    String _phone = '';
    String _role = '';

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ajouter un utilisateur'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Nom d\'utilisateur'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer un nom d\'utilisateur';
                      }
                      return null;
                    },
                    onSaved: (newValue) => _username = newValue!,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      if (value == null || value.isEmpty || !value.contains('@')) {
                        return 'Veuillez entrer un email valide';
                      }
                      return null;
                    },
                    onSaved: (newValue) => _email = newValue!,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Téléphone'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer un numéro de téléphone';
                      }
                      return null;
                    },
                    onSaved: (newValue) => _phone = newValue!,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Rôle'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer un rôle';
                      }
                      return null;
                    },
                    onSaved: (newValue) => _role = newValue!,
                  ),
                ],
              ),
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
              child: const Text('Ajouter'),
              onPressed: ()async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  // Ici, vous pouvez ajouter le nouvel utilisateur à votre base de données
                  var data = {
                    "username":_username,
                    "email": _email,
                    "phone": _phone,
                    "role": _role,
                    "date": DateTime.now().toString()
                  };
                  print(data);

                  await UserService().addUser(data);
                  init();
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }



  Future<void> _showEditUserDialog(BuildContext context, User user) async {
    final _formKey = GlobalKey<FormState>();
    String _username = user.username;
    String _email = user.email;
    String _phone = user.phone;
    String _role = user.role;


    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Éditer l\'utilisateur'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    initialValue: _username,
                    decoration: InputDecoration(labelText: 'Nom d\'utilisateur'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer un nom d\'utilisateur';
                      }
                      return null;
                    },
                    onSaved: (newValue) => _username = newValue!,
                  ),
                  TextFormField(
                    initialValue: _email,
                    decoration: InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      if (value == null || value.isEmpty || !value.contains('@')) {
                        return 'Veuillez entrer un email valide';
                      }
                      return null;
                    },
                    onSaved: (newValue) => _email = newValue!,
                  ),
                  TextFormField(
                    initialValue: _phone,
                    decoration: InputDecoration(labelText: 'Téléphone'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer un numéro de téléphone';
                      }
                      return null;
                    },
                    onSaved: (newValue) => _phone = newValue!,
                  ),
                  TextFormField(
                    initialValue: _role,
                    decoration: InputDecoration(labelText: 'Rôle'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer un rôle';
                      }
                      return null;
                    },
                    onSaved: (newValue) => _role = newValue!,
                  ),
                ],
              ),
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
              child: const Text('Enregistrer'),
              onPressed: ()async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  // Ici, vous pouvez mettre à jour les données de l'utilisateur
                  var data = {
                    "username":_username,
                    "email": _email,
                    "phone": _phone,
                    "role": _role
                  };
                  print(data);

                  await UserService().updateUserById(user.id, data);
                  init();
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  int _currentPage = 1;
  int _totalPages = 100; // Supposons que vous avez 100 pages de données
  int _itemsPerPage = 10;

  void _previousPage() {
    setState(() {
      if(_currentPage >2 && _currentPage<=(userList!.length/_itemsPerPage).ceil()){
        _currentPage--;

      }
    });
  }

  void _nextPage() {
    setState(() {
      if(_currentPage < (userList!.length/_itemsPerPage).ceil()){
        _currentPage++;

      }
    });
  }

}
