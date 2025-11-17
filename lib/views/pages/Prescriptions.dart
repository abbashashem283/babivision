import 'package:babivision/Utils/extenstions/ResponsiveContext.dart';
import 'package:babivision/data/KConstants.dart';
import 'package:babivision/views/IconMessage.dart';
import 'package:babivision/views/debug/B.dart';
import 'package:babivision/views/loadingIndicators/StackLoadingIndicator.dart';
import 'package:flutter/material.dart';

class PrescriptionDelegate extends StatelessWidget {
  const PrescriptionDelegate({super.key});

  @override
  Widget build(BuildContext context) {
    Widget tableData(
      String label, {
      EdgeInsetsGeometry padding = const EdgeInsets.all(8.0),
      TextAlign align = TextAlign.center,
      FontWeight fontWeight = FontWeight.normal,
    }) {
      return Padding(
        padding: padding,
        child: Text(
          label,
          textAlign: align,
          style: TextStyle(
            fontWeight: fontWeight,
            fontSize: context.fontSizeMin(20),
          ),
        ),
      );
    }

    Row tableSpanRow(List<Widget> children) {
      return Row(
        children:
            children.map((child) {
              bool isLast = child == children[children.length - 1];
              BoxBorder? border =
                  isLast ? null : Border(right: BorderSide(color: Colors.grey));
              return Expanded(
                child: Container(
                  decoration: BoxDecoration(border: border),
                  child: child,
                ),
              );
            }).toList(),
      );
    }

    return B(
      color: "r",
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: KColors.profileBlue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "2025-11-03",
                  style: TextStyle(
                    fontSize: context.fontSizeMin(20),
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 30),
              Table(
                border: TableBorder.all(color: Colors.grey),
                columnWidths: {
                  0: FlexColumnWidth(6),
                  1: FlexColumnWidth(4),
                  //2: FlexColumnWidth(2),
                },
                children: [
                  TableRow(
                    children: [
                      SizedBox.shrink(),
                      tableSpanRow([
                        tableData("OD", fontWeight: FontWeight.bold),
                        tableData("OS", fontWeight: FontWeight.bold),
                      ]),
                    ],
                  ),
                  TableRow(
                    children: [
                      tableData("Sph", align: TextAlign.start),
                      tableSpanRow([tableData("-2.25"), tableData("-1.75")]),
                    ],
                  ),
                  TableRow(
                    children: [
                      tableData("Cyl", align: TextAlign.start),
                      tableSpanRow([tableData("-1.00"), tableData("-0.50")]),
                    ],
                  ),
                  TableRow(
                    children: [
                      tableData("Axis", align: TextAlign.start),
                      tableSpanRow([tableData("180"), tableData("165")]),
                    ],
                  ),
                  TableRow(
                    children: [
                      tableData("Add", align: TextAlign.start),
                      tableSpanRow([tableData("+2"), tableData("+2")]),
                    ],
                  ),
                  TableRow(
                    children: [
                      tableData("PD", align: TextAlign.start),
                      tableSpanRow([tableData("63")]),
                    ],
                  ),
                  TableRow(
                    children: [
                      tableData("Type", align: TextAlign.start),
                      tableSpanRow([tableData("Single Vision")]),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: Container(
                      color: Colors.red,
                      child: Text(
                        "hi",
                        style: TextStyle(fontSize: context.fontSizeMin(20)),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(color: Colors.blue, height: 50),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Prescriptions extends StatefulWidget {
  const Prescriptions({super.key});

  @override
  State<Prescriptions> createState() => _PrescriptionsState();
}

class _PrescriptionsState extends State<Prescriptions> {
  bool _isLoading = false, _isError = false;

  Future<void> _fetchPrescriptions() async {
    setState(() {
      _isLoading = true;
      _isError = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = SizedBox.shrink();

    if (_isLoading)
      content = StackLoadingIndicator.regular();
    else if (_isError)
      content = Center(child: IconMessage.error());
    else
      content = Center(
        child: B(
          child: SizedBox(
            width: double.infinity.max(1000),
            child: Center(child: PrescriptionDelegate()),
          ),
        ),
      );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(
          "Prescriptions",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: content,
    );
  }
}
