import 'package:expandable_datatable/expandable_datatable.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../models/user_model.dart';


class ProductionScreen extends StatefulWidget {
  const ProductionScreen({super.key});

  @override
  State<ProductionScreen> createState() => _ProductionScreenState();
}

class _ProductionScreenState extends State<ProductionScreen> {

  @override
  Widget build(BuildContext context) {

    return SafeArea(
        child: Container(
          margin: EdgeInsets.all(10),
          height: context.height()/1.14,
          child: Text("en attente de data")
        ));
  }
}
