import 'package:covid19india/async.dart';
import 'package:covid19india/parsers.dart';
import 'package:covid19india/repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Get latest case counts by country", () {
    test("Status should be successfull", () async {
      final jsonData = await Repository.getCaseStatsLatest();
      final data = await filterCaseStatsLatest("Maharashtra", jsonData.object);
      expect(data.state, Status.success);
      expect(data.object["loc"], "Maharashtra");
    });

    test("Status should contain an error", () async {
      final jsonData = await Repository.getCaseStatsLatest();
      final data = await filterCaseStatsLatest("", jsonData.object);
      expect(data.state, Status.error);
      expect(data.object, "Couldn't find any record");
    });

    // test("status should contain an exception", () async {
    //   final data = await getCaseStatsLatest("");
    //   expect(data.state, Status.exception);
    // });
  });

  group("Get history of case counts by state", () {
    test("Status should be successfull", () async {
      final jsonData = await Repository.getCasesStatsHistory();
      final data =
          await filterCasesStatsHistory("Maharashtra", jsonData.object);
      expect(data.state, Status.success);
      expect(data.object.length, greaterThan(0));
    });

    test("Status should contain an error", () async {
      final jsonData = await Repository.getCasesStatsHistory();
      final data = await filterCasesStatsHistory("", jsonData.object);
      expect(data.state, Status.error);
      expect(data.object, "Couldn't find any record");
    });
  });

  group("Test district wise api", () {
    test("Get all district data", () async {
      final jsonData = await Repository.getDistrictData();
      expect(jsonData.object.containsKey("Uttar Pradesh"), true);
    });

    test("Get all district data by state", () async {
      final stateName = "Jammu and Kashmir";
      final jsonData = await Repository.getDistrictData();
      final data = await filterDistrictsByRegion(stateName, jsonData.object);
      expect(data.state, Status.success);
      expect(data.object.length,
          jsonData.object[stateName]["districtData"].length);
    });
  });
}
