import 'dart:async';

import 'package:covid19india/async.dart';
import 'package:covid19india/bloc_base.dart';
import 'package:covid19india/models/district.dart';
import 'package:covid19india/models/entity.dart';
import 'package:covid19india/models/hospital.dart';
import 'package:covid19india/models/regionalstats_model.dart';
import 'package:covid19india/parsers.dart';

enum RegionalState { loading, done, empty, exception }
enum RegionalAction {
  ///Regquires: `String:state_name`, `Map<String,dynamic>:json_data`
  fetch
}

class RegionalStatsBloc
    extends BlocBase<RegionalState, RegionalAction, RegionalStatsModel> {
  RegionalStatsBloc()
      : super(state: RegionalState.loading, object: RegionalStatsModel());

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void dispatch(RegionalAction actionState, [Map<String, dynamic> data]) {
    switch (actionState) {
      case RegionalAction.fetch:
        _fetch(data["state_name"], data["json_data"]);
        break;
      default:
    }
  }

  void _fetch(String stateName, Map<String, dynamic> jsonData) async {
    filterCaseStatsLatest(stateName, jsonData).then((data) {
      if (data.state == Status.success) {
        final model = RegionalStatsModel.fromJson(data.object);
        updateState(RegionalState.done, model);
      } else if (data.state == Status.error) {
        updateState(RegionalState.empty, event.object);
      } else {
        updateStateWithError(data.object);
      }
    });
  }
}

class RegionalStatsData extends BlocBase<RegionalState, RegionalAction,
    List<Entity<RegionalStatsModel>>> {
  RegionalStatsData() : super(state: RegionalState.loading, object: []);

  @override
  void dispatch(RegionalAction actionState, [Map<String, dynamic> data]) {
    switch (actionState) {
      case RegionalAction.fetch:
        _fetch(data["state_name"], data["json_data"]);
        break;
      default:
    }
  }

  void _fetch(String stateName, Map<String, dynamic> jsonData) async {
    filterCasesStatsHistory(stateName, jsonData).then((data) {
      if (data.state == Status.success) {
        List<Entity<RegionalStatsModel>> entities = [];
        for (var item in data.object) {
          entities.add(Entity(
              date: DateTime.parse(item["day"]),
              data: RegionalStatsModel.fromJson(item["regional"])));
        }
        updateState(RegionalState.done, entities);
      } else if (data.state == Status.error) {
        updateState(RegionalState.empty, event.object);
      } else {
        updateStateWithError(data.object);
      }
    });
  }

  Map<String, dynamic> getTotalCasesByDays(int days) {
    Map<String, dynamic> cases = {
      "confirmed": 0,
      "active": 0,
      "recovered": 0,
      "deaths": 0
    };
    int len = event.object.length;
    var prev, curr = event.object.last.data;
    if (days + 1 > len) {
      prev = event.object.first.data;
    } else {
      prev = event.object[len - days - 1].data;
    }
    cases["confirmed"] += (curr.totalConfirmed - prev.totalConfirmed).abs();
    cases["deaths"] += (curr.deaths - prev.deaths).abs();
    cases["recovered"] += (curr.discharged - prev.discharged).abs();
    cases["active"] =
        cases["confirmed"] - (cases["recovered"] + cases["deaths"]);

    return cases;
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class RegionalDistrictBloc
    extends BlocBase<RegionalState, RegionalAction, List<DistrictModel>> {
  RegionalDistrictBloc() : super(state: RegionalState.loading, object: []);

  @override
  void dispatch(RegionalAction actionState, [Map<String, dynamic> data]) {
    switch (actionState) {
      case RegionalAction.fetch:
        _fetch(data["state_name"], data["json_data"]);
        break;
      default:
    }
  }

  void _fetch(String stateName, Map<String, dynamic> jsonData) async {
    filterDistrictsByRegion(stateName, jsonData).then((data) {
      if (data.state == Status.success) {
        List<DistrictModel> districts = [];
        for (var item in data.object) {
          districts.add(DistrictModel.fromJson(item));
        }
        int limit = 5;
        if (districts.length < 5) limit = districts.length;
        districts.sort((a, b) => b.confirmedCases.compareTo(a.confirmedCases));
        updateState(RegionalState.done, districts.sublist(0, limit));
      } else if (data.state == Status.error) {
        updateState(RegionalState.empty, event.object);
      } else {
        updateStateWithError(data.object);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class RegionalHospitalsData
    extends BlocBase<RegionalState, RegionalAction, HospitalModel> {
  RegionalHospitalsData()
      : super(state: RegionalState.loading, object: HospitalModel());

  @override
  void dispatch(RegionalAction actionState, [Map<String, dynamic> data]) {
    switch (actionState) {
      case RegionalAction.fetch:
        _fetch(data["state_name"], data["json_data"]);
        break;
      default:
    }
  }

  void _fetch(String stateName, Map<String, dynamic> jsonData) async {
    filterHospitalsByRegion(stateName, jsonData).then((data) {
      if (data.state == Status.success) {
        updateState(RegionalState.done, HospitalModel.fromJson(data.object));
      } else if (data.state == Status.error) {
        updateState(RegionalState.empty, event.object);
      } else {
        updateStateWithError(data.object);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
