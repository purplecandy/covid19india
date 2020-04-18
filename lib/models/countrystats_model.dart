class CountryOverallModel {
  final int confirmedCasesIndian,
      confirmedCasesForeign,
      discharged,
      deaths,
      totalConfirmed,
      active;

  CountryOverallModel(
      {this.confirmedCasesForeign,
      this.confirmedCasesIndian,
      this.discharged,
      this.deaths,
      this.totalConfirmed,
      this.active});

  factory CountryOverallModel.fromJson(Map<String, dynamic> json) =>
      CountryOverallModel(
          active: json["confirmedCasesIndian"] -
              (json["discharged"] + json["deaths"]),
          confirmedCasesIndian: json["confirmedCasesIndian"],
          confirmedCasesForeign: json["confirmedCasesForeign"],
          deaths: json["deaths"],
          discharged: json["discharged"],
          totalConfirmed: json["total"]);
}
