import 'dart:async';
import 'dart:convert';
import 'package:covid19india/async.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'api.dart';

class Repository extends ChangeNotifier {
  Map<String, dynamic> casesCountLatest;
  Map<String, dynamic> casesCountHistory;
  Map<String, dynamic> districtData;
  Map<String, dynamic> hospitalBeds;
  Map<String, dynamic> testingDataLatest;

  Repository() {
    initiazlie();
  }

  void initiazlie() {
    getCaseStatsLatest().then((data) {
      if (data.state == Status.success) {
        casesCountLatest = data.object;
      } else {
        casesCountLatest = {};
      }
      notifyListeners();
    });

    getCasesStatsHistory().then((data) {
      if (data.state == Status.success) {
        casesCountHistory = data.object;
      } else {
        casesCountHistory = {};
      }
      notifyListeners();
    });

    getDistrictData().then((data) {
      if (data.state == Status.success) {
        districtData = data.object;
      } else {
        districtData = {};
      }
      notifyListeners();
    });

    getHospitalData().then((data) {
      if (data.state == Status.success) {
        hospitalBeds = data.object;
      } else {
        hospitalBeds = {};
      }
      notifyListeners();
    });

    getTestingData().then((data) {
      if (data.state == Status.success) {
        testingDataLatest = data.object;
      } else {
        testingDataLatest = {};
      }
      notifyListeners();
    });
  }

  static Future<AsyncResponse> getCaseStatsLatest() async =>
      await _makeRequest(Urls.root + Urls.caseStatsLatest);

  static Future<AsyncResponse> getCasesStatsHistory() async =>
      await _makeRequest(Urls.root + Urls.caseStatsHistory);

  static Future<AsyncResponse> getDistrictData() async =>
      await _makeRequest(Urls.districtRoot);

  static Future<AsyncResponse> getHospitalData() async =>
      await _makeRequest(Urls.root + Urls.hospitalBeds);

  static Future<AsyncResponse> getTestingData() async =>
      await _makeRequest(Urls.root + Urls.testingStatsLatest);

  static Future<AsyncResponse> _makeRequest(String url) async {
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return AsyncResponse(Status.success, json.decode(response.body));
      } else {
        throw Exception("Request wasn't successfull");
      }
    } catch (e) {
      return AsyncResponse(Status.exception, e);
    }
  }
}
