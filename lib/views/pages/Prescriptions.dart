import 'package:babivision/Utils/Http.dart';
import 'package:babivision/Utils/Time.dart';
import 'package:babivision/Utils/extenstions/ResponsiveContext.dart';
import 'package:babivision/data/KConstants.dart';
import 'package:babivision/data/storage/Cache.dart';
import 'package:babivision/models/Prescription.dart';
import 'package:babivision/views/IconMessage.dart';
import 'package:babivision/views/debug/B.dart';
import 'package:babivision/views/loadingIndicators/StackLoadingIndicator.dart';
import 'package:flutter/material.dart';

class PrescriptionDelegate extends StatelessWidget {
  final String date;
  final double sphOD;
  final double sphOS;
  final double cylOD;
  final double cylOS;
  final double axisOD;
  final double axisOS;
  final double? addOD;
  final double? addOS;
  final double pd;
  final String type;
  final String? notes;
  const PrescriptionDelegate({
    super.key,
    required this.date,
    required this.sphOD,
    required this.sphOS,
    required this.cylOD,
    required this.cylOS,
    required this.axisOD,
    required this.axisOS,
    required this.addOD,
    required this.addOS,
    required this.pd,
    required this.type,
    required this.notes,
  });

  @override
  Widget build(BuildContext context) {
    Widget tableData(
      String? label, {
      EdgeInsetsGeometry padding = const EdgeInsets.all(8.0),
      TextAlign align = TextAlign.center,
      FontWeight fontWeight = FontWeight.normal,
    }) {
      return Padding(
        padding: padding,
        child: Text(
          label ?? "N/A",
          textAlign: label == null ? TextAlign.center : align,
          style: TextStyle(
            fontWeight: fontWeight,
            fontStyle: label == null ? FontStyle.italic : null,
            fontSize: context.fontSizeMin(20),
            color: label == null ? Colors.grey : null,
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

    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: KColors.profileBlue, // border color
          width: 2, // border thickness
        ),
        borderRadius: BorderRadius.circular(12), // rounded corners
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: KColors.profileBlue,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: Text(
                Time.displayFullDate(date),
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
                    tableSpanRow([tableData("$sphOD"), tableData("$sphOS")]),
                  ],
                ),
                TableRow(
                  children: [
                    tableData("Cyl", align: TextAlign.start),
                    tableSpanRow([tableData("$cylOD"), tableData("$cylOS")]),
                  ],
                ),
                TableRow(
                  children: [
                    tableData("Axis", align: TextAlign.start),
                    tableSpanRow([tableData("$axisOD"), tableData("$axisOS")]),
                  ],
                ),
                TableRow(
                  children: [
                    tableData("Add", align: TextAlign.start),
                    tableSpanRow([tableData("$addOD"), tableData("$addOS")]),
                  ],
                ),
                TableRow(
                  children: [
                    tableData("PD", align: TextAlign.start),
                    tableSpanRow([tableData("$pd")]),
                  ],
                ),
                TableRow(
                  children: [
                    tableData("Type", align: TextAlign.start),
                    tableSpanRow([tableData(type)]),
                  ],
                ),
                TableRow(
                  children: [
                    tableData("Notes", align: TextAlign.start),
                    tableSpanRow([tableData(notes, align: TextAlign.start)]),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PrescriptionList extends StatefulWidget {
  final List items;
  final ScrollController? controller;
  const PrescriptionList({super.key, required this.items, this.controller});

  @override
  State<PrescriptionList> createState() => _PrescriptionListState();
}

class _PrescriptionListState extends State<PrescriptionList> {
  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),

      child: GlowingOverscrollIndicator(
        axisDirection: AxisDirection.down,
        color: KColors.profileBlue,
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: widget.controller,
          padding: EdgeInsets.symmetric(horizontal: 8),
          itemBuilder: (context, index) {
            final item = widget.items[index];
            final Prescription prescription = Prescription.fromJSON(item);
            return PrescriptionDelegate(
              date: prescription.date,
              sphOD: prescription.sphOD,
              sphOS: prescription.sphOS,
              cylOD: prescription.cylOD,
              cylOS: prescription.cylOS,
              axisOD: prescription.axisOD,
              axisOS: prescription.axisOS,
              addOD: prescription.addOD,
              addOS: prescription.addOS,
              pd: prescription.pd,
              type: prescription.type,
              notes: prescription.notes,
            );
          },
          separatorBuilder: (context, index) => SizedBox(height: 50),
          itemCount: widget.items.length,
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
  List? _prescriptions;
  final ScrollController _controller = ScrollController();

  Future<void> _fetchPrescriptions() async {
    setState(() {
      _isLoading = true;
      _isError = false;
    });
    try {
      final prescriptions = await Cache.get(
        "prescriptions",
        onExpiredOrMiss: (oldValue) async {
          final response = await Http.get("/api/prescriptions", isAuth: true);
          return response.data['prescriptions'];
        },
        ttl: 600,
      );
      if (mounted)
        setState(() {
          _prescriptions = prescriptions;
          _isLoading = false;
          _isError = false;
        });
    } catch (e) {
      debugPrint(e.toString());
      if (!mounted) return;
      if (e is MissingTokenException || e is AuthenticationFailedException) {
        Navigator.pushReplacementNamed(
          context,
          "/login",
          arguments: {"origin": "/prescriptions", "redirect": "/prescriptions"},
        );
      }
      setState(() {
        _isLoading = false;
        _isError = true;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchPrescriptions();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget content = SizedBox.shrink();

    if (_isLoading)
      content = StackLoadingIndicator.regular();
    else if (_isError)
      content = Center(child: IconMessage.error());
    else if (_prescriptions == null || _prescriptions!.isEmpty)
      content = Center(
        child: IconMessage(
          icon: Icons.event_note_rounded,
          message: "No prescriptions available",
          color: KColors.profileBlue,
          scalableSize: context.fontSizeMin(24),
        ),
      );
    else
      content = Scrollbar(
        thumbVisibility: true,
        trackVisibility: true,
        thickness: 5,
        controller: _controller,
        child: Center(
          child: SizedBox(
            width: double.infinity.max(1000),
            child: Center(
              child: PrescriptionList(
                controller: _controller,
                items: _prescriptions ?? [],
              ),
            ),
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
