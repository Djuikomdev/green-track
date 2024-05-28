import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';


class CustomButon extends StatefulWidget {
  const CustomButon({super.key, required this.onPress, required this.title, required this.color});
  final VoidCallback onPress;
  final String title;
  final Color color;

  @override
  State<CustomButon> createState() => _CustomButonState();
}

class _CustomButonState extends State<CustomButon> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 370,
      child: Row(
        children: [
          Expanded(
            child: AppButton(
              onTap: widget.onPress,
              color: widget.color,
              child: Text(widget.title),
            ),
          ),

        ],
      ),
    );
  }
}
