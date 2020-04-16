import 'package:covid19india/async.dart';
import 'package:covid19india/blocs/regional_bloc.dart';
import 'package:covid19india/parsers.dart';
import 'package:covid19india/repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Test regional bloc", () {
    test("Status should be successfull", () async {
      final jsonData = await Repository.getCasesStatsHistory();
      final blocData = RegionalStatsData();

      blocData.dispatch(RegionalAction.fetch,
          {"state_name": "Maharashtra", "json_data": jsonData.object});

      blocData.stream.listen(expectAsync1((event) {
        if (event.state == RegionalState.done) {
          final data = blocData.getTotalCasesByDays(4);
          expect(data,
              //provide manually calculated values
              {
                "confirmed": 2916,
                "recovered": 295,
                "deaths": 186,
                "active": (2916 - 295 + 186)
              });
        }
      }, count: 2));
    });
  });
}
