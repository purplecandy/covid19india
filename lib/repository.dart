import 'dart:async';
import 'dart:convert';
import 'package:covid19india/async.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'api.dart';

class Repository extends ChangeNotifier {
  Map<String, dynamic> casesCountLatest = {};
  Map<String, dynamic> casesCountHistory = {};
  Map<String, dynamic> districtData = {};
  Map<String, dynamic> hospitalBeds = {};

  Repository() {
    initiazlie();
  }

  void initiazlie() async {
    await getCaseStatsLatest().then((data) {
      if (data.state == Status.success) {
        casesCountLatest = data.object;
      }
    });

    await getCasesStatsHistory().then((data) {
      if (data.state == Status.success) {
        casesCountHistory = data.object;
      }
    });

    await getDistrictData().then((data) {
      if (data.state == Status.success) {
        districtData = data.object;
      }
    });
    notifyListeners();
  }

  static Future<AsyncResponse> getCaseStatsLatest() async {
    final url = Urls.root + Urls.caseStatsLatest;
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

  static Future<AsyncResponse> getCasesStatsHistory() async {
    final url = Urls.root + Urls.caseStatsHistory;
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

  static Future<AsyncResponse> getDistrictData() async {
    final url = Urls.districtRoot;
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
