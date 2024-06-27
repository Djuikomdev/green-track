import 'package:expandable_datatable/expandable_datatable.dart';
import 'package:flutter/material.dart';
import 'package:greentrack/models/rack_model.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../models/user_model.dart';
import '../../../services/rack_service.dart';

List<Rack>? rackList = [];


class RackScreen extends StatefulWidget {
  const RackScreen({super.key});

  @override
  State<RackScreen> createState() => _RackScreenState();
}

class _RackScreenState extends State<RackScreen> {
  TextEditingController _searchControlloer = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(rackList!.isEmpty){
      init();
    }else{
      setState(() {
        initPage = true;
      });
    }
  }
  bool initPage = false;

  init()async{
    var data = await RackService().getRacks();
    setState(() {
      rackList = data;
      initPage = true;
    });
  }

  @override
  Widget build(BuildContext context) {

    return  initPage == false?
        Center(
          child: CircularProgressIndicator(),
        ):SafeArea(
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
                  child: rackList!.isEmpty?
                      Center(
                        child: Text("Aucun rack disponible"),
                      ): ListView.builder(
                  itemCount: rackList!.length,
                  shrinkWrap: true,
                  itemBuilder: (_, index) {
                    return ExpansionTile(
                      key: ValueKey('rack_$index'),
                      leading: Icon(Icons.group_work,color: Colors.green,),
                      title: Text("    ${rackList![index].name}                   nombre de bouteilles : ${rackList![index].bottles.length} ",style: TextStyle(color: Colors.black)),
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('  Liste des bouteilles du ${rackList![index].name} :'),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: rackList![index].bottles.length,
                              itemBuilder: (_, bottleIndex) {
                                return ListTile(
                                  title: Text('       Numero: ${rackList![index].bottles[bottleIndex].nbBottle}         Serie : ${rackList![index].bottles[bottleIndex].nbSerie}         Etat: ${rackList![index].bottles[bottleIndex].state}          Localisation: ${rackList![index].bottles[bottleIndex].localisation} ',
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
