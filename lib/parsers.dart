import 'dart:async';
import 'package:covid19india/async.dart';

Future<AsyncResponse> filterCaseStatsLatest(
    String stateName, Map<String, dynamic> jsonData) async {
  try {
    if (jsonData["success"] == true) {
      for (var item in jsonData["data"]["regional"]) {
        if (item["loc"] == stateName)
          return AsyncResponse(Status.success, item);
      }
      return AsyncResponse(Status.error, "Couldn't find any record");
    } else {
      throw Exception("Request wasn't successfull");
    }
  } catch (e) {
    return AsyncResponse(Status.exception, e);
  }
}

Future<AsyncResponse> filterCasesStatsHistory(
    String stateName, Map<String, dynamic> jsonData) async {
  try {
    if (jsonData["success"] == true) {
      List<Map<String, dynamic>> listOfStats = [];

      for (var item in jsonData["data"]) {
        for (var section in item["regional"]) {
          if (section["loc"] == stateName)
            listOfStats.add({"day": item["day"], "regional": section});
        }
      }
      return listOfStats.length > 0
          ? AsyncResponse(Status.success, listOfStats)
          : AsyncResponse(Status.error, "Couldn't find any record");
    } else {
      throw Exception("Request wasn't successfull");
    }
  } catch (e) {
    return AsyncResponse(Status.exception, e);
  }
}
