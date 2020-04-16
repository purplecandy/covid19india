import 'package:covid19india/async.dart';
import 'package:covid19india/bloc_base.dart';
import 'package:covid19india/models/entity.dart';
import 'package:covid19india/models/regionalstats_model.dart';
import 'package:covid19india/parsers.dart';

enum RegionalState { loading, done }
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
    if (days > len) {
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
