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

Future<AsyncResponse> filterDistrictsByRegion(
    String stateName, Map<String, dynamic> jsonData) async {
  try {
    if (jsonData.isNotEmpty) {
      List<Map<String, dynamic>> listOfDistricts = [];
      if (jsonData.containsKey(stateName)) {
        // var keys = jsonData[stateName]["districtData"];
        for (var key in jsonData[stateName]["districtData"].keys) {
          listOfDistricts.add({
            "name": key,
            "confirmed": jsonData[stateName]["districtData"][key]["confirmed"]
          });
        }
      }
      return listOfDistricts.length > 0
          ? AsyncResponse(Status.success, listOfDistricts)
          : AsyncResponse(Status.error, "Couldn't find any record");
    } else {
      throw Exception("Request wasn't successfull");
    }
  } catch (e) {
    return AsyncResponse(Status.exception, e);
  }
}

Future<AsyncResponse> filterHospitalsByRegion(
    String stateName, Map<String, dynamic> jsonData) async {
  try {
    if (jsonData.isNotEmpty) {
      Map<String, dynamic> dataSet = {};
      for (var item in jsonData["data"]["regional"]) {
        if (item["state"].toLowerCase() == stateName.toLowerCase())
          dataSet = item;
      }
      return dataSet.length > 0
          ? AsyncResponse(Status.success, dataSet)
          : AsyncResponse(Status.error, "Couldn't find any record");
    } else {
      throw Exception("Request wasn't successfull");
    }
  } catch (e) {
    return AsyncResponse(Status.exception, e);
  }
}

Future<AsyncResponse> filterCountryStatsLatest(
    Map<String, dynamic> jsonData) async {
  try {
    if (jsonData.isNotEmpty) {
      return AsyncResponse(Status.success, jsonData["data"]["summary"]);
    } else {
      throw Exception("Request wasn't successfull");
    }
  } catch (e) {
    return AsyncResponse(Status.exception, e);
  }
}

Future<AsyncResponse> filterCountryStatsHistory(
    Map<String, dynamic> jsonData) async {
  try {
    if (jsonData["success"] == true) {
      List<Map<String, dynamic>> listOfStats = [];

      for (var item in jsonData["data"]) {
        listOfStats.add({"day": item["day"], "summary": item["summary"]});
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

Future<AsyncResponse> filterCountryRegions(
    Map<String, dynamic> jsonData) async {
  try {
    if (jsonData["success"] == true) {
      return AsyncResponse(Status.success, jsonData["data"]["regional"]);
    } else {
      throw Exception("Request wasn't successfull");
    }
  } catch (e) {
    return AsyncResponse(Status.exception, e);
  }
}
