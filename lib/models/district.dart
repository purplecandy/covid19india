class DistrictModel {
  final int confirmedCases;
  final String name;
  DistrictModel({this.confirmedCases, this.name});

  factory DistrictModel.fromJson(Map<String, dynamic> jsonData) =>
      DistrictModel(
          confirmedCases: jsonData["confirmed"], name: jsonData["name"]);
}
