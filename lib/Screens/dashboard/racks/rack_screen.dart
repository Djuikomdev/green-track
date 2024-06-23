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
                  child: Container(
                    color: Colors.white,
                    child: TextField(
                      style: TextStyle(color: Colors.black),
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
                        hintStyle: TextStyle(color: Colors.black),
                        suffixIcon: Icon(Icons.close).onTap((){setState(() {
                          _searchControlloer.text = "";
                        });}),
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.search,color: Colors.green,),
                      ),
                    ),
                  ),
                ),
              Container(
                padding: EdgeInsets.all(6),
                margin: EdgeInsets.only(top: 80),
                decoration: BoxDecoration(
                  border: Border.all(),
                  color: Colors.white,
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
                      leading: Icon(Icons.group_work,color: Colors.green,),
                      title: Text("   Les racks $index                   nombre de bouteilles : 50",style: TextStyle(color: Colors.black)),
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
                                  title: Text('       Numero: $bottleIndex         Serie : $bottleIndex        Etat: Plein         Localisation: Chez le client',
                                  style: TextStyle(color: Colors.black),),
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
