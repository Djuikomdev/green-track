import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class RapportScreen extends StatefulWidget {
  const RapportScreen({super.key});

  @override
  State<RapportScreen> createState() => _RapportScreenState();
}

class _RapportScreenState extends State<RapportScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      margin: EdgeInsets.all(10),
      height: context.height() / 1.14,
      child: SingleChildScrollView(
        child: Stack(
          children: [
            Center(child: Text("Page de rapport des activites")),
          ],
        ),
      ),
    ));
  }
}
