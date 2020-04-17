class HospitalModel {
  final String state;
  final int ruralH, ruralB, urbanH, urbanB, totalHospitals, totalBeds;
  final DateTime lastUpdated;
  HospitalModel(
      {this.state,
      this.ruralH,
      this.ruralB,
      this.urbanB,
      this.urbanH,
      this.totalBeds,
      this.totalHospitals,
      this.lastUpdated});

  factory HospitalModel.fromJson(Map<String, dynamic> jsonData) =>
      HospitalModel(
          state: jsonData["state"],
          ruralH: jsonData["ruralHospitals"],
          ruralB: jsonData["ruralBeds"],
          urbanH: jsonData["urbanHospitals"],
          urbanB: jsonData["urbanBeds"],
          totalHospitals: jsonData["totalHospitals"],
          totalBeds: jsonData["totalBeds"],
          lastUpdated: DateTime.parse(jsonData["asOn"]));
}
