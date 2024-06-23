import 'package:expandable_datatable/expandable_datatable.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../models/user_model.dart';


class RackScreen extends StatefulWidget {
  const RackScreen({super.key});

  @override
  State<RackScreen> createState() => _RackScreenState();
}

class _RackScreenState extends State<RackScreen> {
  TextEditingController _searchControlloer = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return  SafeArea(
        child: Container(
          margin: EdgeInsets.all(10),
          height: context.height()/1.14,
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  height: 50,
                  width: 400,
                  child: TextField(

                    onChanged: (value) {
                      if (value.isEmpty) {
                        setState(() {
                          //userList = userList2;
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
              Container(
                padding: EdgeInsets.all(6),
                margin: EdgeInsets.only(top: 80),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10)
                ),
                height: 450,
                child: SingleChildScrollView(
                  child: ListView.builder(
                  itemCount: 30,
                  shrinkWrap: true,
                  itemBuilder: (_, index) {
                    return ExpansionTile(
                      key: ValueKey('rack_$index'),
                      leading: Icon(Icons.group_work),
                      title: Text("   Les racks $index                   nombre de bouteilles : 50"),
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('  Liste des bouteilles du Rack $index :'),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: 50,
                              itemBuilder: (_, bottleIndex) {
                                return ListTile(
                                  title: Text('       Numero: $bottleIndex         Serie : $bottleIndex        Etat: Plein         Localisation: Chez le client'),
                                  // Ajouter ici l'affichage des attributs de chaque bouteille
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                              ),
                ),
              )

            ],
            ),
          )
        ));
  }
}
