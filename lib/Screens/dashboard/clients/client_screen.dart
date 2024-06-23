import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../components/button.dart';
import '../../../models/client_model.dart';
import '../../../services/client_service.dart';

List<Client>? clientList = [];
List<Client>? clientList2 = [];

class ClientScreen extends StatefulWidget {
  const ClientScreen({super.key});

  @override
  State<ClientScreen> createState() => _ClientScreenState();
}

class _ClientScreenState extends State<ClientScreen> {


  bool initPage = false;

  var selectedFilter = "";
  final List<String> items = [
    'Tous',

  ];
  String? selectedValue;
  TextEditingController _searchControlloer = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(clientList!.isEmpty){
      init();
    }else{
      setState(() {
        initPage = true;
      });
    }
  }

  init() async {
    print("start code ...");

    var data = await ClientService().getAllClients();
    setState(() {
      initPage = true;
      clientList = data;
      clientList2 = data;

    });
  }

  filterUserList(String searchTerm) {
    var filtedData = clientList?.where((client) {
      return client.username.toLowerCase().contains(searchTerm.toLowerCase());
    }).toList();
    setState(() {
      clientList = filtedData;

    });
    print(clientList);
    return clientList;
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

                            child: TextField(

                              onChanged: (value){
                                if (value.isEmpty) {
                                  setState(() {
                                    clientList = clientList2;
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
                                    clientList = d;
                                  });
                                },
                                title: "Rechercher ",
                                color: Colors.indigoAccent),
                          ),
                          SizedBox(width: 16.0),
                          Container(
                            width: 210,
                            child: CustomButon(
                                onPress: () {
                                  _showAddClientDialog(context);
                                },
                                title: "+  Ajouter un client ",
                                color: Colors.indigoAccent),
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
                        child: clientList!.isEmpty?
                        Center(
                          child:Text("Aucun client"),
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
                                      child: Text("Adresse",style: boldTextStyle(color: Colors.white),)),

                                ],
                              ),
                            ),
                            ListView.builder(
                                itemCount: clientList!.length,
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
                                                child: Text(" ${itemIndex+1} - "+clientList![itemIndex].username,overflow: TextOverflow.ellipsis)),
                                            Container(
                                                width: context.width()/7,
                                                child: Text(clientList![itemIndex].email,overflow: TextOverflow.ellipsis)),
                                            Container(
                                                width: context.width()/8,
                                                child: Text(clientList![itemIndex].phone,overflow: TextOverflow.ellipsis)),
                                            Container(
                                                width: context.width()/7,
                                                child: Text(clientList![itemIndex].city+", "+clientList![itemIndex].quarter,overflow: TextOverflow.ellipsis,)),

                                          ],
                                        ),
                                        leading: Icon(Icons.person),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.edit).onTap(()=>_showEditUserDialog(context,clientList![itemIndex])),
                                            SizedBox(width: 20,),
                                            Icon(Icons.delete_forever,color: Colors.red,).onTap(()=>_showDeleteUserDialog(context,clientList![itemIndex])),
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
                          Text("Page $_currentPage/${(clientList!.length/_itemsPerPage).ceil()}"),
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

  Future<void> _showDeleteUserDialog(BuildContext context, Client client) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // l'utilisateur doit appuyer sur un bouton pour fermer
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmer la suppression'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Êtes-vous sûr de vouloir supprimer l\'utilisateur ${client.username} ?'),
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
                  await ClientService().deleteClientById(client.id);
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

  Future<void> _showAddClientDialog(BuildContext context) async {
    final _formKey = GlobalKey<FormState>();
    String _username = '';
    String _email = '';
    String _phone = '';
    String _role = '';
    String _city = "";
    String _quarter = "";

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ajouter un client'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Nom du client'),
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
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Ville'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer une ville';
                      }
                      return null;
                    },
                    onSaved: (newValue) => _city = newValue!,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Quartier'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer un quartier';
                      }
                      return null;
                    },
                    onSaved: (newValue) => _quarter = newValue!,
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
              onPressed: () async{
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  // Ici, vous pouvez ajouter le nouvel utilisateur à votre base de données
                  var data = {
                    "username":_username,
                    "email": _email,
                    "phone": _phone,
                    "role": _role,
                    "city": _city,
                    "quarter": _quarter,
                    "date": DateTime.now().toString()
                  };
                  print(data);

                  await ClientService().addUser(data);
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

  Future<void> _showEditUserDialog(BuildContext context, Client client) async {
    final _formKey = GlobalKey<FormState>();
    String _username = client.username;
    String _email = client.email;
    String _phone = client.phone;
    String _role = client.role;
    String _city = client.city;
    String _quarter = client.quarter;

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Éditer le client'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    initialValue: _username,
                    decoration: InputDecoration(labelText: 'Nom du client'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer un nom ';
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
                  TextFormField(
                    initialValue: _city,
                    decoration: InputDecoration(labelText: 'Ville'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer une adresse';
                      }
                      return null;
                    },
                    onSaved: (newValue) => _city = newValue!,
                  ),
                  TextFormField(
                    initialValue: _quarter,
                    decoration: InputDecoration(labelText: 'Quartier'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer un quartier';
                      }
                      return null;
                    },
                    onSaved: (newValue) => _quarter = newValue!,
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
                    "role": _role,
                    "city": _city,
                    "quarter": _quarter,
                    "date": DateTime.now().toString()
                  };
                  print(data);

                  await ClientService().updateClientById(client.id,data);
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
      if(_currentPage >2 && _currentPage<=(clientList!.length/_itemsPerPage).ceil()){
        _currentPage--;

      }
    });
  }

  void _nextPage() {
    setState(() {
      if(_currentPage < (clientList!.length/_itemsPerPage).ceil()){
        _currentPage++;

      }
    });
  }

}