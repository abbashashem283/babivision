class Prescription {
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

  Prescription({
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

  factory Prescription.fromJSON(final Map json) {
    return Prescription(
      date: json['date'],
      sphOD: json['sph_od'],
      sphOS: json['sph_os'],
      cylOD: json['cyl_od'],
      cylOS: json['cyl_os'],
      axisOD: json['axis_od'],
      axisOS: json['axis_os'],
      addOD: json['add_od'],
      addOS: json['add_os'],
      pd: json['pd'],
      type: json['type'],
      notes: json['notes'],
    );
  }
}
