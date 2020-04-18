class TestingModel {
  final DateTime date;
  final String source;
  final int totalSamplesTested, totalIndividualsTested, totalPositiveCases;

  TestingModel(
      {this.date,
      this.source,
      this.totalSamplesTested,
      this.totalIndividualsTested,
      this.totalPositiveCases});

  factory TestingModel.fromJson(Map<String, dynamic> jsonData) => TestingModel(
        date: DateTime.parse(jsonData["day"]),
        totalSamplesTested: jsonData["totalSamplesTested"],
        totalIndividualsTested: jsonData["totalIndividualsTested"],
        totalPositiveCases: jsonData["totalPositiveCases"],
        source: jsonData["source"],
      );
}
