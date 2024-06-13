import 'package:expandable_datatable/expandable_datatable.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../models/user_model.dart';


class VentesScreen extends StatefulWidget {
  const VentesScreen({super.key});

  @override
  State<VentesScreen> createState() => _VentesScreenState();
}

class _VentesScreenState extends State<VentesScreen> {

  @override
  Widget build(BuildContext context) {

    return SafeArea(
        child: Container(
          margin: EdgeInsets.all(10),
          height: context.height()/1.14,
          child: Column(
            children: [

              Container(
                height: 50,
              ),
              Container(
                height: 50,
                color: Colors.deepOrange,
                margin: EdgeInsets.all(10),
              ),
              Container(
                height: 450,
                child: SingleChildScrollView(
                  child: ListView.builder(
                    itemCount: 20,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (_,index){
                    return Container(
                      child: ListTile(
                        leading: Icon(Icons.sell_outlined),
                        title: Text("Item $index"),
                      ),
                    );
                  }),
                ),
              )
            ],
          )
        ));
  }
}
