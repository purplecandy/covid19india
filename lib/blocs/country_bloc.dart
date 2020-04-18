import 'package:covid19india/async.dart';
import 'package:covid19india/bloc_base.dart';
import 'package:covid19india/models/countrystats_model.dart';
import 'package:covid19india/models/entity.dart';
import 'package:covid19india/parsers.dart';

enum CountryState { loading, done, empty, exception }
enum CountryAction {
  ///Regquires: `String:state_name`, `Map<String,dynamic>:json_data`
  fetch
}

class CountryOverallBloc
    extends BlocBase<CountryState, CountryAction, CountryOverallModel> {
  CountryOverallBloc()
      : super(state: CountryState.loading, object: CountryOverallModel());

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void dispatch(CountryAction actionState, [Map<String, dynamic> data]) {
    switch (actionState) {
      case CountryAction.fetch:
        _fetch(data["json_data"]);
        break;
      default:
    }
  }

  void _fetch(Map<String, dynamic> jsonData) async {
    filterCountryStatsLatest(jsonData).then((data) {
      if (data.state == Status.success) {
        final model = CountryOverallModel.fromJson(data.object);
        updateState(CountryState.done, model);
      } else if (data.state == Status.error) {
        updateState(CountryState.empty, event.object);
      } else {
        updateStateWithError(data.object);
      }
    });
  }
}

class CountryStatsBloc extends BlocBase<CountryState, CountryAction,
    List<Entity<CountryOverallModel>>> {
  CountryStatsBloc() : super(state: CountryState.loading, object: []);

  @override
  void dispatch(CountryAction actionState, [Map<String, dynamic> data]) {
    switch (actionState) {
      case CountryAction.fetch:
        _fetch(data["json_data"]);
        break;
      default:
    }
  }

  void _fetch(Map<String, dynamic> jsonData) async {
    filterCountryStatsHistory(jsonData).then((data) {
      if (data.state == Status.success) {
        List<Entity<CountryOverallModel>> entities = [];
        for (var item in data.object) {
          entities.add(Entity(
              date: DateTime.parse(item["day"]),
              data: CountryOverallModel.fromJson(item["summary"])));
        }
        updateState(CountryState.done, entities);
      } else if (data.state == Status.error) {
        updateState(CountryState.empty, event.object);
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