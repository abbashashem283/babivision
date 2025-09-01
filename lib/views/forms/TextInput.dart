import 'package:babivision/data/KConstants.dart';
import 'package:flutter/material.dart';

class TextInput extends StatefulWidget {
  final bool obscureText;
  final String labelText;
  final TextEditingController? controller;

  const TextInput({
    super.key,
    this.obscureText = false,
    this.controller,
    required this.labelText,
  });

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  late bool obscureText;
  late String labelText;
  TextEditingController? controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: TextField(
        obscureText: widget.obscureText,
        controller: widget.controller,
        style: TextStyle(color: Colors.grey[500]),
        decoration: InputDecoration(
          labelText: widget.labelText,
          labelStyle: TextStyle(color: Colors.grey[400]!),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey[400]!, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: KColors.getColor(context, "primary"),
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}
