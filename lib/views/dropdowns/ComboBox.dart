import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

// Widget _buildCombo({
//     required dynamic value,
//     required ComboPlaceHolder placeHolder,
//     required List? items,
//     bool isLoading = false,
//     required void Function(Object?) onChanged,
//   }) {
//     items = isLoading ? [] : items;
//     assert(isLoading || items != null, "either must be loading or has items");
//     List itemsWPlaceHolder = [placeHolder, ...items!];

//     TextStyle getTextStyle(int id) {
//       return TextStyle(
//         color: id == -1 ? Colors.grey : Colors.black,
//         fontStyle: id == -1 ? FontStyle.italic : FontStyle.normal,
//         fontSize: context.responsiveExplicit(
//           fallback: 9,
//           onWidth: {
//             350: 10,
//             400: 11,
//             450: 12,
//             500: 14,
//             600: 16,
//             700: 18,
//             800: 20,
//             1000: 22,
//           },
//         ),
//       );
//     }

//     final List<DropdownMenuItem<Object>> dropdownItems =
//         isLoading
//             ? [
//               DropdownMenuItem(
//                 value: placeHolder,
//                 child: Text(
//                   placeHolder.name,
//                   style: getTextStyle(placeHolder.id),
//                 ),
//               ),
//               DropdownMenuItem(
//                 enabled: false,
//                 child: Center(child: CircularProgressIndicator()),
//               ),
//             ]
//             : itemsWPlaceHolder
//                 .map(
//                   (item) => DropdownMenuItem(
//                     //alignment: Alignment.center,
//                     value: item,
//                     child: Text(item.name, style: getTextStyle(item.id)),
//                   ),
//                 )
//                 .toList();

//     return DropdownButton(
//       value: value,
//       isExpanded: true,
//       alignment: Alignment.center,
//       selectedItemBuilder: (context) {
//         return itemsWPlaceHolder.map((item) {
//           return Center(child: Text(item.name, style: getTextStyle(item.id)));
//         }).toList();
//       },
//       items: dropdownItems,
//       onChanged: onChanged,
//     );
//   }

class Combobox<T> extends StatefulWidget {
  final T value;
  final T placeHolder;
  final Widget placeHolderWidget;
  final List<DropdownMenuItem>? items;
  final bool isLoading;
  final Widget loadingIndicator;
  final Future<Response<dynamic>> Function() fetcher;
  final void Function(T?)? onChanged;
  const Combobox({
    super.key,
    required this.value,
    required this.placeHolder,
    required this.placeHolderWidget,
    required this.onChanged,
    required this.fetcher,
    this.items,
    this.isLoading = false,
    this.loadingIndicator = const Center(child: CircularProgressIndicator()),
  });

  @override
  State<Combobox> createState() => _ComboboxState();
}

class _ComboboxState extends State<Combobox> {
  late bool _isLoading;
  dynamic _data;

  @override
  void initState() async {
    // TODO: implement initState
    super.initState();
    _isLoading = widget.isLoading;
    // setState(() {
    //   _isLoading = true;
    // });
    // _data = await widget.fetcher();
    // setState(() {
    //   _isLoading = false;
    // });
  }

  @override
  Widget build(BuildContext context) {
    assert(
      widget.isLoading || widget.items != null,
      "either must be loading or has items",
    );
    // List<DropdownMenuItem>? items =
    //     _isLoading
    //         ? [
    //           DropdownMenuItem(
    //             value: widget.placeHolder,
    //             child: widget.placeHolderWidget,
    //           ),
    //           DropdownMenuItem(enabled: false, child: widget.loadingIndicator),
    //         ]
    //         : widget.items!;

    List<DropdownMenuItem>? items = [
      DropdownMenuItem(
        value: widget.placeHolder,
        child: widget.placeHolderWidget,
      ),
    ];

    return DropdownButton(
      value: widget.value,
      items: items,
      onChanged: widget.onChanged,
    );
  }
}
