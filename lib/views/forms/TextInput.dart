import 'package:babivision/data/KConstants.dart';
import 'package:babivision/views/debug/B.dart';
import 'package:flutter/material.dart';

class TextInput extends StatefulWidget {
  final bool obscureText;
  final String labelText;
  final String? errorText;
  final TextEditingController? controller;

  const TextInput({
    super.key,
    this.obscureText = false,
    this.controller,
    required this.labelText,
    this.errorText,
  });

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  late bool obscureText;
  late String labelText;
  bool _ishidden = true;
  TextEditingController? controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isError = widget.errorText != null;

    return B(
      color: "tr",
      child: SizedBox(
        height: widget.errorText == null ? 50 : 70,
        child: TextField(
          obscureText: widget.obscureText && _ishidden,
          controller: widget.controller,
          style: TextStyle(color: Colors.grey[500]),
          decoration: InputDecoration(
            labelText: widget.labelText,
            errorText: widget.errorText,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.pink),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.red, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.red[900]!, width: 2),
            ),
            constraints: BoxConstraints(maxHeight: 50),
            suffixIcon:
                widget.obscureText
                    ? IconButton(
                      onPressed: () {
                        setState(() {
                          _ishidden = !_ishidden;
                        });
                      },
                      icon: Icon(
                        _ishidden ? Icons.visibility_off : Icons.visibility,
                        color:
                            isError
                                ? Colors.red
                                : const Color.fromARGB(255, 150, 36, 170),
                        fill: 0.6,
                        size: 30,
                      ),
                    )
                    : null,

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
      ),
    );
  }
}
