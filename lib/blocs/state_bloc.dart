import 'package:covid19india/async.dart';
import 'package:covid19india/bloc_base.dart';
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
