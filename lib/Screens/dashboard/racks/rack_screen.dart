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

  @override
  Widget build(BuildContext context) {

    return  SafeArea(
        child: Container(
          margin: EdgeInsets.all(10),
          height: context.height()/1.14,
          child: Text("en attente de data")
        ));
  }
}
