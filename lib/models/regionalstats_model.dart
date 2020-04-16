class RegionalStatsModel {
  final String loc;
  final int confirmedCasesIndian,
      confirmedCasesForeign,
      discharged,
      deaths,
      totalConfirmed;

  RegionalStatsModel(
      {this.loc,
      this.confirmedCasesForeign,
      this.confirmedCasesIndian,
      this.discharged,
      this.deaths,
      this.totalConfirmed});

  factory RegionalStatsModel.fromJson(Map<String, dynamic> json) =>
      RegionalStatsModel(
          loc: json["loc"],
          confirmedCasesIndian: json["confirmedCasesIndian"],
          confirmedCasesForeign: json["confirmedCasesForeign"],
          deaths: json["deaths"],
          discharged: json["discharged"],
          totalConfirmed: json["totalConfirmed"]);
}
