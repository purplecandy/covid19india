import 'package:covid19india/blocs/regional_bloc.dart';
import 'package:covid19india/repository.dart';
import 'package:covid19india/widgets/overall_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:covid19india/preferences.dart';
import 'package:covid19india/widgets/header_tile.dart';
import 'package:covid19india/widgets/district_data.dart';
import 'package:covid19india/widgets/hospital_data.dart';
import 'package:covid19india/widgets/charts/charts.dart';

class RegionalPage extends StatefulWidget {
  RegionalPage({Key key}) : super(key: key);

  @override
  _RegionalPageState createState() => _RegionalPageState();
}

class _RegionalPageState extends State<RegionalPage> {
  final bloc = RegionalStatsBloc();
  final blocData = RegionalStatsData();
  final blocDistrict = RegionalDistrictBloc();
  final blocHospital = RegionalHospitalsData();
  final chartType = ChartType();
  int activeIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final repo = Provider.of<Repository>(context, listen: true);
    final pref = Provider.of<Preferences>(context, listen: true);
    if (repo.casesCountLatest.isNotEmpty) {
      if (pref.initialized && pref.defaultStateName.isNotEmpty) {
        startup(repo, pref.defaultStateName);
      }
    }
    super.didChangeDependencies();
  }

  void startup(Repository repo, String stateName) {
    bloc.dispatch(RegionalAction.fetch,
        {"state_name": stateName, "json_data": repo.casesCountLatest});
    blocData.dispatch(RegionalAction.fetch,
        {"state_name": stateName, "json_data": repo.casesCountHistory});
    blocDistrict.dispatch(RegionalAction.fetch,
        {"state_name": stateName, "json_data": repo.districtData});
    blocHospital.dispatch(RegionalAction.fetch,
        {"state_name": stateName, "json_data": repo.hospitalBeds});
  }

  @override
  Widget build(BuildContext context) {
    return Provider<RegionalStatsBloc>(
      create: (_) => bloc,
      child: Provider<RegionalStatsData>(
          create: (_) => blocData,
          child: Provider<RegionalDistrictBloc>(
            create: (_) => blocDistrict,
            child: Provider<RegionalHospitalsData>(
              create: (_) => blocHospital,
              child: ChangeNotifierProvider<ChartType>(
                create: (_) => chartType,
                child: SafeArea(
                    top: false,
                    minimum: EdgeInsets.only(top: 8),
                    child: Builder(
                        builder: (context) => CustomScrollView(
                              key: PageStorageKey("sad"),
                              slivers: <Widget>[
                                SliverOverlapInjector(
                                  // This is the flip side of the SliverOverlapAbsorber above.
                                  handle: NestedScrollView
                                      .sliverOverlapAbsorberHandleFor(context),
                                ),
                                SliverList(
                                    delegate: SliverChildListDelegate(
                                  [
                                    RegionalOverallData(),
                                    HeaderTile(
                                      title: "Yesterday",
                                      days: 1,
                                    ),
                                    HeaderTile(
                                      title: "Last week",
                                      days: 7,
                                    ),
                                    HeaderTile(
                                      title: "Last month",
                                      days: 30,
                                    ),
                                    DistrictData(),
                                    HospitalData(),
                                    ChartSwitch(),
                                    ChartContainer(
                                      title: "Total Confirmed",
                                      child: ChartSwitcher(
                                        cummulative: ChartCummulative(
                                          backgroundColor: Colors.red.shade100,
                                          barColor: charts
                                              .MaterialPalette.red.shadeDefault,
                                          title: "Confirmed",
                                          toolTipColor: Colors.red,
                                          type: "confirmed",
                                        ),
                                        daily: ChartDaily(
                                          backgroundColor: Colors.red.shade100,
                                          barColor: charts
                                              .MaterialPalette.red.shadeDefault,
                                          title: "Confirmed",
                                          toolTipColor: Colors.red,
                                          type: "confirmed",
                                        ),
                                      ),
                                    ),
                                    ChartContainer(
                                      title: "Total Recovered",
                                      child: ChartSwitcher(
                                        cummulative: ChartCummulative(
                                          backgroundColor:
                                              Colors.green.shade100,
                                          barColor: charts.MaterialPalette.green
                                              .shadeDefault,
                                          title: "Recovered",
                                          toolTipColor: Colors.green,
                                          type: "recovered",
                                        ),
                                        daily: ChartDaily(
                                          backgroundColor:
                                              Colors.green.shade100,
                                          barColor: charts.MaterialPalette.green
                                              .shadeDefault,
                                          title: "Recovered",
                                          toolTipColor: Colors.green,
                                          type: "recovered",
                                        ),
                                      ),
                                    ),
                                    ChartContainer(
                                      title: "Total Deceseased",
                                      child: ChartSwitcher(
                                        cummulative: ChartCummulative(
                                          backgroundColor: Colors.grey.shade100,
                                          barColor: charts.MaterialPalette.gray
                                              .shadeDefault,
                                          title: "Deaths",
                                          toolTipColor: Colors.grey,
                                          type: "deaths",
                                        ),
                                        daily: ChartDaily(
                                          backgroundColor: Colors.grey.shade100,
                                          barColor: charts.MaterialPalette.gray
                                              .shadeDefault,
                                          title: "Deaths",
                                          toolTipColor: Colors.grey,
                                          type: "deaths",
                                        ),
                                      ),
                                    ),
                                  ],
                                ))
                              ],
                            ))),
              ),
            ),
          )),
    );
  }
}

class ChartSwitch extends StatelessWidget {
  const ChartSwitch({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ChartType>(
      builder: (c, chartType, _) => SizedBox(
        height: 50,
        width: 50,
        child: CupertinoSegmentedControl<int>(
            children: {0: Text("Cummulative"), 1: Text("Daily")},
            groupValue: chartType.type,
            onValueChanged: (v) {
              chartType.update(v);
            }),
      ),
    );
  }
}
