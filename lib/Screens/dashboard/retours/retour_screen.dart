import 'package:flutter/material.dart';


class RetourScreen extends StatefulWidget {
  const RetourScreen({super.key});

  @override
  State<RetourScreen> createState() => _RetourScreenState();
}

class _RetourScreenState extends State<RetourScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Container(child: Column(
      children: [
        Text("retour des bouteilles")
      ],
    ),));
  }
}
