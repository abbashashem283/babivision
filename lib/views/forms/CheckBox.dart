import 'package:flutter/material.dart';

class CheckBox extends StatefulWidget {
  final bool initialValue;
  final Function()? onChecked;
  final Function()? onUnChecked;
  final Color? activeColor;
  const CheckBox({
    super.key,
    required this.initialValue,
    this.onChecked,
    this.onUnChecked,
    this.activeColor,
  });

  @override
  State<CheckBox> createState() => _CheckBoxState();
}

class _CheckBoxState extends State<CheckBox> {
  late bool _currentValue;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: _currentValue,
      activeColor: widget.activeColor,
      onChanged: (value) {
        value as bool;
        if (value == true) {
          widget.onChecked?.call();
        } else {
          widget.onUnChecked?.call();
        }
        setState(() {
          _currentValue = value;
        });
      },
    );
  }
}
